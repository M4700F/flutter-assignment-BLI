class CommentModel {
  final int id;
  final String? by;
  final List<int>? kids;
  final int? parent;
  final int? time;
  final String? text;
  final String? type;
  final bool? dead;
  final bool? deleted;

  CommentModel({
    required this.id,
    this.by,
    this.kids,
    this.parent,
    this.time,
    this.text,
    this.type,
    this.dead,
    this.deleted,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      by: json['by'] as String?,
      kids: (json['kids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      parent: json['parent'] as int?,
      time: json['time'] as int?,
      text: json['text'] as String?,
      type: json['type'] as String?,
      dead: json['dead'] as bool?,
      deleted: json['deleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'by': by,
      'kids': kids,
      'parent': parent,
      'time': time,
      'text': text,
      'type': type,
      'dead': dead,
      'deleted': deleted,
    };
  }

  // Helper method to get formatted time
  String getFormattedTime() {
    if (time == null) return 'Unknown time';
    final date = DateTime.fromMillisecondsSinceEpoch(time! * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Check if comment is valid (not deleted or dead)
  bool get isValid => !(dead == true || deleted == true) && text != null && text!.isNotEmpty;

  // Get clean text without HTML tags
  String get cleanText {
    if (text == null) return '';
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return text!
        .replaceAll(exp, '')
        .replaceAll('&#x27;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&#x2F;', '/')
        .replaceAll('<p>', '\n\n')
        .trim();
  }
}
