class FileUploadResponse {
  File? data;

  FileUploadResponse({this.data});

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      data: json['data'] == null
          ? null
          : File.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class File {
  final String? key;
  final String? fileUrl;

  File({
    this.key,
    this.fileUrl,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      key: json['key'] as String?,
      fileUrl: json['fileUrl'] as String?,
    );
  }
}
