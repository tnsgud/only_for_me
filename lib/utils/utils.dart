import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static get getExternalDir async {
    var _externalStorageDirectory = await getExternalStorageDirectory();
    return _externalStorageDirectory?.path;
  }

  static Future<File> get localPlaylistFile async =>
      File('${await Utils.getExternalDir}/playlist.json');

  static CollectionReference<Map<String, dynamic>> get getCurrentCollection =>
      FirebaseFirestore.instance
          .collection('${FirebaseAuth.instance.currentUser?.uid}');
}
