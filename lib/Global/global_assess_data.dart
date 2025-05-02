import 'dart:io';

import 'package:path_provider/path_provider.dart';

class GlobalStorage {
  static Directory? appDirectory;

  static Future<void> initAppDirectory() async {
    appDirectory = await getApplicationDocumentsDirectory();
  }
}