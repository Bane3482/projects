#pragma once

#include <iterator>
#include <memory>

namespace ct {
template <typename T>
class CircularBuffer {
  template <typename U>
  class BufIterator {
  public:
    using iterator_category = std::random_access_iterator_tag;
    using value_type = T;
    using difference_type = std::ptrdiff_t;
    using pointer = U*;
    using reference = U&;

    BufIterator() = default;

    operator BufIterator<const U>() const {
      return BufIterator<const U>(_buf, _index);
    }

    friend bool operator==(const BufIterator& lhs, const BufIterator& rhs) {
      return lhs._buf == rhs._buf && lhs._index == rhs._index;
    }

    friend bool operator!=(const BufIterator& lhs, const BufIterator& rhs) {
      return !(lhs == rhs);
    }

    reference operator*() const {
      return *(_buf->_data + _index);
    }

    pointer operator->() const {
      return _buf->_data + _index;
    }

    BufIterator& operator++() {
      ++_index;
      return *this;
    }

    BufIterator operator++(int) {
      BufIterator tmp(*this);
      ++*this;
      return tmp;
    }

    BufIterator& operator--() {
      --_index;
      return *this;
    }

    BufIterator operator--(int) {
      BufIterator tmp(*this);
      --*this;
      return tmp;
    }

    friend BufIterator operator+(const BufIterator& other, difference_type val) {
      BufIterator tmp(other);
      tmp._index += val;
      return tmp;
    }

    friend BufIterator operator+(difference_type val, const BufIterator& other) {
      return other + val;
    }

    friend BufIterator operator-(const BufIterator& other, difference_type val) {
      return other + (-val);
    }

    friend difference_type operator-(const BufIterator& first, const BufIterator& second) {
      return first._index - second._index;
    }

    friend bool operator>(const BufIterator& first, const BufIterator& second) {
      return first._buf->_data > second._buf->_data ||
             first._buf->_data == second._buf->_data && first._index > second._index;
    }

    friend bool operator>=(const BufIterator& first, const BufIterator& second) {
      return first > second || first == second;
    }

    friend bool operator<(const BufIterator& first, const BufIterator& second) {
      return !(first >= second);
    }

    friend bool operator<=(const BufIterator& first, const BufIterator& second) {
      return !(first > second);
    }

    BufIterator& operator+=(difference_type val) {
      _index += val;
      return *this;
    }

    BufIterator& operator-=(difference_type val) {
      return *this += -val;
    }

    reference operator[](difference_type val) {
      return *(_buf->_data + sum(_index + _buf->_shift, val));
    }

  private:
    const CircularBuffer* _buf;
    difference_type _index;

    BufIterator(const CircularBuffer* buf, difference_type index)
        : _buf{buf}
        , _index{index} {}

    difference_type sum(difference_type first, difference_type second) const {
      if (_buf->_capacity == 0) {
        return first + second;
      }
      return ((first + second) % _buf->_capacity + _buf->_capacity) % _buf->_capacity;
    }

    friend class CircularBuffer;
  };

public:
  using ValueType = T;

  using Reference = T&;
  using ConstReference = const T&;

  using Pointer = T*;
  using ConstPointer = const T*;

  using Iterator = BufIterator<ValueType>;
  using ConstIterator = BufIterator<const ValueType>;

  using ReverseIterator = std::reverse_iterator<Iterator>;
  using ConstReverseIterator = std::reverse_iterator<ConstIterator>;

public:
  // O(1), nothrow
  CircularBuffer() noexcept = default;

  // O(n), strong
  CircularBuffer(const CircularBuffer& other) : CircularBuffer() {
    if (other._data == nullptr) {
      return;
    }
    CircularBuffer tmp(other.size());
    std::uninitialized_copy_n(other.begin(), other.size(), tmp.begin());
    tmp._size = other._size;
    swap(tmp);
  }

  // O(1), nothrow
  CircularBuffer(CircularBuffer&& other) noexcept {
    swap(other);
  }

  // O(n), strong
  CircularBuffer& operator=(const CircularBuffer& other) {
    if (this != &other) {
      CircularBuffer tmp(other);
      swap(tmp);
    }
    return *this;
  }

  // O(1), nothrow
  CircularBuffer& operator=(CircularBuffer&& other) noexcept {
    swap(other);
  }

  // O(n), nothrow
  ~CircularBuffer() {
    clear();
    dealloc(_data);
  }

  // O(1), nothrow
  size_t size() const noexcept {
    return _size;
  }

  // O(1), nothrow
  bool empty() const noexcept {
    return size() == 0;
  }

  // O(1), nothrow
  size_t capacity() const noexcept {
    return _capacity;
  }

  // O(1), nothrow
  Iterator begin() noexcept {
    return Iterator(this, 0);
  }

  // O(1), nothrow
  ConstIterator begin() const noexcept {
    return ConstIterator(this, 0);
  }

  // O(1), nothrow
  Iterator end() noexcept {
    return Iterator(this, size());
  }

  // O(1), nothrow
  ConstIterator end() const noexcept {
    return ConstIterator(this, size());
  }

  // O(1), nothrow
  ReverseIterator rbegin() noexcept {
    return ReverseIterator(end());
  }

  // O(1), nothrow
  ConstReverseIterator rbegin() const noexcept {
    return ConstReverseIterator(end());
  }

  // O(1), nothrow
  ReverseIterator rend() noexcept {
    return ReverseIterator(begin());
  }

  // O(1), nothrow
  ConstReverseIterator rend() const noexcept {
    return ConstReverseIterator(begin());
  }

  // O(1), nothrow
  T& operator[](std::size_t index) {
    return *(_data + sum(_shift, index));
  }

  // O(1), nothrow
  const T& operator[](size_t index) const {
    return *(_data + sum(_shift, index));
  }

  // O(1), nothrow
  T& back() {
    return *(--end());
  }

  // O(1), nothrow
  const T& back() const {
    return *(--end());
  }

  // O(1), nothrow
  T& front() {
    return *begin();
  }

  // O(1), nothrow
  const T& front() const {
    return *begin();
  }

  // O(1), strong
  void push_back(const T& val) {
    push_back_impl(val);
  }

  // O(1), strong
  void push_back(T&& val) {
    push_back_impl(std::move(val));
  }

  // O(1), strong
  void push_front(const T& val) {
    push_front_impl(val);
  }

  // O(1), strong
  void push_front(T&& val) {
    push_front_impl(std::move(val));
  }

  // O(1), nothrow
  void pop_back() {
    (_data + sum(_shift, size()))->~ValueType();
    --_size;
  }

  // O(1), nothrow
  void pop_front() {
    (_data + sum(_shift, -1))->~ValueType();
    --_size;
    _shift = sum(_shift, -1);
  }

  // O(n), strong
  void reserve(size_t desired_capacity) {}

  // O(n), strong
  Iterator insert(ConstIterator pos, const T& val) {}

  // O(n), strong
  Iterator insert(ConstIterator pos, T&& val) {}

  // O(n), nothrow
  Iterator erase(ConstIterator pos) {}

  // O(n), nothrow
  Iterator erase(ConstIterator first, ConstIterator last) {}

  // O(n), nothrow
  void clear() noexcept {
    while (!empty()) {
      pop_back();
    }
  }

  // O(1), nothrow
  void swap(CircularBuffer& other) noexcept {
    using std::swap;
    swap(_data, other._data);
    swap(_shift, other._shift);
    swap(_capacity, other._capacity);
    swap(_size, other._size);
  }

  // O(1), nothrow
  friend void swap(CircularBuffer& first, CircularBuffer& second) noexcept {
    first.swap(second);
  }

private:
  ValueType* _data{nullptr};
  std::size_t _capacity{0};
  std::size_t _size{0};
  std::size_t _shift{0};

  explicit CircularBuffer(size_t new_capacity)
      : _capacity(new_capacity) {
    if (capacity() != 0) {
      _data = alloc(capacity());
    }
  }

  template <typename U>
  void push_back_impl(U&& value) {
    if (size() < capacity()) {
      new (_data + sum(_shift, size())) ValueType(std::forward<U>(value));
    } else {
      CircularBuffer tmp((capacity() * 2) + 1);
      new (tmp._data + size()) ValueType(std::forward<U>(value));
      for (std::size_t i = 0; i < size(); ++i) {
        tmp.push_back(std::move(operator[](i)));
      }
      swap(tmp);
    }
    ++_size;
  }

  template <typename U>
  void push_front_impl(U&& value) {
    if (size() < capacity()) {
      new (_data + sum(_shift, -1)) ValueType(std::forward<U>(value));
      _shift = sum(_shift, -1);
      ++_size;
    } else {
      CircularBuffer tmp((capacity() * 2) + 1);
      tmp.push_back(std::forward<U>(value));
      for (std::size_t i = 0; i < size(); ++i) {
        tmp.push_back(std::move(operator[](i)));
      }
      swap(tmp);
    }
  }

  static Pointer alloc(std::size_t new_capacity) {
    return static_cast<Pointer>(operator new(
        new_capacity * sizeof(ValueType),
        static_cast<std::align_val_t>(alignof(ValueType))
    ));
  }

  static void dealloc(Pointer ptr) {
    operator delete(ptr, static_cast<std::align_val_t>(alignof(ValueType)));
  }

  std::size_t sum(std::ptrdiff_t first, std::ptrdiff_t second) const {
    if (capacity() == 0) {
      return first + second;
    }
    return ((first + second) % capacity() + capacity()) % capacity();
  }
};
} // namespace ct
