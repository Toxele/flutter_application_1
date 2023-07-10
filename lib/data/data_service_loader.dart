// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable

import 'dart:async';
//import 'dart:ffi';
import 'dart:io';
class DataServiceLoader {
  DataServiceLoader();
  Future<String> loadRecords({required String path}) async {
    final file = File(path);
    if (await file.exists()) {
      String rawRecordsList = await file.readAsString();
      return rawRecordsList;
    }
    return '';
  }
}