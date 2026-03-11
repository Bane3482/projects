#pragma once

#include <algorithm>
#include <memory>
#include <type_traits>

namespace ct {

template <typename T, std::size_t SMALL_SIZE>
class SocowVector {
  static_assert(std::is_copy_constructible_v<T>, "T must have a copy constructor");
  static_assert(std::is_nothrow_move_constructible_v<T>, "T must have a non-throwing move constructor");
  static_assert(std::is_copy_assignable_v<T>, "T must have a copy assignment operator");
  static_assert(std::is_nothrow_move_assignable_v<T>, "T must have a non-throwing move assignment operator");
  static_assert(std::is_nothrow_swappable_v<T>, "T must have a non-throwing swap");
  static_assert(SMALL_SIZE > 0, "SMALL_SIZE must be positive");

public:
  using ValueType = T;
  using ConstValueType = const T;

  using Pointer = T*;
  using ConstPointer = const T*;

  using Reference = T&;
  using ConstReference = const T&;

  using Iterator = Pointer;
  using ConstIterator = ConstPointer;

  SocowVector() noexcept
      : _size{0}
      , _is_small{true} {}

  SocowVector(const SocowVector& other)
      : _size{other._size}
      , _is_small{other._is_small} {
    if (_is_small) {
      std::uninitialized_copy_n(other.const_data(), size(), _small_data);
      _is_small = true;
    } else {
      _big_data = other._big_data;
      _big_data->_ref++;
    }
  }

  SocowVector(SocowVector&& other) noexcept {
    swap(other);
  }

  ~SocowVector() {
    delete_data();
  }

  SocowVector& operator=(const SocowVector& other) {
    if (this != &other) {
      SocowVector tmp(other);
      if (is_alone()) {
        clear();
      }
      swap(tmp);
    }
    return *this;
  }

  SocowVector& operator=(SocowVector&& other) noexcept {
    if (this != &other) {
      delete_data();
      _is_small = true;
      _size = 0;
      swap(other);
    }
    return *this;
  }

  std::size_t size() const {
    return _size;
  }

  std::size_t capacity() const {
    return (_is_small) ? SMALL_SIZE : _big_data->_capacity;
  }

  bool empty() const {
    return size() == 0;
  }

  Pointer data() {
    if (_is_small) {
      return _small_data;
    }
    unshare();
    return _big_data->_data;
  }

  ConstPointer data() const {
    return const_data();
  }

  Reference operator[](std::size_t index) {
    return *(data() + index);
  }

  ConstReference operator[](std::size_t index) const {
    return *(const_data() + index);
  }

  Reference front() {
    return *(data());
  }

  ConstReference front() const {
    return *(data());
  }

  Reference back() {
    return *(data() + size() - 1);
  }

  ConstReference back() const {
    return *(data() + size() - 1);
  }

  Iterator begin() {
    return data();
  }

  ConstIterator begin() const {
    return data();
  }

  Iterator end() {
    return data() + size();
  }

  ConstIterator end() const {
    return data() + size();
  }

  void push_back(ConstReference value) {
    push_back_impl(value);
  }

  void push_back(ValueType&& value) {
    push_back_impl(std::move(value));
  }

  void pop_back() {
    if (is_alone()) {
      (data() + (_size - 1))->~T();
      --_size;
    } else {
      SocowVector tmp(capacity());
      std::uninitialized_copy_n(const_data(), size() - 1, tmp.data());
      tmp._size = size() - 1;
      swap(tmp);
    }
  }

  Iterator insert(ConstIterator pos, ConstReference value) {
    return insert_impl(pos, value);
  }

  Iterator insert(ConstIterator pos, ValueType&& value) {
    return insert_impl(pos, std::move(value));
  }

  Iterator erase(ConstIterator pos) {
    return erase(pos, pos + 1);
  }

  Iterator erase(ConstIterator first, ConstIterator last) {
    const std::size_t diff = last - first;
    const std::size_t cnt1 = first - const_begin();
    const std::size_t cnt2 = last - const_begin();
    if (is_alone()) {
      std::rotate(begin() + cnt1, begin() + cnt1 + diff, begin() + cnt1 + (const_end() - last) + diff);
      for (std::size_t i = 0; i < diff; ++i) {
        pop_back();
      }
    } else {
      SocowVector tmp(capacity());
      for (std::size_t i = 0; i < cnt1; ++i) {
        tmp.push_back(const_data()[i]);
      }
      for (std::size_t i = cnt2; i < size(); ++i) {
        tmp.push_back(const_data()[i]);
      }
      swap(tmp);
    }
    return data() + cnt1;
  }

  void reserve(std::size_t new_capacity) {
    if (new_capacity <= capacity()) {
      if (is_alone() || size() > new_capacity || new_capacity > SMALL_SIZE) {
        return;
      }
    }
    SocowVector tmp(new_capacity);
    fill_mem(tmp);
  }

  void shrink_to_fit() {
    if (size() == capacity() || _is_small) {
      return;
    }
    SocowVector tmp(size());
    fill_mem(tmp);
  }

  void clear() noexcept {
    if (is_alone()) {
      while (!empty()) {
        pop_back();
      }
    } else {
      --_big_data->_ref;
      _is_small = true;
      _size = 0;
    }
  }

  void swap(SocowVector& other) noexcept {
    if (this == &other) {
      return;
    }
    if (_is_small == other._is_small) {
      if (_is_small) {
        swap_small(other);
      } else {
        swap_big(other);
      }
    } else {
      swap_diff(other);
    }
    std::swap(_size, other._size);
    std::swap(_is_small, other._is_small);
  }

  friend std::ostream& operator<<(std::ostream& out, const SocowVector& other) noexcept {
    for (auto& i : other) {
      out << i << ' ';
    }
    return out;
  }

private:
  struct dynamic_buf {
    explicit dynamic_buf(std::size_t new_capacity) noexcept
        : _capacity(new_capacity) {}

    std::size_t _capacity{0};
    std::size_t _ref{1};
    ValueType _data[0];
  };

  explicit SocowVector(std::size_t new_capacity) {
    if (new_capacity > SMALL_SIZE) {
      _big_data = alloc(new_capacity);
      _is_small = false;
    } else {
      _is_small = true;
    }
  }

  void fill_mem(SocowVector& tmp) {
    if (is_alone()) {
      std::uninitialized_move_n(data(), size(), tmp.data());
    } else {
      std::uninitialized_copy_n(const_data(), size(), tmp.data());
    }
    tmp._size = size();
    swap(tmp);
  }

  template <typename U>
  void push_back_impl(U&& value) {
    if (size() < capacity()) {
      new (data() + size()) ValueType{std::forward<U>(value)};
      ++_size;
      return;
    }
    push_back_reserve(std::forward<U>(value), (capacity() * 2) + 1);
  }

  template <typename U>
  Iterator insert_impl(ConstIterator pos, U&& value) {
    std::size_t cnt = pos - const_begin();
    push_back(std::forward<U>(value));
    std::rotate(begin() + cnt, end() - 1, end());
    return begin() + cnt;
  }

  template <typename U>
  void push_back_reserve(U&& value, const std::size_t new_capacity) {
    SocowVector tmp(new_capacity);
    if (!is_alone()) {
      for (std::size_t i = 0; i < size(); i++) {
        tmp.push_back(const_data()[i]);
      }
      new (tmp.data() + size()) ValueType{std::forward<U>(value)};
    } else {
      new (tmp.data() + size()) ValueType{std::forward<U>(value)};
      for (std::size_t i = 0; i < size(); i++) {
        tmp.push_back(std::move(data()[i]));
      }
    }
    ++tmp._size;
    swap(tmp);
  }

  void swap_small(SocowVector& other) noexcept {
    std::size_t min_size = std::min(size(), other.size());
    std::swap_ranges(_small_data, _small_data + min_size, other._small_data);
    std::uninitialized_move_n(_small_data + min_size, size() - min_size, other._small_data + min_size);
    std::destroy_n(_small_data + min_size, size() - min_size);
    std::uninitialized_move_n(other._small_data + min_size, other.size() - min_size, _small_data + min_size);
    std::destroy_n(other._small_data + min_size, other.size() - min_size);
  }

  void swap_big(SocowVector& other) noexcept {
    std::swap(_big_data, other._big_data);
  }

  void swap_diff(SocowVector& other) noexcept {
    if (_is_small) {
      auto tmp = other._big_data;
      std::uninitialized_move_n(_small_data, size(), other._small_data);
      std::destroy_n(_small_data, size());
      _big_data = tmp;
    } else {
      other.swap_diff(*this);
    }
  }

  bool is_alone() const {
    return _is_small || _big_data->_ref == 1;
  }

  void unshare() {
    if (!is_alone()) {
      cow();
    }
  }

  void cow() {
    dynamic_buf* tmp = alloc(capacity());
    try {
      std::uninitialized_copy_n(_big_data->_data, size(), tmp->_data);
    } catch (...) {
      dealloc(tmp);
      throw;
    }
    --_big_data->_ref;
    _big_data = tmp;
  }

  ConstPointer const_data() const {
    return (_is_small ? _small_data : _big_data->_data);
  }

  ConstIterator const_begin() const {
    return const_data();
  }

  ConstIterator const_end() const {
    return const_data() + size();
  }

  static dynamic_buf* alloc(std::size_t new_capacity) {
    auto* mem = operator new(
        sizeof(dynamic_buf) + (sizeof(ValueType) * new_capacity),
        static_cast<std::align_val_t>(alignof(dynamic_buf))
    );
    auto tmp = new (mem) dynamic_buf(new_capacity);
    return tmp;
  }

  void delete_data() noexcept {
    if (_is_small) {
      std::destroy_n(_small_data, size());
    } else {
      delete_dyn_buf(_big_data, size());
    }
  }

  void delete_dyn_buf(dynamic_buf* ptr, std::size_t n) noexcept {
    if (ptr->_ref > 1) {
      --ptr->_ref;
    } else {
      std::destroy_n(ptr->_data, n);
      dealloc(ptr);
    }
  }

  static void dealloc(dynamic_buf* ptr) noexcept {
    operator delete(ptr, static_cast<std::align_val_t>(alignof(dynamic_buf)));
  }

  std::size_t _size{0};

  union {
    ValueType _small_data[SMALL_SIZE];
    dynamic_buf* _big_data;
  };

  bool _is_small{true};
};

} // namespace ct
