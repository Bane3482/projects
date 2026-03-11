#include "bitset.h"

#include <algorithm>
#include <iostream>
#include <string>

namespace ct {

BitSet::BitSet() = default;

BitSet::BitSet(std::size_t size, bool value)
    : _size{size} {
  if (size == 0) {
    return;
  }
  _data = new Word[count_blocks(_size)];
  std::fill(_data, _data + count_blocks(_size), (value ? Word{std::numeric_limits<Word>::max()} : Word{0}));
}

BitSet::BitSet(const BitSet& other)
    : BitSet(other.begin(), other.end()) {}

BitSet::BitSet(std::string_view str)
    : BitSet(str.size(), false) {
  for (std::size_t i = 0; i < str.size(); i++) {
    _data[i / word_len] |= (1ull << (word_len - (i % word_len) - 1)) * (str[i] - '0');
  }
}

BitSet::BitSet(const ConstView& other)
    : BitSet(other.size(), false) {
  operator|=(other);
}

BitSet::BitSet(ConstIterator first, ConstIterator last)
    : BitSet(ConstView(first, last)) {}

BitSet& BitSet::operator=(const BitSet& other) & {
  if (*this != other) {
    BitSet temp(other);
    swap(temp);
  }
  return *this;
}

BitSet& BitSet::operator=(std::string_view str) & {
  BitSet temp(str);
  swap(temp);
  return *this;
}

BitSet& BitSet::operator=(const ConstView& other) & {
  BitSet temp(other);
  swap(temp);
  return *this;
}

BitSet::~BitSet() {
  delete[] _data;
}

void BitSet::swap(BitSet& other) noexcept {
  std::swap(_data, other._data);
  std::swap(_size, other._size);
}

std::size_t BitSet::size() const {
  return _size;
}

bool BitSet::empty() const {
  return size() == 0;
}

BitSet::Reference BitSet::operator[](std::size_t index) {
  return {_data + (index / word_len), index % word_len};
}

BitSet::ConstReference BitSet::operator[](std::size_t index) const {
  return {_data + (index / word_len), index % word_len};
}

BitSet::Iterator BitSet::begin() {
  return {_data, 0};
}

BitSet::ConstIterator BitSet::begin() const {
  return {_data, 0};
}

BitSet::Iterator BitSet::end() {
  return {_data + (size() / word_len), size() % word_len};
}

BitSet::ConstIterator BitSet::end() const {
  return {_data + (size() / word_len), size() % word_len};
}

BitSet& BitSet::operator&=(const ConstView& other) & {
  subview() &= other;
  return *this;
}

BitSet& BitSet::operator|=(const ConstView& other) & {
  subview() |= other;
  return *this;
}

BitSet& BitSet::operator^=(const ConstView& other) & {
  subview() ^= other;
  return *this;
}

BitSet& BitSet::operator<<=(std::size_t count) & {
  BitSet temp(size() + count, false);
  temp.subview(0, size()) |= ConstView(subview());
  swap(temp);
  return *this;
}

BitSet& BitSet::operator>>=(std::size_t count) & {
  BitSet temp(*this);
  if (size() <= count) {
    *this = ConstView(temp.subview(size()));
  } else {
    *this = ConstView(temp.subview(0, size() - count));
  }
  return *this;
}

BitSet& BitSet::flip() & {
  subview().flip();
  return *this;
}

BitSet& BitSet::set() & {
  subview().set();
  return *this;
}

BitSet& BitSet::reset() & {
  subview().reset();
  return *this;
}

bool BitSet::all() const {
  return subview().all();
}

bool BitSet::any() const {
  return subview().any();
}

std::size_t BitSet::count() const {
  return subview().count();
}

BitSet::operator ConstView() const {
  return ConstView(subview());
}

BitSet::operator View() {
  return View(subview());
}

BitSet::View BitSet::subview(std::size_t offset, std::size_t count) {
  return BitSet::View(begin(), end()).subview(offset, count);
}

BitSet::ConstView BitSet::subview(std::size_t offset, std::size_t count) const {
  return BitSet::ConstView(begin(), end()).subview(offset, count);
}

bool operator==(const BitSet::ConstView& left, const BitSet::ConstView& right) {
  if (left.size() != right.size()) {
    return false;
  }
  BitSet tmp(left);
  tmp ^= right;
  return !tmp.any();
}

bool operator!=(const BitSet::ConstView& left, const BitSet::ConstView& right) {
  return !(left == right);
}

void swap(BitSet& lhs, BitSet& rhs) noexcept {
  lhs.swap(rhs);
}

BitSet operator&(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs) {
  BitSet temp(lhs);
  temp &= rhs;
  return temp;
}

BitSet operator|(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs) {
  BitSet temp(lhs);
  temp |= rhs;
  return temp;
}

BitSet operator^(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs) {
  BitSet temp(lhs);
  temp ^= rhs;
  return temp;
}

BitSet operator~(const BitSet::ConstView& bs) {
  BitSet temp(bs);
  temp.flip();
  return temp;
}

BitSet operator<<(const BitSet::ConstView& bs, std::size_t count) {
  BitSet temp(bs);
  temp <<= count;
  return temp;
}

BitSet operator>>(const BitSet::ConstView& bs, std::size_t count) {
  BitSet temp(bs);
  temp >>= count;
  return temp;
}

std::string to_string(const BitSet::ConstView& bs) {
  std::string result;
  for (auto i : bs) {
    result += (static_cast<bool>(i) ? "1" : "0");
  }
  return result;
}

std::ostream& operator<<(std::ostream& out, const BitSet::ConstView& bs) {
  for (auto i : bs) {
    out << (static_cast<bool>(i) ? "1" : "0");
  }
  return out;
}

std::size_t BitSet::count_blocks(std::size_t n) {
  return (n / word_len) + (n % word_len != 0 ? 1 : 0) + 1;
}

} // namespace ct
