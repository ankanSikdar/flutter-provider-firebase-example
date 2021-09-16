class AvatarReference {
  AvatarReference(this.downloadUrl);
  final String downloadUrl;

  factory AvatarReference.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw Exception('Data NULL');
    }
    final String? downloadUrl = data['downloadUrl'];
    if (downloadUrl == null) {
      throw Exception('Download Url NULL');
    }
    return AvatarReference(downloadUrl);
  }

  Map<String, dynamic> toMap() {
    return {
      'downloadUrl': downloadUrl,
    };
  }
}
