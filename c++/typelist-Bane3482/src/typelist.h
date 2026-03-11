#pragma once

#include <cstddef>
#include <type_traits>
#include <utility>

namespace ct::tl {
template <typename... Types>
struct TypeList {};

/// count

template <typename List>
struct count_impl;

template <template <typename...> class List, typename... Types>
struct count_impl<List<Types...>> {
  static constexpr std::size_t value = sizeof...(Types);
};

template <typename List>
inline constexpr std::size_t count = count_impl<List>::value;

/// concat fast

template <
    template <typename...> class List1,
    template <typename...> class List2,
    typename... Types1,
    typename... Types2>
List1<Types1..., Types2...> operator+(List1<Types1...>, List2<Types2...>);

template <typename... Lists>
using concat_fast = decltype((Lists{} + ... + TypeList{}));

/// Concat of two

template <typename List1, typename List2>
struct concat2_impl;

template <
    template <typename...> class List1,
    template <typename...> class List2,
    typename... Types1,
    typename... Types2>
struct concat2_impl<List1<Types1...>, List2<Types2...>> {
  using type = List1<Types1..., Types2...>;
};

template <typename List1, typename List2>
using concat2 = typename concat2_impl<List1, List2>::type;

/// Filter

template <template <typename> typename Pred, typename List>
struct filter_impl;

template <template <typename> typename Pred, template <typename...> class List>
struct filter_impl<Pred, List<>> {
  using type = List<>;
};

template <template <typename> typename Pred, template <typename...> class List, typename... Types>
struct filter_impl<Pred, List<Types...>> {
  template <typename T>
  using single = std::conditional_t<Pred<T>::value, TypeList<T>, TypeList<>>;

  using type = concat_fast<List<>, single<Types>...>;
};

template <template <typename> typename Pred, typename List>
using filter = typename filter_impl<Pred, List>::type;

/// reverse_pair<Pair>

template <typename Pair>
struct reverse_pair_impl;

template <template <typename, typename> class Pair, typename First, typename Second>
struct reverse_pair_impl<Pair<First, Second>> {
  using type = Pair<Second, First>;
};

template <typename Pair>
using reverse_pair = typename reverse_pair_impl<Pair>::type;

/// Transform

template <template <typename> typename F, typename List>
struct transform_impl;

template <template <typename> class F, template <typename...> class List>
struct transform_impl<F, List<>> {
  using type = List<>;
};

template <template <typename> typename F, template <typename...> class List, typename... Types>
struct transform_impl<F, List<Types...>> {
  using type = List<F<Types>...>;
};

template <template <typename> typename F, typename List>
using transform = typename transform_impl<F, List>::type;

/// contains<Type, List>

template <typename Type, typename List>
struct contains_impl;

template <typename Type, template <typename...> class List, typename Head, typename... Tail>
struct contains_impl<Type, List<Head, Tail...>> {
  template <typename T>
  using this_type = std::is_same<Type, T>;

  static constexpr bool type = count<filter<this_type, List<Head, Tail...>>> != 0;
};

template <typename Type, template <typename...> class List>
struct contains_impl<Type, List<>> {
  static constexpr bool type = false;
};

template <typename Type, typename List>
static constexpr bool contains = contains_impl<Type, List>::type;

/// flip_all<List>

template <typename List>
using flip_all = transform<reverse_pair, List>;

/// enumerate

template <std::size_t VALUE>
struct index {
  static constexpr std::size_t value = VALUE;
};

template <typename List, typename Seq>
struct enumerate_impl;

template <template <typename...> class List, typename... Types, std::size_t... INDICES>
struct enumerate_impl<List<Types...>, std::index_sequence<INDICES...>> {
  using type = List<TypeList<index<INDICES>, Types>...>;
};

template <typename List>
using enumerate = typename enumerate_impl<List, std::make_index_sequence<count<List>>>::type;

/// index_of_unique<Type, List>

template <typename List>
struct get_index;

template <
    template <typename...> class List1,
    template <typename...> class Head,
    std::size_t Index,
    typename Type,
    typename... Tail>
struct get_index<List1<Head<index<Index>, Type>, Tail...>> {
  static constexpr std::size_t value = Index;
};

template <template <typename...> class List>
struct get_index<List<>> {
  static constexpr std::size_t value = 0;
};

template <typename Type, typename List>
struct index_of_unique_impl;

template <typename Type, template <typename...> class List, typename... Types>
struct index_of_unique_impl<Type, List<Types...>> {
  using ind_list = enumerate<List<Types...>>;

  template <typename Listt>
  struct pred;

  template <template <typename...> class Listt, typename Index, typename T>
  struct pred<Listt<Index, T>> {
    using type = std::is_same<Type, T>;
  };

  template <typename Listt>
  using pred_t = typename pred<Listt>::type;

  static constexpr std::size_t value = get_index<filter<pred_t, ind_list>>::value;
};

template <typename Type, typename List>
static constexpr std::size_t index_of_unique = index_of_unique_impl<Type, List>::value;

/// flatten<List>

template <typename List>
struct flatten_impl;

template <typename List>
using flatten = typename flatten_impl<List>::type;

template <typename Type>
struct flatten_impl {
  using type = TypeList<Type>;
};

template <template <typename...> class List, typename... Types>
struct flatten_impl<List<Types...>> {
  using type = concat_fast<List<>, flatten<Types>...>;
};

/// merge_sort<List, Compare>

template <typename List>
struct stay_type;

template <template <typename...> class List, typename Index, typename T>
struct stay_type<List<Index, T>> {
  using type = T;
};

template <typename List>
using stay_type_t = typename stay_type<List>::type;

template <std::size_t N, typename List>
struct div_half_first_impl;

template <std::size_t N, typename List>
using div_half_first = typename div_half_first_impl<N, List>::type;

template <std::size_t N, template <typename...> class List, typename... Types>
struct div_half_first_impl<N, List<Types...>> {
  using ind_list = enumerate<List<Types...>>;

  template <typename Listt>
  struct pred;

  template <template <typename...> class Listt, std::size_t Index, typename T>
  struct pred<Listt<index<Index>, T>> {
    static constexpr bool value = (Index < N);
  };

  using type = transform<stay_type_t, filter<pred, ind_list>>;
};

template <std::size_t N, typename List>
struct div_half_second_impl;

template <std::size_t N, typename List>
using div_half_second = typename div_half_second_impl<N, List>::type;

template <std::size_t N, template <typename...> class List, typename... Types>
struct div_half_second_impl<N, List<Types...>> {
  using ind_list = enumerate<List<Types...>>;

  template <typename Listt>
  struct pred;

  template <template <typename...> class Listt, std::size_t Index, typename T>
  struct pred<Listt<index<Index>, T>> {
    static constexpr bool value = (Index >= N);
  };

  using type = transform<stay_type_t, filter<pred, ind_list>>;
};

template <typename List1, typename List2, template <typename, typename> typename Compare>
struct merge_impl;

template <typename List1, typename List2, template <typename, typename> typename Compare>
using merge = typename merge_impl<List1, List2, Compare>::type;

template <
    template <typename...> class List1,
    typename Type,
    typename... Types,
    template <typename...> class List2,
    template <typename, typename> typename Compare>
struct merge_impl<List1<Type, Types...>, List2<>, Compare> {
  using type = List1<Type, Types...>;
};

template <
    template <typename...> class List1,
    typename Type,
    typename... Types,
    template <typename...> class List2,
    template <typename, typename> typename Compare>
struct merge_impl<List1<>, List2<Type, Types...>, Compare> {
  using type = List2<Type, Types...>;
};

template <
    template <typename...> class List1,
    template <typename...> class List2,
    template <typename, typename> typename Compare>
struct merge_impl<List1<>, List2<>, Compare> {
  using type = List1<>;
};

template <bool B>
struct conditional_impl;

template <>
struct conditional_impl<true> {
  template <typename T, typename F>
  using value = T;
};

template <>
struct conditional_impl<false> {
  template <typename T, typename F>
  using value = F;
};

template <bool B, typename T, typename F>
using conditional = typename conditional_impl<B>::template value<T, F>;

template <
    template <typename...> class List1,
    template <typename...> class List2,
    typename Head1,
    typename Head2,
    typename... Tail1,
    typename... Tail2,
    template <typename, typename> typename Compare>
struct merge_impl<List1<Head1, Tail1...>, List2<Head2, Tail2...>, Compare> {
  using type = conditional<
      Compare<Head1, Head2>::value,
      concat2<List1<Head1>, merge<List1<Tail1...>, List2<Head2, Tail2...>, Compare>>,
      concat2<List1<Head2>, merge<List1<Head1, Tail1...>, List2<Tail2...>, Compare>>>;
};

template <typename List, template <typename, typename> typename Compare>
struct merge_sort_impl;

template <template <typename...> class List, template <typename, typename> typename Compare>
struct merge_sort_impl<List<>, Compare> {
  using type = List<>;
};

template <template <typename...> class List, typename Type, template <typename, typename> typename Compare>
struct merge_sort_impl<List<Type>, Compare> {
  using type = List<Type>;
};

template <typename List, template <typename, typename> typename Compare>
using merge_sort = merge_sort_impl<List, Compare>::type;

template <
    template <typename...> class List,
    typename Type1,
    typename Type2,
    typename... Types,
    template <typename, typename> typename Compare>
struct merge_sort_impl<List<Type1, Type2, Types...>, Compare> {
  static constexpr std::size_t list_size = count<List<Type1, Type2, Types...>>;
  static constexpr std::size_t half = list_size / 2;
  using sorted_first = merge_sort<div_half_first<half, List<Type1, Type2, Types...>>, Compare>;
  using sorted_second = merge_sort<div_half_second<half, List<Type1, Type2, Types...>>, Compare>;
  using type = merge<sorted_first, sorted_second, Compare>;
};

} // namespace ct::tl
