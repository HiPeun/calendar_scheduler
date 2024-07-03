

import 'package:drift/drift.dart';

class CategoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get color => text()();

  IntColumn get randomNumber => integer().withDefault(const Constant(0))();

  IntColumn get randomNumber2 => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now().toUtc(),
      )();
}
