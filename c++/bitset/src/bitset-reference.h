#pragma once

#include <limits>
#include <type_traits>

namespace ct {

template <typename T>
class BitSetReference {
public:
  BitSetReference() = delete;

  operator BitSetReference<const T>() const {
    return BitSetReference<const T>(_word, _index);
  }

  BitSetReference& operator=(bool value) {
    if (value) {
      *_word |= (1ULL << (word_len - _index - 1));
    } else {
      *_word &= ~(1ULL << (word_len - _index - 1));
    }
    return *this;
  }

  operator bool() const {
    return (*_word & (1ULL << (word_len - _index - 1))) != 0;
  }

  BitSetReference& flip()
    requires (!std::is_const_v<T>)
  {
    *_word ^= (1ULL << (word_len - _index - 1));
    return *this;
  }

private:
  T* _word;
  std::size_t _index;
  static constexpr std::size_t word_len = std::numeric_limits<T>::digits;

  BitSetReference(T* word, std::size_t index)
      : _word{word}
      , _index{index} {}

  friend class BitSet;
  template <typename U>
  friend class BitSetView;
  template <typename U>
  friend class BitSetIterator;
  template <typename U>
  friend class BitSetReference;
};

} // namespace ct
