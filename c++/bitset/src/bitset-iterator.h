#pragma once
#include "bitset-reference.h"

#include <cstdint>
#include <iterator>

namespace ct {

template <typename T>
class BitSetIterator {
public:
  using iterator_category = std::random_access_iterator_tag;
  using value_type = bool;
  using difference_type = std::ptrdiff_t;
  using reference = BitSetReference<T>;
  using pointer = void;
  using Word = T;

  BitSetIterator() = default;

  operator BitSetIterator<const T>() const {
    return BitSetIterator<const T>(_word, _index);
  }

  friend bool operator==(const BitSetIterator& first, const BitSetIterator& second) {
    return first._word == second._word && first._index == second._index;
  }

  friend bool operator!=(const BitSetIterator& first, const BitSetIterator& second) {
    return !(first == second);
  }

  friend bool operator<(const BitSetIterator& first, const BitSetIterator& second) {
    return first._word < second._word || (first._word == second._word && first._index < second._index);
  }

  friend bool operator>(const BitSetIterator& first, const BitSetIterator& second) {
    return second < first;
  }

  friend bool operator<=(const BitSetIterator& first, const BitSetIterator& second) {
    return !(first > second);
  }

  friend bool operator>=(const BitSetIterator& first, const BitSetIterator& second) {
    return !(first < second);
  }

  BitSetIterator& operator++() {
    ++_index;
    if (_index == word_len) {
      ++_word;
      _index = 0;
    }
    return *this;
  }

  BitSetIterator operator++(int) {
    BitSetIterator tmp = *this;
    ++(*this);
    return tmp;
  }

  BitSetIterator& operator--() {
    if (_index == 0) {
      --_word;
      _index = word_len;
    }
    --_index;
    return *this;
  }

  BitSetIterator operator--(int) {
    BitSetIterator tmp = *this;
    --(*this);
    return tmp;
  }

  BitSetIterator& operator+=(difference_type n) {
    auto diff_index = static_cast<difference_type>(_index);
    auto diff_N = static_cast<difference_type>(word_len);
    diff_index += n;
    _word += diff_index / diff_N - (diff_index >= 0 ? 0 : ((diff_index % diff_N != 0) ? 1 : 0));
    _index = (diff_index % diff_N + diff_N) % diff_N;
    return *this;
  }

  BitSetIterator& operator-=(difference_type n) {
    (*this) += (-n);
    return *this;
  }

  friend BitSetIterator operator+(const BitSetIterator& first, difference_type n) {
    BitSetIterator tmp = first;
    tmp += n;
    return tmp;
  }

  friend BitSetIterator operator+(difference_type n, const BitSetIterator& first) {
    return first + n;
  }

  friend BitSetIterator operator-(const BitSetIterator& first, difference_type n) {
    return first + (-n);
  }

  friend difference_type operator-(const BitSetIterator& first, const BitSetIterator& second) {
    return (static_cast<difference_type>(first._word - second._word) * static_cast<difference_type>(word_len)) +
           (static_cast<difference_type>(first._index) - static_cast<difference_type>(second._index));
  }

  reference operator*() const {
    return {_word, _index};
  }

  reference operator[](const difference_type n) const {
    BitSetIterator tmp = *this;
    tmp += n;
    return *tmp;
  }

private:
  Word* _word;
  std::size_t _index;
  static constexpr std::size_t word_len = std::numeric_limits<Word>::digits;

  BitSetIterator(Word* word, std::size_t index)
      : _word(word)
      , _index(index) {}

  std::size_t index() const {
    return _index;
  }

  std::uint64_t get_bits(std::size_t bits) const {
    if (bits == 0) {
      return 0;
    }
    if (index() + bits <= word_len) {
      return shift_right(shift_left(shift_right(*_word, word_len - index() - bits), word_len - bits), word_len - bits);
    }
    return shift_right(shift_left(*_word, index()), word_len - bits) +
           shift_right(*(_word + 1), word_len - (bits - (word_len - index())));
  }

  void set_bits(std::size_t bits, Word value) const {
    if (bits == 0) {
      return;
    }
    value = shift_right(shift_left(value, word_len - bits), word_len - bits);
    if (index() + bits <= word_len) {
      *_word = shift_left(shift_right(*_word, word_len - index()), word_len - index()) +
               shift_right(shift_left(*_word, index() + bits), index() + bits) +
               shift_left(value, word_len - index() - bits);
    } else {
      *_word = shift_left(shift_right(*_word, word_len - index()), word_len - index()) +
               shift_right(value, bits - (word_len - index()));
      *(_word + 1) = shift_right(shift_left(*(_word + 1), bits - (word_len - index())), bits - (word_len - index())) +
                     shift_left(value, word_len - (bits - (word_len - index())));
    }
  }

  static Word shift_left(Word word, std::size_t index) {
    if (index == word_len) {
      return (word << (index - 1)) << 1;
    }
    return word << index;
  }

  static Word shift_right(Word word, std::size_t index) {
    if (index == word_len) {
      return (word >> (index - 1)) >> 1;
    }
    return word >> index;
  }

  template <typename U>
  friend class BitSetView;
  friend class BitSet;
  template <typename U>
  friend class BitSetIterator;
};

} // namespace ct
