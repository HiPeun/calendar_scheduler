import 'dart:io';


import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';


//함께 한 파일에 있는 것처럼 인식해라 임포트를 하지 않아도 다 사용할 수 잇는 part
part 'drift.g.dart';


@DriftDatabase(
    tables: [ScheduleTable]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());


  @override
  int get schemaVersion => 1;


}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {


    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "db.splite"));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = await getTemporaryDirectory();

    sqlite3.tempDirectory = cachebase.path;

    return NativeDatabase.createInBackground(file);
  },);
}
