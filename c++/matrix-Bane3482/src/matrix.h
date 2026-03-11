#pragma once

#include <assert.h>

#include <algorithm>
#include <cstddef>
#include <functional>
#include <numeric>

namespace ct {

template <typename T>
class Matrix {
  template <typename S>
  class ColumnIterator {
  public:
    using value_type = T;
    using reference = S&;
    using pointer = S*;
    using difference_type = std::ptrdiff_t;
    using iterator_category = std::random_access_iterator_tag;

    ColumnIterator() = default;

    operator ColumnIterator<const S>() const {
      return ColumnIterator<const S>(_data, _cols, _offset);
    }

    friend bool operator==(const ColumnIterator& left, const ColumnIterator& right) = default;

    friend bool operator!=(const ColumnIterator& left, const ColumnIterator& right) {
      return !(left == right);
    }

    reference operator*() const {
      return _data[_offset];
    }

    pointer operator->() const {
      return _data + _offset;
    }

    ColumnIterator& operator++() {
      _data += _cols;
      return *this;
    }

    ColumnIterator operator++(int) {
      ColumnIterator result(*this);
      _data += _cols;
      return result;
    }

    ColumnIterator& operator--() {
      _data -= _cols;
      return *this;
    }

    ColumnIterator operator--(int) {
      ColumnIterator result(*this);
      _data -= _cols;
      return result;
    }

    friend ColumnIterator operator+(difference_type val, const ColumnIterator& other) {
      ColumnIterator result(other);
      result._data += val * static_cast<difference_type>(result._cols);
      return result;
    }

    friend ColumnIterator operator+(const ColumnIterator& other, difference_type val) {
      ColumnIterator result(other);
      result._data += val * static_cast<difference_type>(result._cols);
      return result;
    }

    friend ColumnIterator operator-(const ColumnIterator& other, difference_type val) {
      return (-val) + other;
    }

    friend difference_type operator-(const ColumnIterator& first, const ColumnIterator& second) {
      return (first._data - second._data) / static_cast<difference_type>(first._cols);
    }

    friend bool operator>(const ColumnIterator& first, const ColumnIterator& second) {
      return first._data > second._data || (first._data == second._data && first._cols > second._cols) ||
             (first._data == second._data && first._cols == second._cols && first._offset > second._offset);
    }

    friend bool operator>=(const ColumnIterator& first, const ColumnIterator& second) {
      return first > second || first == second;
    }

    friend bool operator<(const ColumnIterator& first, const ColumnIterator& second) {
      return !(first >= second);
    }

    friend bool operator<=(const ColumnIterator& first, const ColumnIterator& second) {
      return !(first > second);
    }

    ColumnIterator& operator+=(difference_type val) {
      _data += static_cast<difference_type>(_cols) * val;
      return *this;
    }

    ColumnIterator& operator-=(difference_type val) {
      return (*this += (-val));
    }

    reference operator[](difference_type val) const {
      return _data[static_cast<difference_type>(_cols) * val + static_cast<difference_type>(_offset)];
    }

    void swap(ColumnIterator& other) {
      std::swap(_data, other._data);
      std::swap(_cols, other._cols);
      std::swap(_offset, other._offset);
    }

  private:
    pointer _data;
    std::size_t _cols;
    std::size_t _offset;

    ColumnIterator(pointer data, std::size_t cols, std::size_t offset)
        : _data{data}
        , _cols{cols}
        , _offset{offset} {}

    friend class Matrix;
  };

  template <typename It>
  class Viewer {
  public:
    Viewer()
        : _begin{nullptr}
        , _end{nullptr} {}

    Viewer(It begin, It end)
        : _begin{begin}
        , _end{end} {}

    It begin() const {
      return _begin;
    }

    It end() const {
      return _end;
    }

    Viewer& operator*=(const T& factor) & {
      std::transform(_begin, _end, _begin, [factor](auto& val) { return val * factor; });
      return *this;
    }

    const Viewer& operator*=(const T& factor) const& {
      std::transform(_begin, _end, _begin, [factor](auto& val) { return val * factor; });
      return *this;
    }

  private:
    It _begin;
    It _end;
    friend class Matrix;
  };

public:
  using ValueType = T;

  using Reference = T&;
  using ConstReference = const T&;

  using Pointer = T*;
  using ConstPointer = const T*;

  using Iterator = Pointer;
  using ConstIterator = ConstPointer;

  using RowIterator = Pointer;
  using ConstRowIterator = ConstPointer;

  using ColIterator = ColumnIterator<ValueType>;
  using ConstColIterator = ColumnIterator<const ValueType>;

  using RowView = Viewer<RowIterator>;
  using ConstRowView = Viewer<ConstRowIterator>;

  using ColView = Viewer<ColIterator>;
  using ConstColView = Viewer<ConstColIterator>;

public:
  Matrix()
      : _data{nullptr}
      , _rows{0}
      , _cols{0} {}

  Matrix(std::size_t rows, std::size_t cols)
      : _rows{rows}
      , _cols{cols} {
    if (!empty()) {
      _data = new T[_rows * _cols]();
    } else {
      _rows = _cols = 0;
    }
  }

  template <std::size_t ROWS, std::size_t COLS>
  Matrix(const T (&init)[ROWS][COLS])
      : Matrix(ROWS, COLS) {
    if (!empty()) {
      Pointer cur = _data;
      for (auto& row : init) {
        std::copy_n(row, COLS, cur);
        cur += COLS;
      }
    }
  }

  Matrix(const Matrix& other)
      : _rows{other.rows()}
      , _cols{other.cols()} {
    if (!empty()) {
      _data = new T[_rows * _cols];
      std::copy(other.begin(), other.end(), begin());
    }
  }

  Matrix& operator=(const Matrix& other) {
    if (this != &other) {
      Matrix(other).swap(*this);
    }
    return *this;
  }

  ~Matrix() {
    delete[] _data;
    _rows = 0;
    _cols = 0;
  }

  // Iterators

  Iterator begin() {
    return data();
  }

  ConstIterator begin() const {
    return data();
  }

  Iterator end() {
    return data() + (rows() * cols());
  }

  ConstIterator end() const {
    return data() + (rows() * cols());
  }

  RowIterator row_begin(size_t row) {
    assert(row < rows());
    return begin() + (row * cols());
  }

  ConstRowIterator row_begin(size_t row) const {
    assert(row < rows());
    return begin() + (row * cols());
  }

  RowIterator row_end(size_t row) {
    assert(row < rows());
    return row_begin(row) + cols();
  }

  ConstRowIterator row_end(size_t row) const {
    assert(row < rows());
    return row_begin(row) + cols();
  }

  ColIterator col_begin(size_t col) {
    assert(col < cols());
    return ColumnIterator(begin(), cols(), col);
  }

  ConstColIterator col_begin(size_t col) const {
    assert(col < cols());
    return ConstColIterator(begin(), cols(), col);
  }

  ColIterator col_end(size_t col) {
    assert(col < cols());
    return ColIterator(end(), cols(), col);
  }

  ConstColIterator col_end(size_t col) const {
    assert(col < cols());
    return ConstColIterator(end(), cols(), col);
  }

  void swap(Matrix& other) {
    std::swap(_data, other._data);
    std::swap(_rows, other._rows);
    std::swap(_cols, other._cols);
  }

  // Views

  RowView row(size_t row) {
    return RowView(row_begin(row), row_end(row));
  }

  ConstRowView row(size_t row) const {
    return ConstRowView(row_begin(row), row_end(row));
  }

  ColView col(size_t col) {
    return ColView(col_begin(col), col_end(col));
  }

  ConstColView col(size_t col) const {
    return ConstColView(col_begin(col), col_end(col));
  }

  // Size

  size_t rows() const {
    return _rows;
  }

  size_t cols() const {
    return _cols;
  }

  size_t size() const {
    return rows() * cols();
  }

  bool empty() const {
    return size() == 0;
  }

  // Elements access

  Reference operator()(size_t row, size_t col) {
    return data()[(row * cols()) + col];
  }

  ConstReference operator()(size_t row, size_t col) const {
    return data()[(row * cols()) + col];
  }

  Pointer data() {
    return _data;
  }

  ConstPointer data() const {
    return _data;
  }

  // Comparison

  friend bool operator==(const Matrix& left, const Matrix& right) {
    if (left.rows() != right.rows() || left.cols() != right.cols()) {
      return false;
    }
    return std::equal(left.begin(), left.end(), right.begin());
  }

  friend bool operator!=(const Matrix& left, const Matrix& right) {
    return !(left == right);
  }

  // Arithmetic operations

  Matrix& operator+=(const Matrix& other) {
    assert(rows() == other.rows() && cols() == other.cols());
    std::transform(begin(), end(), other.begin(), begin(), std::plus<>{});
    return *this;
  }

  Matrix& operator-=(const Matrix& other) {
    assert(rows() == other.rows() && cols() == other.cols());
    std::transform(begin(), end(), other.begin(), begin(), std::minus<>{});
    return *this;
  }

  Matrix& operator*=(const Matrix& other) {
    Matrix result(this->rows(), other.cols());
    mult_impl(result, *this, other);
    swap(result);
    return *this;
  }

  Matrix& operator*=(ConstReference factor) {
    RowView(begin(), end()) *= factor;
    return *this;
  }

  friend Matrix operator+(const Matrix& left, const Matrix& right) {
    Matrix result(left);
    result += right;
    return result;
  }

  friend Matrix operator-(const Matrix& left, const Matrix& right) {
    Matrix result(left);
    result -= right;
    return result;
  }

  friend Matrix operator*(const Matrix& left, const Matrix& right) {
    Matrix result(left.rows(), right.cols());
    mult_impl(result, left, right);
    return result;
  }

  friend Matrix operator*(const Matrix& left, ConstReference right) {
    Matrix result(left);
    result *= right;
    return result;
  }

  friend Matrix operator*(ConstReference left, const Matrix& right) {
    return right * left;
  }

private:
  Pointer _data = nullptr;
  std::size_t _rows = 0;
  std::size_t _cols = 0;

  static void mult_impl(Matrix& result, const Matrix& left, const Matrix& right) {
    for (std::size_t i = 0; i < left.rows(); ++i) {
      for (std::size_t j = 0; j < right.cols(); ++j) {
        result(i, j) = std::inner_product(left.row_begin(i), left.row_end(i), right.col_begin(j), T());
      }
    }
  }
};

} // namespace ct
