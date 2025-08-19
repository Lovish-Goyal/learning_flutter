class NoteModel {
  final String id;
  final String title;
  final String content;

  NoteModel({required this.id, required this.title, required this.content});

  factory NoteModel.fromMap(String id, Map<String, dynamic> map) {
    return NoteModel(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'content': content};
  }

  NoteModel copyWith({String? title, String? content}) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  String toString() => 'NoteModel(id: $id, title: $title, content: $content)';
}
