class StoryModel {
  final int id;
  final String? by;
  final int? descendants;
  final List<int>? kids;
  final int? score;
  final int? time;
  final String? title;
  final String? type;
  final String? url;
  final String? text;

  StoryModel({
    required this.id,
    this.by,
    this.descendants,
    this.kids,
    this.score,
    this.time,
    this.title,
    this.type,
    this.url,
    this.text,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as int,
      by: json['by'] as String?,
      descendants: json['descendants'] as int?,
      kids: (json['kids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      score: json['score'] as int?,
      time: json['time'] as int?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      url: json['url'] as String?,
      text: json['text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'by': by,
      'descendants': descendants,
      'kids': kids,
      'score': score,
      'time': time,
      'title': title,
      'type': type,
      'url': url,
      'text': text,
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

  // Helper method to get domain from URL
  String? getDomain() {
    if (url == null) return null;
    try {
      final uri = Uri.parse(url!);
      return uri.host.replaceAll('www.', '');
    } catch (e) {
      return null;
    }
  }
}