class PostEntityRemote {
  final Map<String, dynamic> data;

  PostEntityRemote({required this.data});

  factory PostEntityRemote.fromJson(Map<String, dynamic> json) {
    return PostEntityRemote(data: json);
  }

  Map<String, dynamic> toJson() => data;
}
