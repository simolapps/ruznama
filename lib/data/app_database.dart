import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
part 'app_database.g.dart'; // генерируется drift build

class Cities extends Table {
  IntColumn get id         => integer()();
  TextColumn get name       => text()();
  BoolColumn get selected   => boolean().withDefault(const Constant(false))();
  @override Set<Column> get primaryKey => {id};
}

class PrayerTimes extends Table {
  IntColumn  get cityId     => integer()();
  TextColumn get date       => text()();                // YYYY-MM-DD
  TextColumn get morning    => text()();
  TextColumn get sunrise    => text()();
  TextColumn get noon       => text()();
  TextColumn get afternoon  => text()();
  TextColumn get sunset     => text()();
  TextColumn get night      => text()();
  @override Set<Column> get primaryKey => {cityId, date};
}

@DriftDatabase(tables: [Cities, PrayerTimes])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_open());

  static final AppDatabase instance = AppDatabase._();

  @override int get schemaVersion => 1;
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'ruznama.sqlite'));
    return NativeDatabase(file);
  });
}
