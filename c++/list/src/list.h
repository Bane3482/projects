#pragma once

#include <cassert>
#include <cstddef>
#include <iterator>

namespace ct {

template <typename T>
class List {
  struct Node {
    Node()
        : _prev{nullptr}
        , _next{nullptr} {}

    Node(Node* prev, Node* next)
        : _prev{prev}
        , _next{next} {}

    virtual bool has_value() {
      return false;
    }

    virtual ~Node() {
      if (_prev) {
        _prev->_next = _next;
      }
      if (_next) {
        _next->_prev = _prev;
      }
    }

    Node* _prev;
    Node* _next;
  };

  struct ValueNode : Node {
    ValueNode() = delete;

    ValueNode(Node* prev, Node* next, const T& value)
        : Node(prev, next)
        , _value(value) {}

    ValueNode(Node* prev, Node* next, T&& value)
        : Node(prev, next)
        , _value(std::move(value)) {}

    bool has_value() override {
      return true;
    }

    T _value;
  };

  template <bool isConst>
  class ListIterator {
    Node* _it;

    explicit ListIterator(Node* it)
        : _it{it} {}

    Node* get_node() const {
      return _it;
    }

  public:
    friend class List;

    template <bool otherIsConst>
    friend class ListIterator;

    using difference_type = std::ptrdiff_t;
    using iterator_category = std::bidirectional_iterator_tag;
    using value_type = T;
    using pointer = std::conditional_t<isConst, const T*, T*>;
    using reference = std::conditional_t<isConst, const T&, T&>;

    ListIterator() = default;

    explicit ListIterator(std::nullptr_t) = delete;

    ~ListIterator() = default;

    operator ListIterator<true>() const {
      return ListIterator<true>(_it);
    }

    reference operator*() const {
      return static_cast<ValueNode*>(_it)->_value;
    }

    pointer operator->() const {
      return &static_cast<ValueNode*>(_it)->_value;
    }

    ListIterator& operator++() {
      _it = _it->_next;
      return *this;
    }

    ListIterator operator++(int) {
      ListIterator tmp = *this;
      ++(*this);
      return tmp;
    }

    ListIterator& operator--() {
      _it = _it->_prev;
      return *this;
    }

    ListIterator operator--(int) {
      ListIterator tmp = *this;
      --(*this);
      return tmp;
    }

    template <bool otherConst>
    bool operator==(const ListIterator<otherConst>& other) const {
      return _it == other.get_node();
    }

    template <bool otherConst>
    bool operator!=(const ListIterator<otherConst>& other) const {
      return _it != other.get_node();
    }
  };

  Node endIt;
  mutable std::size_t _size = 0;
  mutable bool _is_actual = true;

public:
  using ValueType = T;

  using Reference = T&;
  using ConstReference = const T&;

  using Pointer = T*;
  using ConstPointer = const T*;

  using Iterator = ListIterator<false>;
  using ConstIterator = ListIterator<true>;

  using ReverseIterator = std::reverse_iterator<Iterator>;
  using ConstReverseIterator = std::reverse_iterator<ConstIterator>;

public:
  friend void swap(List& left, List& right) noexcept {
    using std::swap;
    swap(left._size, right._size);
    swap(left._is_actual, right._is_actual);
    swap(left.endIt._next, right.endIt._next);
    swap(left.endIt._prev, right.endIt._prev);
    if (left.endIt._next == &right.endIt) {
      left.endIt._next = &left.endIt;
      left.endIt._prev = &left.endIt;
    } else {
      left.endIt._next->_prev = &left.endIt;
      left.endIt._prev->_next = &left.endIt;
    }
    if (right.endIt._next == &left.endIt) {
      right.endIt._next = &right.endIt;
      right.endIt._prev = &right.endIt;
    } else {
      right.endIt._next->_prev = &right.endIt;
      right.endIt._prev->_next = &right.endIt;
    }
  }

  // O(1), nothrow
  List() noexcept
      : endIt{&endIt, &endIt} {}

  // O(n), strong
  List(const List& other)
      : List() {
    ConstIterator it = other.begin();
    try {
      while (it != other.end()) {
        push_back(*it);
        ++it;
      }
    } catch (...) {
      clear();
      throw;
    }
  }

  // O(1), nothrow
  List(List&& other) noexcept
      : List() {
    swap(*this, other);
  }

  // O(n), strong
  template <std::input_iterator InputIt>
  List(InputIt first, InputIt last)
      : List() {
    try {
      while (first != last) {
        push_back(*first);
        ++first;
      }
    } catch (...) {
      clear();
      throw;
    }
  }

  // O(n), strong
  List& operator=(const List& other) {
    if (this != &other) {
      List tmp(other);
      swap(*this, tmp);
    }
    return *this;
  }

  // O(this->size()), nothrow
  List& operator=(List&& other) noexcept {
    swap(*this, other);
    return *this;
  }

  // O(n), nothrow
  ~List() noexcept {
    clear();
  }

  // O(1), nothrow
  bool empty() const noexcept {
    return size() == 0;
  }

  // O(n), nothrow
  std::size_t size() const noexcept {
    if (!_is_actual) {
      _size = std::distance(begin(), end());
      _is_actual = true;
    }
    return _size;
  }

  // O(1), nothrow
  T& front() {
    return *begin();
  }

  // O(1), nothrow
  const T& front() const {
    return *begin();
  }

  // O(1), nothrow
  T& back() {
    return *(--end());
  }

  // O(1), nothrow
  const T& back() const {
    return *(--end());
  }

  // O(1), strong
  void push_front(const T& val) {
    insert(begin(), val);
  }

  // O(1), strong
  void push_front(T&& val) {
    insert(begin(), std::move(val));
  }

  // O(1), strong
  void push_back(const T& val) {
    insert(end(), val);
  }

  // O(1), strong
  void push_back(T&& val) {
    insert(end(), std::move(val));
  }

  // O(1), nothrow
  void pop_front() {
    if (!empty()) {
      erase(begin());
    }
  }

  // O(1), nothrow
  void pop_back() {
    if (!empty()) {
      erase(--end());
    }
  }

  // O(1), nothrow
  Iterator begin() noexcept {
    return Iterator(endIt._next);
  }

  // O(1), nothrow
  ConstIterator begin() const noexcept {
    return ConstIterator(endIt._next);
  }

  // O(1), nothrow
  Iterator end() noexcept {
    return Iterator(&endIt);
  }

  // O(1), nothrow
  ConstIterator end() const noexcept {
    return ConstIterator(const_cast<Node*>(&endIt));
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

  // O(n), nothrow
  void clear() noexcept {
    while (!empty()) {
      pop_back();
    }
  }

  // O(1), strong
  Iterator insert(ConstIterator pos, const T& val) {
    ValueNode* new_node = nullptr;
    try {
      new_node = new ValueNode(nullptr, nullptr, val);
    } catch (...) {
      delete new_node;
      throw;
    }
    Node* pos_node = pos.get_node();
    new_node->_next = pos_node;
    new_node->_prev = pos_node->_prev;
    pos_node->_prev->_next = new_node;
    pos_node->_prev = new_node;
    ++_size;
    return Iterator(new_node);
  }

  // O(1), strong
  Iterator insert(ConstIterator pos, T&& val) {
    ValueNode* new_node = nullptr;
    try {
      new_node = new ValueNode(nullptr, nullptr, std::move(val));
    } catch (...) {
      delete new_node;
      throw;
    }
    Node* pos_node = pos.get_node();
    new_node->_next = pos_node;
    new_node->_prev = pos_node->_prev;
    pos_node->_prev->_next = new_node;
    pos_node->_prev = new_node;
    ++_size;
    return Iterator(new_node);
  }

  // O(last - first), strong
  template <std::input_iterator InputIt>
  Iterator insert(ConstIterator pos, InputIt first, InputIt last) {
    if (first == last) {
      return Iterator(pos.get_node());
    }
    List tmp(first, last);
    Iterator result = tmp.begin();
    splice(pos, tmp, tmp.begin(), tmp.end());
    return result;
  }

  // O(1), nothrow
  Iterator erase(ConstIterator pos) noexcept {
    if (pos == end()) {
      return end();
    }
    pos.get_node()->_prev->_next = pos.get_node()->_next;
    pos.get_node()->_next->_prev = pos.get_node()->_prev;
    Iterator result = Iterator(pos.get_node()->_next);
    delete static_cast<ValueNode*>(pos.get_node());
    --_size;
    return result;
  }

  // O(last - first), nothrow
  Iterator erase(ConstIterator first, ConstIterator last) noexcept {
    while (first != last) {
      first = erase(first);
    }
    return Iterator(last.get_node());
  }

  // O(1), nothrow
  void splice(ConstIterator pos, List& other, ConstIterator first, ConstIterator last) noexcept {
    if (first == last) {
      return;
    }

    Node* first_node = first.get_node();
    Node* last_node = last.get_node()->_prev;
    Node* pos_node = pos.get_node();
    first_node->_prev->_next = last_node->_next;
    last_node->_next->_prev = first_node->_prev;
    first_node->_prev = pos_node->_prev;
    pos_node->_prev->_next = first_node;
    last_node->_next = pos_node;
    pos_node->_prev = last_node;

    _is_actual = false;
    other._is_actual = false;
  }

  // O(1), nothrow
};

} // namespace ct
