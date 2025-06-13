import 'package:trade_asia/infrastructure/types/mapper/json_mapper.dart';
import 'package:trade_asia/infrastructure/types/mapper/paginated_query_mapper.dart';
import 'package:trade_asia/infrastructure/types/query.dart';

class PostQueryMapper implements ToJSONMapper<PostQuery> {
  @override
  toJSON(PostQuery data) {
    if (data is PaginatedQuery) {
      return PostPaginatedQueryMapper().toJSON(data);
    }
    return {
      if (data.keywords.isNotEmpty) "search": data.keywords,
      for (final filter in data.filters) ...{filter.key: filter.value},
    };
  }
}

class SortMapper extends ToJSONMapper<Sort> {
  @override
  toJSON(Sort data) {
    return {"key": data.key, "order": data.order.value};
  }
}
