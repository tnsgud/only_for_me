import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Utils {
  static get getExternalDir async {
    var _externalStorageDirectory = await getExternalStorageDirectory();
    return _externalStorageDirectory?.path;
  }

  static Future<File> get localPlaylistFile async =>
      File('${await Utils.getExternalDir}/playlist.json');
}
