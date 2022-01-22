import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

/// Table name of columns
@DataClassName('NameColumns')
class Titles extends Table {
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {name};
}

/// Table rows and data
@DataClassName('RowsValuesData')
class RowsValues extends Table {
  IntColumn get postId => integer()();
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get body => text()();
}

@UseMoor(tables: [Titles, RowsValues])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  /// Get all titles
  Future<List<NameColumns>> getAllTitles() => select(titles).get();

  ///Inserts title data to table
  Future insertTitleData(NameColumns nameColumns) =>
      into(titles).insert(nameColumns, mode: InsertMode.insertOrIgnore);

  /// Get all rows values
  Future<List<RowsValuesData>> getAllRowsValue() => select(rowsValues).get();

  /// Inserts rows values
  Future insertRowsValue(RowsValuesData rowsValuesData) =>
      into(rowsValues).insert(rowsValuesData, mode: InsertMode.insertOrIgnore);
}
