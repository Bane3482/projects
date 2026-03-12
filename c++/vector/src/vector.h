#pragma once

namespace ct {

template <typename T>
class Vector {
  static_assert(std::is_nothrow_move_constructible_v<T> || std::is_copy_constructible_v<T>);

public:
  using ValueType = T;

  using Reference = T&;
  using ConstReference = const T&;

  using Pointer = T*;
  using ConstPointer = const T*;

  using Iterator = Pointer;
  using ConstIterator = ConstPointer;

public:
  // O(1) nothrow
  Vector() noexcept = default;

  // O(N) strong
  Vector(const Vector& other) {
    if (other.data() == nullptr) {
      _data = nullptr;
      return;
    }
    Vector tmp{other.size()};
    for (std::size_t i = 0; i < other.size(); ++i) {
      tmp.push_back(other[i]);
    }
    swap(tmp);
  }

  // O(1) nothrow
  Vector(Vector&& other) noexcept {
    swap(other);
  }

  // O(N) strong
  Vector& operator=(const Vector& other) {
    if (this != &other) {
      Vector tmp(other);
      swap(tmp);
    }
    return *this;
  }

  // O(1) strong
  Vector& operator=(Vector&& other) noexcept {
    Vector tmp(std::move(other));
    tmp.swap(*this);
    return *this;
  }

  // O(N) nothrow
  ~Vector() noexcept {
    while (!empty()) {
      pop_back();
    }
    dealloc(_data);
  }

  // O(1) nothrow
  Reference operator[](size_t index) {
    return *(data() + index);
  }

  // O(1) nothrow
  ConstReference operator[](size_t index) const {
    return *(data() + index);
  }

  // O(1) nothrow
  Pointer data() noexcept {
    return _data;
  }

  // O(1) nothrow
  ConstPointer data() const noexcept {
    return _data;
  }

  // O(1) nothrow
  size_t size() const noexcept {
    return _size;
  }

  // O(1) nothrow
  Reference front() {
    return operator[](0);
  }

  // O(1) nothrow
  ConstReference front() const {
    return operator[](0);
  }

  // O(1) nothrow
  Reference back() {
    return operator[](size() - 1);
  }

  // O(1) nothrow
  ConstReference back() const {
    return operator[](size() - 1);
  }

  // O(1)* strong
  void push_back(const T& value) {
    push_back_impl(value);
  }

  // O(1)* strong if move nothrow
  void push_back(T&& value) {
    push_back_impl(std::move(value));
  }

  template <typename U>
  void push_back_impl(U&& value) {
    if (size() == capacity()) {
      Vector tmp((capacity() * 2) + 1);
      new (tmp.data() + size()) ValueType(std::forward<U>(value));
      try {
        if (std::is_nothrow_move_constructible_v<T>) {
          for (std::size_t i = 0; i < size(); ++i) {
            tmp.push_back(std::move(operator[](i)));
          }
        } else {
          for (std::size_t i = 0; i < size(); ++i) {
            tmp.push_back(operator[](i));
          }
        }
      } catch (...) {
        (tmp.data() + size())->~ValueType();
        throw;
      }
      ++tmp._size;
      swap(tmp);
    } else {
      new (data() + _size) ValueType(std::forward<U>(value));
      ++_size;
    }
  }

  // O(1) nothrow
  void pop_back() {
    (data() + size() - 1)->~ValueType();
    --_size;
  }

  // O(1) nothrow
  bool empty() const noexcept {
    return size() == 0;
  }

  // O(1) nothrow
  std::size_t capacity() const noexcept {
    return _capacity;
  }

  // O(N) strong
  void reserve(std::size_t new_capacity) {
    if (new_capacity <= capacity()) {
      return;
    }
    Vector tmp(new_capacity);
    fill_mem(tmp);
  }

  // O(N) strong
  void shrink_to_fit() {
    if (size() == capacity()) {
      return;
    }
    Vector tmp(size());
    fill_mem(tmp);
  }

  // O(N) nothrow
  void clear() noexcept {
    while (!empty()) {
      pop_back();
    }
    _size = 0;
  }

  // O(1) nothrow
  void swap(Vector& other) noexcept {
    using std::swap;
    swap(_data, other._data);
    swap(_size, other._size);
    swap(_capacity, other._capacity);
  }

  // O(1) nothrow
  Iterator begin() noexcept {
    return data();
  }

  // O(1) nothrow
  Iterator end() noexcept {
    return data() + _size;
  }

  // O(1) nothrow
  ConstIterator begin() const noexcept {
    return data();
  }

  // O(1) nothrow
  ConstIterator end() const noexcept {
    return data() + _size;
  }

  // O(N) strong
  Iterator insert(ConstIterator pos, const T& value) {
    return insert_impl(pos, value);
  }

  // O(N) strong if move nothrow
  Iterator insert(ConstIterator pos, T&& value) {
    return insert_impl(pos, std::move((value)));
  }

  template <typename U>
  Iterator insert_impl(ConstIterator pos, U&& value) {
    std::size_t pos_t = pos - begin();
    push_back(std::forward<U>(value));
    Iterator it = end() - 1;
    Iterator new_pos = begin() + pos_t;
    for (; it > new_pos; --it) {
      std::swap(*(it), *(it - 1));
    }
    return it;
  }

  // O(N) nothrow(swap)
  Iterator erase(ConstIterator pos) {
    return erase(pos, pos + 1);
  }

  // O(N) nothrow(swap)
  Iterator erase(ConstIterator first, ConstIterator last) {
    std::size_t cnt1 = (last - first);
    std::size_t cnt2 = (first - begin());
    for (std::size_t i = 0; i + cnt1 + cnt2 < size(); ++i) {
      std::swap(*(begin() + i + cnt2), *(begin() + i + cnt2 + cnt1));
    }
    while ((cnt1--) != 0u) {
      pop_back();
    }
    return begin() + cnt2;
  }

private:
  Pointer _data{nullptr};
  std::size_t _size{0};
  std::size_t _capacity{0};

  explicit Vector(std::size_t new_capacity)
      : _capacity{new_capacity} {
    if (capacity() != 0) {
      _data = alloc(capacity());
    }
  }

  void fill_mem(Vector& tmp) {
    for (std::size_t i = 0; i < size(); ++i) {
      if (std::is_nothrow_move_constructible_v<T>) {
        tmp.push_back(std::move(operator[](i)));
      } else {
        tmp.push_back(operator[](i));
      }
    }
    swap(tmp);
  }

  static Pointer alloc(std::size_t cap) {
    return static_cast<Pointer>(operator new(sizeof(ValueType) * cap, static_cast<std::align_val_t>(alignof(ValueType)))
    );
  }

  static void dealloc(Pointer ptr) noexcept {
    if (ptr) {
      operator delete(ptr, static_cast<std::align_val_t>(alignof(ValueType)));
      ptr = nullptr;
    }
  }
};

} // namespace ct
