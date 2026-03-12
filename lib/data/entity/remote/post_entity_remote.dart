class PostEntityRemote {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final Object? createdAt;
  final Object? updatedAt;
  final String? imageUrl;

  PostEntityRemote({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  factory PostEntityRemote.fromJson(Map<String, dynamic> json) {
    return PostEntityRemote(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      authorName: (json['authorName'] as String?) ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imageUrl': imageUrl,
    };
  }
}
