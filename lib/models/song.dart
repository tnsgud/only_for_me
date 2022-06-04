import 'package:just_audio/just_audio.dart';

class Song {
  late String id;
  late String title;
  late String thumbnail;
  late String url;
  late String path;
  late AudioSource source;

  Song({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.url,
    required this.path,
  }) {
    source = AudioSource.uri(Uri.parse(path));
  }
}
