#pragma once

#include <cstddef>
#include <memory>

namespace ct {

class LinkedPtrBase {
public:
  mutable LinkedPtrBase* _prev;
  mutable LinkedPtrBase* _next;
};

template <typename T, typename Deleter = std::default_delete<T>>
class LinkedPtr : LinkedPtrBase {
public:
  LinkedPtr() noexcept(std::is_nothrow_default_constructible_v<Deleter>)
      : LinkedPtrBase(nullptr, nullptr) {}

  ~LinkedPtr() {
    if (is_alone()) {
      _deleter(_data);
    } else {
      if (_prev == this) {
        _next->_prev = _next;
      } else if (_next == this) {
        _prev->_next = _prev;
      } else {
        _prev->_next = _next;
        _next->_prev = _prev;
      }
    }
  }

  LinkedPtr(std::nullptr_t) noexcept(std::is_nothrow_default_constructible_v<Deleter>)
      : LinkedPtr() {}

  explicit LinkedPtr(T* ptr) noexcept(std::is_nothrow_default_constructible_v<Deleter>)
      : LinkedPtrBase(this, this)
      , _data(ptr) {}

  LinkedPtr(T* ptr, Deleter deleter) noexcept(std::is_nothrow_move_constructible_v<Deleter>)
      : LinkedPtrBase(this, this)
      , _data{ptr}
      , _deleter{std::move(deleter)} {}

  LinkedPtr(const LinkedPtr& other) noexcept(std::is_nothrow_copy_constructible_v<Deleter>)
      : LinkedPtrBase(nullptr, nullptr)
      , _data{other._data}
      , _deleter{other._deleter} {
    if (_data) {
      _next = _prev = this;
      link(other);
    }
  }

  template <
      typename Y,
      typename D,
      typename = std::enable_if_t<std::is_convertible_v<Y*, T*> && std::is_convertible_v<D, Deleter>>>
  LinkedPtr(const LinkedPtr<Y, D>& other) noexcept(std::is_nothrow_copy_constructible_v<Deleter>)
      : LinkedPtrBase(nullptr, nullptr)
      , _data{other._data}
      , _deleter{other._deleter} {
    if (_data) {
      _next = _prev = this;
      link(other);
    }
  }

  LinkedPtr& operator=(const LinkedPtr& other) noexcept(std::is_nothrow_copy_constructible_v<Deleter>) {
    if (this != &other) {
      LinkedPtr tmp{other};
      swap(tmp);
    }
    return *this;
  }

  template <
      typename Y,
      typename D,
      typename = std::enable_if_t<std::is_convertible_v<Y*, T*> && std::is_convertible_v<D, Deleter>>>
  LinkedPtr& operator=(const LinkedPtr<Y, D>& other) noexcept(std::is_nothrow_copy_constructible_v<Deleter>) {
    LinkedPtr tmp{other};
    swap(tmp);
    return *this;
  }

  T* get() const noexcept {
    return _data;
  }

  explicit operator bool() const noexcept {
    return _data != nullptr;
  }

  T& operator*() const noexcept {
    return *get();
  }

  T* operator->() const noexcept {
    return get();
  }

  std::size_t use_count() const noexcept {
    if (!is_alone() || _next != nullptr) {
      return calc_nodes(this);
    } else {
      return 0;
    }
  }

  void reset() noexcept(std::is_nothrow_default_constructible_v<Deleter>) {
    reset(nullptr);
  }

  void reset(T* new_ptr) noexcept(std::is_nothrow_default_constructible_v<Deleter>) {
    LinkedPtr tmp{new_ptr};
    swap(tmp);
  }

  void reset(T* new_ptr, Deleter deleter) noexcept(std::is_nothrow_move_constructible_v<Deleter>) {
    LinkedPtr tmp{new_ptr, std::move(deleter)};
    swap(tmp);
  }

  friend bool operator==(const LinkedPtr& lhs, const LinkedPtr& rhs) noexcept {
    return lhs.get() == rhs.get();
  }

  friend bool operator!=(const LinkedPtr& lhs, const LinkedPtr& rhs) noexcept {
    return !(lhs == rhs);
  }

  void swap(LinkedPtr& other) noexcept {
    using std::swap;
    swap(_data, other._data);
    swap(_deleter, other._deleter);
    if (is_alone() && _next == nullptr) {
      _next = _prev = this;
    }
    if (!is_alone() && !other.is_alone()) {
      swap_not_alone(other);
    } else if (is_alone()) {
      if (!other.is_alone()) {
        swap_alone(other);
      }
    } else {
      swap(_data, other._data);
      swap(_deleter, other._deleter);
      other.swap(*this);
    }
  }

  void swap_alone(LinkedPtr& other) noexcept {
    if (other._prev == &other) {
      _next = other._next;
      other._next = &other;
      _next->_prev = this;
    } else if (other._next == &other) {
      _prev = other._prev;
      other._prev = &other;
      _prev->_next = this;
    } else {
      _prev = other._prev;
      _next = other._next;
      other._prev->_next = this;
      other._next->_prev = this;
      other._prev = &other;
      other._next = &other;
    }
  }

  void swap_not_alone(LinkedPtr& other) noexcept {
    if ((_prev == this && other._prev == &other) || (_next == this && other._next == &other) ||
        (_prev != this && _next != this && other._prev != &other && other._next != &other)) {
      swap_same(other);
    } else if (_prev == this && other._next == &other) {
      swap_left_right(other);
    } else if (_next == this && other._prev == &other) {
      other.swap_left_right(*this);
    } else {
      if ((_prev == this || _next == this)) {
        other.swap_big_other(*this);
      } else {
        swap_big_other(other);
      }
    }
  }

  void swap_left_right(LinkedPtr& other) noexcept {
    _prev = other._prev;
    other._next = _next;
    _next = this;
    other._prev = &other;
    _prev->_next = this;
    other._next->_prev = &other;
  }

  void swap_same(LinkedPtr& other) noexcept {
    using std::swap;
    if (_prev == this) {
      swap(_next, other._next);
      swap(_next->_prev, other._next->_prev);
    } else if (_next == this) {
      swap(_prev, other._prev);
      swap(_prev->_next, other._prev->_next);
    } else {
      swap(other._next->_prev, _next->_prev);
      swap(other._prev->_next, _prev->_next);
      swap(other._next, _next);
      swap(other._prev, _prev);
    }
  }

  void swap_big_other(LinkedPtr& other) noexcept {
    if (other._prev == &other) {
      std::swap(_next, other._next);
      other._prev = _prev;
      _prev = this;
      _next->_prev = this;
      other._prev->_next = &other;
      other._next->_prev = &other;
    } else {
      std::swap(_prev, other._prev);
      other._next = _next;
      _next = this;
      _prev->_next = this;
      other._prev->_next = &other;
      other._next->_prev = &other;
    }
  }

private:
  template <typename Y, typename D>
  friend class LinkedPtr;

  T* _data{nullptr};
  Deleter _deleter;

  template <
      typename Y,
      typename D,
      typename = std::enable_if<std::convertible_to<Y*, T*> && std::convertible_to<D, Deleter>>>
  void link(const LinkedPtr<Y, D>& other) noexcept {
    if (other._prev == &other) {
      other._prev = this;
      _next = const_cast<LinkedPtr<Y, D>*>(&other);
    } else if (other._next == &other) {
      other._next = this;
      _prev = const_cast<LinkedPtr<Y, D>*>(&other);
    } else {
      this->_prev = other._prev;
      other._prev = this;
      this->_next = const_cast<LinkedPtr<Y, D>*>(&other);
      this->_prev->_next = this;
    }
  }

  std::size_t calc_nodes(const LinkedPtrBase* node, const LinkedPtrBase* pr = nullptr) const noexcept {
    std::size_t nodes = 1;
    if (_next != node && _next != pr) {
      nodes += calc_nodes(_next, node);
    }
    if (_prev != node && _prev != pr) {
      nodes += calc_nodes(_prev, node);
    }
    return nodes;
  }

  bool is_alone() const noexcept {
    return _next == _prev;
  }
};

} // namespace ct
