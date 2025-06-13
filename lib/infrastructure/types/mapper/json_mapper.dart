import 'package:flutter/material.dart';

abstract class ToJSONMapper<T> {
  dynamic toJSON(T data);
}

abstract class FromJSONMapper<T> {
  T fromJSON(dynamic json);
}

extension FromJSONList<Data> on FromJSONMapper<Data> {
  List<Data> fromJSONList(List<dynamic> list) =>
      list.map((e) => fromJSON(e)).toList();

  Data? tryFromJSON(dynamic json) {
    try {
      return fromJSON(json);
    } catch (e, stackTrace) {
      debugPrint("Error parse $e");
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  T parse<T>(dynamic json) {
    final value = json == false || json == null ? null : json as T;
    if (value == null) throw "Invalid Value of $dynamic";
    return value;
  }

  T? tryParse<T>(dynamic json) {
    try {
      final value = parse(json);
      return value;
    } catch (e) {
      return null;
    }
  }

  Result? tryParseKeyValueFromList<Result>(dynamic json,
      {required Result Function(dynamic key, dynamic value) mapper}) {
    try {
      return parseKeyValueFromList(json, mapper: mapper);
    } catch (e) {
      return null;
    }
  }

  Result parseKeyValueFromList<Result>(dynamic json,
      {required Result Function(dynamic key, dynamic value) mapper}) {
    final list = json as List;
    return mapper(list[0], list[1]);
  }

  Result parseAndMap<ParseTo, Result>(dynamic json,
      {required Result Function(ParseTo parsedValue) mapper}) {
    final parsedValue = parse<ParseTo>(json);
    return mapper(parsedValue);
  }

  Result? tryParseAndMap<ParseTo, Result>(dynamic json,
      {required Result Function(ParseTo parsedValue) mapper}) {
    final parsedValue = tryParse<ParseTo>(json);
    return parsedValue == null ? null : mapper(parsedValue);
  }

  List<Data> safeFromJSONList(List<dynamic> list) =>
      list.map((e) => tryFromJSON(e)).whereType<Data>().toList();
}

extension ToJSONList<Data> on ToJSONMapper<Data> {
  List<dynamic> toJSONList(List<Data> list) =>
      list.map((e) => toJSON(e)).toList();
}
