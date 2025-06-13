class MultipartFileModel {
  final String filePath;
  final String key;

  MultipartFileModel({
    required this.filePath,
    required this.key,
  });

  Map<String, dynamic> toJson() => {"key": key, "filePath": filePath};

  @override
  String toString() {
    return '''
    {
      key: $key,
      filePath: $filePath
    }
    ''';
  }
}

class MultiPartFileField {
  final String filepath;

  MultiPartFileField({required this.filepath});
}
