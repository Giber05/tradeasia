import 'package:equatable/equatable.dart';
import 'package:trade_asia/infrastructure/types/repo_result.dart';

class PostQuery extends Equatable {
  final String keywords;
  final ResultSource source;
  final List<Filter> filters;
  final List<Sort> sorts;
  const PostQuery({
    this.keywords = "",
    this.source = ResultSource.cache,
    this.filters = const [],
    this.sorts = const [],
  });

  PostQuery copyWith({String? keywords, List<Filter>? filters, List<Sort>? sorts}) =>
      PostQuery(keywords: keywords ?? this.keywords, filters: filters ?? this.filters, sorts: sorts ?? this.sorts);

  @override
  List<Object?> get props => [keywords, filters, sorts];

  @override
  String toString() {
    return 'PostQuery(keywords: $keywords, filters: $filters, sorts: $sorts)';
  }
}

class PaginatedQuery extends PostQuery {
  final int? page;
  final int? limit;

  static const firstPage = 1;

  const PaginatedQuery({this.page, this.limit, super.keywords, super.filters, super.sorts})
    : assert(page == null || page >= firstPage, "Page should be null or >= 1");

  @override
  PaginatedQuery copyWith({String? keywords, List<Filter>? filters, List<Sort>? sorts, int? page, int? size}) {
    return PaginatedQuery(
      keywords: keywords ?? this.keywords,
      filters: filters ?? this.filters,
      page: page ?? this.page,
      limit: size ?? limit,
      sorts: sorts ?? this.sorts,
    );
  }

  @override
  List<Object?> get props => [page, limit, ...super.props];

  @override
  String toString() {
    return 'PaginatedQuery(page: $page, limit: $limit, keywords: $keywords, filters: $filters, sorts: $sorts)';
  }
}

class Sort {
  final String key;
  final SortOrder order;

  Sort({required this.key, required this.order});
}

class Filter {
  final String key;
  // final FilterOperator? operator;
  final FilterOperator type;
  final dynamic value;
  final dynamic toValue;
  Filter({required this.key, required this.type, required this.value, this.toValue});

  @override
  String toString() {
    return 'Filter(key: $key, type: $type, value: $value, toValue: $toValue)';
  }
}

enum SortOrder {
  asc('asc'),
  desc('desc');

  final String value;
  const SortOrder(this.value);
}

enum FilterOperator {
  equal('EQUAL'),
  not('NOT'),
  notEqual('NOT_EQUAL'),
  greaterThan('GREATER_THAN'),
  lessThan('LESS_THAN'),
  greaterThanOrEqual('GREATER_THAN_OR_EQUAL'),
  lessThanOrEqual('LESS_THAN_OR_EQUAL'),
  iLike('ILIKE'),
  isSet('IS_SET'),
  isNotSet('IS_NOT_SET'),
  inValues('IN'),
  between('BETWEEN');

  final String value;

  const FilterOperator(this.value);
}
