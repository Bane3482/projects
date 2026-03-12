#pragma once
#include "bitset-iterator.h"

namespace ct {

class BitSet;

template <typename T>
class BitSetView {
public:
  using Value = bool;
  using Reference = BitSetReference<T>;
  using ConstReference = BitSetReference<const T>;
  using View = BitSetView<T>;
  using ConstView = BitSetView<const T>;
  using Iterator = BitSetIterator<T>;
  using ConstIterator = BitSetIterator<const T>;
  using Word = T;

  static constexpr std::size_t NPOS = -1;

  BitSetView(Iterator begin, Iterator end)
      : _begin(begin)
      , _end(end) {}

  Reference operator[](std::size_t index) const {
    return begin()[index];
  }

  Iterator begin() const {
    return _begin;
  }

  Iterator end() const {
    return _end;
  }

  std::size_t size() const {
    return end() - begin();
  }

  bool empty() const {
    return begin() == end();
  }

  BitSetView operator&=(const ConstView& other) const {
    do_bin_op(other, std::bit_and<Word>());
    return *this;
  }

  BitSetView operator|=(const ConstView& other) const {
    do_bin_op(other, std::bit_or<Word>());
    return *this;
  }

  BitSetView operator^=(const ConstView& other) const {
    do_bin_op(other, std::bit_xor<Word>());
    return *this;
  }

  BitSetView flip() const {
    do_un_op(std::bit_not<Word>());
    return *this;
  }

  BitSetView set() const {
    do_un_op([](Word) -> Word { return std::numeric_limits<Word>::max(); });
    return *this;
  }

  BitSetView reset() const {
    do_un_op([](Word) -> Word { return 0ULL; });
    return *this;
  }

  bool all() const {
    return do_bits_op([](Word w, std::size_t offset) -> std::size_t { return !check_bits(w, offset); }, true) == 0;
  }

  bool any() const {
    return do_bits_op([](Word w, std::size_t) -> std::size_t { return w != 0; }, true) != 0;
  }

  std::size_t count() const {
    return do_bits_op([](Word w, std::size_t) -> std::size_t { return count_true_bits(w); }, false);
  }

  operator ConstView() const {
    return ConstView(begin(), end());
  }

  BitSetView subview(std::size_t offset = 0, std::size_t count = NPOS) const {
    if (offset >= size()) {
      return BitSetView(end(), end());
    }
    if (count > size() - offset) {
      return BitSetView(begin() + offset, end());
    }
    return BitSetView(begin() + offset, begin() + offset + count);
  }

  friend void swap(BitSetView& first, BitSetView& second) noexcept {
    first.swap(second);
  }

  void swap(BitSetView& other) noexcept {
    std::swap(_begin, other._begin);
    std::swap(_end, other._end);
  }

private:
  Iterator _begin;
  Iterator _end;
  static constexpr std::size_t word_len = std::numeric_limits<Word>::digits;

  Word get(std::size_t index, std::size_t bits) const {
    return (begin() + index).get_bits(bits);
  }

  void set(std::size_t index, std::size_t bits, Word value) const {
    (begin() + index).set_bits(bits, value);
  }

  static bool check_bits(Word word, std::size_t bits) {
    if (bits == word_len) {
      return word == std::numeric_limits<Word>::max();
    }
    return word == (1ULL << bits) - 1;
  }

  static std::size_t count_true_bits(Word word) {
    std::size_t cnt = 0;
    for (std::size_t i = 0; i < word_len; ++i) {
      cnt += ((word & (1ULL << i)) != 0 ? 1 : 0);
    }
    return cnt;
  }

  template <typename Func>
  std::size_t do_bits_op(Func f, bool short_circuit) const {
    if (size() <= word_len - begin().index()) {
      return f(get(0, size()), size());
    }
    std::size_t cnt = 0;
    std::size_t offset = word_len - begin().index();
    cnt += f(get(0, offset), offset);
    if (cnt && short_circuit) {
      return cnt;
    }
    std::size_t i = 0;
    for (; size() - offset - (i * word_len) >= word_len; ++i) {
      cnt += f(get(offset + (i * word_len), word_len), word_len);
    }
    if (cnt && short_circuit) {
      return cnt;
    }
    return cnt + f(get(offset + (i * word_len), size() - offset - (i * word_len)), size() - offset - (i * word_len));
  }

  template <typename Func>
  void do_un_op(Func f) const {
    if (size() <= word_len - begin().index()) {
      set(0, size(), f(get(0, size())));
      return;
    }
    std::size_t offset = word_len - begin().index();
    set(0, offset, f(get(0, offset)));
    std::size_t i = 0;
    for (; size() - offset - (i * word_len) >= word_len; ++i) {
      set(offset + (i * word_len), word_len, f(get(offset + (i * word_len), word_len)));
    }
    set(offset + (i * word_len),
        size() - offset - (i * word_len),
        f(get(offset + (i * word_len), size() - offset - (i * word_len))));
  }

  template <typename Func>
  void do_bin_op(const ConstView& other, Func f) const {
    if (size() <= word_len - begin().index()) {
      set(0, size(), f(get(0, size()), other.get(0, size())));
      return;
    }
    std::size_t offset = word_len - begin().index();
    set(0, offset, f(get(0, offset), other.get(0, offset)));
    std::size_t i = 0;
    for (; size() - offset - (i * word_len) >= word_len; ++i) {
      set(offset + (i * word_len),
          word_len,
          f(get(offset + (i * word_len), word_len), other.get(offset + (i * word_len), word_len)));
    }
    set(offset + (i * word_len),
        size() - offset - (i * word_len),
        f(get(offset + (i * word_len), size() - offset - (i * word_len)),
          other.get(offset + (i * word_len), size() - offset - (i * word_len))));
  }

  friend class BitSet;
  template <typename U>
  friend class BitSetView;
};

} // namespace ct
