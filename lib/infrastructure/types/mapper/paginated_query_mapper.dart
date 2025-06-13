import 'package:trade_asia/infrastructure/types/mapper/json_mapper.dart';
import 'package:trade_asia/infrastructure/types/query.dart';

class PostPaginatedQueryMapper implements ToJSONMapper<PaginatedQuery> {
  @override
  toJSON(PaginatedQuery data) {
    final result = {
      if (data.limit != null) "limit": data.limit.toString(),
      if (data.page != null) "offset": data.page.toString(),
      if (data.keywords.isNotEmpty) "search": data.keywords,
      for (final filter in data.filters) ...{filter.key: filter.value.toString()},
    };
    return result;
  }
}
