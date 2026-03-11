#pragma once

#include <cstddef>
#include <memory>

namespace ct {

template <typename T, typename Deleter = std::default_delete<T>>
class SharedPtr {
  class Obj {
    using Pointer = T*;

    Obj() noexcept = default;

    ~Obj() {
      if (_data) {
        _deleter(_data);
      }
    }

  private:
    friend class SharedPtr;

    Pointer _data{nullptr};
    Deleter _deleter;
    std::size_t _ref{0};

    Obj(Pointer data, std::size_t ref)
        : _data{data}
        , _ref{ref} {}

    void add_ref() noexcept {
      ++_ref;
    }

    void decrease_ref() noexcept {
      --_ref;
      if (_ref == 0) {
        delete this;
      }
    }

    Obj(Pointer data, Deleter deleter, std::size_t ref)
        : _data{data}
        , _deleter{std::move(deleter)}
        , _ref{ref} {}
  };

public:
  SharedPtr() noexcept = default;

  ~SharedPtr() {
    decrease_ref();
  }

  SharedPtr(std::nullptr_t) noexcept
      : SharedPtr() {}

  explicit SharedPtr(T* ptr) try
      : _obj{new Obj{ptr, 1}} {
  } catch (...) {
    delete (ptr);
    throw;
  }

  SharedPtr(T* ptr, Deleter deleter) try
      : _obj{new Obj{ptr, std::move(deleter), 1}} {
  } catch (...) {
    deleter(ptr);
    throw;
  }

  SharedPtr(const SharedPtr& other) noexcept
      : _obj{other._obj} {
    add_ref();
  }

  SharedPtr& operator=(const SharedPtr& other) noexcept {
    if (this != &other) {
      SharedPtr tmp{other};
      swap(tmp);
    }
    return *this;
  }

  T* get() const noexcept {
    return _obj ? _obj->_data : nullptr;
  }

  explicit operator bool() const noexcept {
    return _obj && _obj->_data != nullptr;
  }

  T& operator*() const noexcept {
    return *get();
  }

  T* operator->() const noexcept {
    return get();
  }

  std::size_t use_count() const noexcept {
    return (_obj) ? _obj->_ref : 0;
  }

  void reset() noexcept {
    reset(nullptr);
  }

  void reset(T* new_ptr) {
    SharedPtr tmp{new_ptr};
    swap(tmp);
  }

  void reset(T* new_ptr, Deleter deleter) {
    SharedPtr tmp{new_ptr, std::move(deleter)};
    swap(tmp);
  }

  friend bool operator==(const SharedPtr& lhs, const SharedPtr& rhs) noexcept {
    return lhs.get() == rhs.get();
  }

  friend bool operator!=(const SharedPtr& lhs, const SharedPtr& rhs) noexcept {
    return !(lhs == rhs);
  }

  void swap(SharedPtr& other) noexcept {
    std::swap(_obj, other._obj);
  }

private:
  Obj* _obj{nullptr};

  void add_ref() noexcept {
    if (_obj) {
      _obj->add_ref();
    }
  }

  void decrease_ref() noexcept {
    if (_obj) {
      _obj->decrease_ref();
    }
  }
};

} // namespace ct
