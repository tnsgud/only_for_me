class Thumbnail {
  final String small;
  final String medium;
  final String high;

  Thumbnail({required this.small, required this.medium, required this.high});
}

class Song {
  final String id;
  final String title;
  final Thumbnail thumbnail;

  Song({required this.id, required this.title, required this.thumbnail});
  Song.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        thumbnail = json['thumbnail'];
}
