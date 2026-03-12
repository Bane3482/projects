#pragma once

#include "bitset-iterator.h"
#include "bitset-reference.h"
#include "bitset-view.h"

#include <cstdint>
#include <string_view>

namespace ct {

class BitSet {
public:
  using Value = bool;
  using Word = std::uint64_t;
  using Reference = BitSetReference<Word>;
  using ConstReference = BitSetReference<const Word>;
  using Iterator = BitSetIterator<Word>;
  using ConstIterator = BitSetIterator<const Word>;
  using View = BitSetView<Word>;
  using ConstView = BitSetView<const Word>;

  static constexpr std::size_t NPOS = -1;

  BitSet();

  BitSet(std::size_t size, bool value);

  BitSet(const BitSet& other);

  explicit BitSet(std::string_view str);

  explicit BitSet(const ConstView& other);

  BitSet(ConstIterator first, ConstIterator last);

  BitSet& operator=(const BitSet& other) &;
  BitSet& operator=(std::string_view str) &;
  BitSet& operator=(const ConstView& other) &;

  ~BitSet();

  void swap(BitSet& other) noexcept;

  std::size_t size() const;

  bool empty() const;

  Reference operator[](std::size_t index);
  ConstReference operator[](std::size_t index) const;

  Iterator begin();
  ConstIterator begin() const;

  Iterator end();
  ConstIterator end() const;

  BitSet& operator&=(const ConstView& other) &;
  BitSet& operator|=(const ConstView& other) &;
  BitSet& operator^=(const ConstView& other) &;
  BitSet& operator<<=(std::size_t count) &;
  BitSet& operator>>=(std::size_t count) &;

  BitSet& flip() &;
  BitSet& set() &;
  BitSet& reset() &;

  bool all() const;
  bool any() const;
  std::size_t count() const;

  operator ConstView() const;
  operator View();

  View subview(std::size_t offset = 0, std::size_t count = NPOS);
  ConstView subview(std::size_t offset = 0, std::size_t count = NPOS) const;

private:
  Word* _data{nullptr};
  std::size_t _size{0u};
  static constexpr std::size_t word_len = std::numeric_limits<Word>::digits;

  static std::size_t count_blocks(std::size_t n);
};

bool operator==(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs);

bool operator!=(const BitSet::ConstView& left, const BitSet::ConstView& right);

void swap(BitSet& lhs, BitSet& rhs) noexcept;

BitSet operator&(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs);

BitSet operator|(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs);

BitSet operator^(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs);

BitSet operator~(const BitSet::ConstView& bs);

BitSet operator<<(const BitSet::ConstView& bs, std::size_t count);

BitSet operator>>(const BitSet::ConstView& bs, std::size_t count);

std::string to_string(const BitSet::ConstView& bs);

std::ostream& operator<<(std::ostream& out, const BitSet::ConstView& bs);
} // namespace ct
