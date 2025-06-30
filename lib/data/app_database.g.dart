// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CitiesTable extends Cities with TableInfo<$CitiesTable, City> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _selectedMeta =
      const VerificationMeta('selected');
  @override
  late final GeneratedColumn<bool> selected = GeneratedColumn<bool>(
      'selected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("selected" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, name, selected];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cities';
  @override
  VerificationContext validateIntegrity(Insertable<City> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('selected')) {
      context.handle(_selectedMeta,
          selected.isAcceptableOrUnknown(data['selected']!, _selectedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  City map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return City(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      selected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}selected'])!,
    );
  }

  @override
  $CitiesTable createAlias(String alias) {
    return $CitiesTable(attachedDatabase, alias);
  }
}

class City extends DataClass implements Insertable<City> {
  final int id;
  final String name;
  final bool selected;
  const City({required this.id, required this.name, required this.selected});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['selected'] = Variable<bool>(selected);
    return map;
  }

  CitiesCompanion toCompanion(bool nullToAbsent) {
    return CitiesCompanion(
      id: Value(id),
      name: Value(name),
      selected: Value(selected),
    );
  }

  factory City.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return City(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      selected: serializer.fromJson<bool>(json['selected']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'selected': serializer.toJson<bool>(selected),
    };
  }

  City copyWith({int? id, String? name, bool? selected}) => City(
        id: id ?? this.id,
        name: name ?? this.name,
        selected: selected ?? this.selected,
      );
  City copyWithCompanion(CitiesCompanion data) {
    return City(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      selected: data.selected.present ? data.selected.value : this.selected,
    );
  }

  @override
  String toString() {
    return (StringBuffer('City(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('selected: $selected')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, selected);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is City &&
          other.id == this.id &&
          other.name == this.name &&
          other.selected == this.selected);
}

class CitiesCompanion extends UpdateCompanion<City> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> selected;
  const CitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.selected = const Value.absent(),
  });
  CitiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.selected = const Value.absent(),
  }) : name = Value(name);
  static Insertable<City> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? selected,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (selected != null) 'selected': selected,
    });
  }

  CitiesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<bool>? selected}) {
    return CitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      selected: selected ?? this.selected,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (selected.present) {
      map['selected'] = Variable<bool>(selected.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('selected: $selected')
          ..write(')'))
        .toString();
  }
}

class $PrayerTimesTable extends PrayerTimes
    with TableInfo<$PrayerTimesTable, PrayerTime> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayerTimesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<int> cityId = GeneratedColumn<int>(
      'city_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _morningMeta =
      const VerificationMeta('morning');
  @override
  late final GeneratedColumn<String> morning = GeneratedColumn<String>(
      'morning', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sunriseMeta =
      const VerificationMeta('sunrise');
  @override
  late final GeneratedColumn<String> sunrise = GeneratedColumn<String>(
      'sunrise', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noonMeta = const VerificationMeta('noon');
  @override
  late final GeneratedColumn<String> noon = GeneratedColumn<String>(
      'noon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _afternoonMeta =
      const VerificationMeta('afternoon');
  @override
  late final GeneratedColumn<String> afternoon = GeneratedColumn<String>(
      'afternoon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sunsetMeta = const VerificationMeta('sunset');
  @override
  late final GeneratedColumn<String> sunset = GeneratedColumn<String>(
      'sunset', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nightMeta = const VerificationMeta('night');
  @override
  late final GeneratedColumn<String> night = GeneratedColumn<String>(
      'night', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [cityId, date, morning, sunrise, noon, afternoon, sunset, night];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayer_times';
  @override
  VerificationContext validateIntegrity(Insertable<PrayerTime> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('city_id')) {
      context.handle(_cityIdMeta,
          cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta));
    } else if (isInserting) {
      context.missing(_cityIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('morning')) {
      context.handle(_morningMeta,
          morning.isAcceptableOrUnknown(data['morning']!, _morningMeta));
    } else if (isInserting) {
      context.missing(_morningMeta);
    }
    if (data.containsKey('sunrise')) {
      context.handle(_sunriseMeta,
          sunrise.isAcceptableOrUnknown(data['sunrise']!, _sunriseMeta));
    } else if (isInserting) {
      context.missing(_sunriseMeta);
    }
    if (data.containsKey('noon')) {
      context.handle(
          _noonMeta, noon.isAcceptableOrUnknown(data['noon']!, _noonMeta));
    } else if (isInserting) {
      context.missing(_noonMeta);
    }
    if (data.containsKey('afternoon')) {
      context.handle(_afternoonMeta,
          afternoon.isAcceptableOrUnknown(data['afternoon']!, _afternoonMeta));
    } else if (isInserting) {
      context.missing(_afternoonMeta);
    }
    if (data.containsKey('sunset')) {
      context.handle(_sunsetMeta,
          sunset.isAcceptableOrUnknown(data['sunset']!, _sunsetMeta));
    } else if (isInserting) {
      context.missing(_sunsetMeta);
    }
    if (data.containsKey('night')) {
      context.handle(
          _nightMeta, night.isAcceptableOrUnknown(data['night']!, _nightMeta));
    } else if (isInserting) {
      context.missing(_nightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cityId, date};
  @override
  PrayerTime map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrayerTime(
      cityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}city_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      morning: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}morning'])!,
      sunrise: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sunrise'])!,
      noon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}noon'])!,
      afternoon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}afternoon'])!,
      sunset: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sunset'])!,
      night: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}night'])!,
    );
  }

  @override
  $PrayerTimesTable createAlias(String alias) {
    return $PrayerTimesTable(attachedDatabase, alias);
  }
}

class PrayerTime extends DataClass implements Insertable<PrayerTime> {
  final int cityId;
  final String date;
  final String morning;
  final String sunrise;
  final String noon;
  final String afternoon;
  final String sunset;
  final String night;
  const PrayerTime(
      {required this.cityId,
      required this.date,
      required this.morning,
      required this.sunrise,
      required this.noon,
      required this.afternoon,
      required this.sunset,
      required this.night});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['city_id'] = Variable<int>(cityId);
    map['date'] = Variable<String>(date);
    map['morning'] = Variable<String>(morning);
    map['sunrise'] = Variable<String>(sunrise);
    map['noon'] = Variable<String>(noon);
    map['afternoon'] = Variable<String>(afternoon);
    map['sunset'] = Variable<String>(sunset);
    map['night'] = Variable<String>(night);
    return map;
  }

  PrayerTimesCompanion toCompanion(bool nullToAbsent) {
    return PrayerTimesCompanion(
      cityId: Value(cityId),
      date: Value(date),
      morning: Value(morning),
      sunrise: Value(sunrise),
      noon: Value(noon),
      afternoon: Value(afternoon),
      sunset: Value(sunset),
      night: Value(night),
    );
  }

  factory PrayerTime.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrayerTime(
      cityId: serializer.fromJson<int>(json['cityId']),
      date: serializer.fromJson<String>(json['date']),
      morning: serializer.fromJson<String>(json['morning']),
      sunrise: serializer.fromJson<String>(json['sunrise']),
      noon: serializer.fromJson<String>(json['noon']),
      afternoon: serializer.fromJson<String>(json['afternoon']),
      sunset: serializer.fromJson<String>(json['sunset']),
      night: serializer.fromJson<String>(json['night']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cityId': serializer.toJson<int>(cityId),
      'date': serializer.toJson<String>(date),
      'morning': serializer.toJson<String>(morning),
      'sunrise': serializer.toJson<String>(sunrise),
      'noon': serializer.toJson<String>(noon),
      'afternoon': serializer.toJson<String>(afternoon),
      'sunset': serializer.toJson<String>(sunset),
      'night': serializer.toJson<String>(night),
    };
  }

  PrayerTime copyWith(
          {int? cityId,
          String? date,
          String? morning,
          String? sunrise,
          String? noon,
          String? afternoon,
          String? sunset,
          String? night}) =>
      PrayerTime(
        cityId: cityId ?? this.cityId,
        date: date ?? this.date,
        morning: morning ?? this.morning,
        sunrise: sunrise ?? this.sunrise,
        noon: noon ?? this.noon,
        afternoon: afternoon ?? this.afternoon,
        sunset: sunset ?? this.sunset,
        night: night ?? this.night,
      );
  PrayerTime copyWithCompanion(PrayerTimesCompanion data) {
    return PrayerTime(
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      date: data.date.present ? data.date.value : this.date,
      morning: data.morning.present ? data.morning.value : this.morning,
      sunrise: data.sunrise.present ? data.sunrise.value : this.sunrise,
      noon: data.noon.present ? data.noon.value : this.noon,
      afternoon: data.afternoon.present ? data.afternoon.value : this.afternoon,
      sunset: data.sunset.present ? data.sunset.value : this.sunset,
      night: data.night.present ? data.night.value : this.night,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrayerTime(')
          ..write('cityId: $cityId, ')
          ..write('date: $date, ')
          ..write('morning: $morning, ')
          ..write('sunrise: $sunrise, ')
          ..write('noon: $noon, ')
          ..write('afternoon: $afternoon, ')
          ..write('sunset: $sunset, ')
          ..write('night: $night')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cityId, date, morning, sunrise, noon, afternoon, sunset, night);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrayerTime &&
          other.cityId == this.cityId &&
          other.date == this.date &&
          other.morning == this.morning &&
          other.sunrise == this.sunrise &&
          other.noon == this.noon &&
          other.afternoon == this.afternoon &&
          other.sunset == this.sunset &&
          other.night == this.night);
}

class PrayerTimesCompanion extends UpdateCompanion<PrayerTime> {
  final Value<int> cityId;
  final Value<String> date;
  final Value<String> morning;
  final Value<String> sunrise;
  final Value<String> noon;
  final Value<String> afternoon;
  final Value<String> sunset;
  final Value<String> night;
  final Value<int> rowid;
  const PrayerTimesCompanion({
    this.cityId = const Value.absent(),
    this.date = const Value.absent(),
    this.morning = const Value.absent(),
    this.sunrise = const Value.absent(),
    this.noon = const Value.absent(),
    this.afternoon = const Value.absent(),
    this.sunset = const Value.absent(),
    this.night = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrayerTimesCompanion.insert({
    required int cityId,
    required String date,
    required String morning,
    required String sunrise,
    required String noon,
    required String afternoon,
    required String sunset,
    required String night,
    this.rowid = const Value.absent(),
  })  : cityId = Value(cityId),
        date = Value(date),
        morning = Value(morning),
        sunrise = Value(sunrise),
        noon = Value(noon),
        afternoon = Value(afternoon),
        sunset = Value(sunset),
        night = Value(night);
  static Insertable<PrayerTime> custom({
    Expression<int>? cityId,
    Expression<String>? date,
    Expression<String>? morning,
    Expression<String>? sunrise,
    Expression<String>? noon,
    Expression<String>? afternoon,
    Expression<String>? sunset,
    Expression<String>? night,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cityId != null) 'city_id': cityId,
      if (date != null) 'date': date,
      if (morning != null) 'morning': morning,
      if (sunrise != null) 'sunrise': sunrise,
      if (noon != null) 'noon': noon,
      if (afternoon != null) 'afternoon': afternoon,
      if (sunset != null) 'sunset': sunset,
      if (night != null) 'night': night,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrayerTimesCompanion copyWith(
      {Value<int>? cityId,
      Value<String>? date,
      Value<String>? morning,
      Value<String>? sunrise,
      Value<String>? noon,
      Value<String>? afternoon,
      Value<String>? sunset,
      Value<String>? night,
      Value<int>? rowid}) {
    return PrayerTimesCompanion(
      cityId: cityId ?? this.cityId,
      date: date ?? this.date,
      morning: morning ?? this.morning,
      sunrise: sunrise ?? this.sunrise,
      noon: noon ?? this.noon,
      afternoon: afternoon ?? this.afternoon,
      sunset: sunset ?? this.sunset,
      night: night ?? this.night,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cityId.present) {
      map['city_id'] = Variable<int>(cityId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (morning.present) {
      map['morning'] = Variable<String>(morning.value);
    }
    if (sunrise.present) {
      map['sunrise'] = Variable<String>(sunrise.value);
    }
    if (noon.present) {
      map['noon'] = Variable<String>(noon.value);
    }
    if (afternoon.present) {
      map['afternoon'] = Variable<String>(afternoon.value);
    }
    if (sunset.present) {
      map['sunset'] = Variable<String>(sunset.value);
    }
    if (night.present) {
      map['night'] = Variable<String>(night.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayerTimesCompanion(')
          ..write('cityId: $cityId, ')
          ..write('date: $date, ')
          ..write('morning: $morning, ')
          ..write('sunrise: $sunrise, ')
          ..write('noon: $noon, ')
          ..write('afternoon: $afternoon, ')
          ..write('sunset: $sunset, ')
          ..write('night: $night, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CitiesTable cities = $CitiesTable(this);
  late final $PrayerTimesTable prayerTimes = $PrayerTimesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cities, prayerTimes];
}

typedef $$CitiesTableCreateCompanionBuilder = CitiesCompanion Function({
  Value<int> id,
  required String name,
  Value<bool> selected,
});
typedef $$CitiesTableUpdateCompanionBuilder = CitiesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<bool> selected,
});

class $$CitiesTableFilterComposer
    extends Composer<_$AppDatabase, $CitiesTable> {
  $$CitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get selected => $composableBuilder(
      column: $table.selected, builder: (column) => ColumnFilters(column));
}

class $$CitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $CitiesTable> {
  $$CitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get selected => $composableBuilder(
      column: $table.selected, builder: (column) => ColumnOrderings(column));
}

class $$CitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CitiesTable> {
  $$CitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get selected =>
      $composableBuilder(column: $table.selected, builder: (column) => column);
}

class $$CitiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CitiesTable,
    City,
    $$CitiesTableFilterComposer,
    $$CitiesTableOrderingComposer,
    $$CitiesTableAnnotationComposer,
    $$CitiesTableCreateCompanionBuilder,
    $$CitiesTableUpdateCompanionBuilder,
    (City, BaseReferences<_$AppDatabase, $CitiesTable, City>),
    City,
    PrefetchHooks Function()> {
  $$CitiesTableTableManager(_$AppDatabase db, $CitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> selected = const Value.absent(),
          }) =>
              CitiesCompanion(
            id: id,
            name: name,
            selected: selected,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<bool> selected = const Value.absent(),
          }) =>
              CitiesCompanion.insert(
            id: id,
            name: name,
            selected: selected,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CitiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CitiesTable,
    City,
    $$CitiesTableFilterComposer,
    $$CitiesTableOrderingComposer,
    $$CitiesTableAnnotationComposer,
    $$CitiesTableCreateCompanionBuilder,
    $$CitiesTableUpdateCompanionBuilder,
    (City, BaseReferences<_$AppDatabase, $CitiesTable, City>),
    City,
    PrefetchHooks Function()>;
typedef $$PrayerTimesTableCreateCompanionBuilder = PrayerTimesCompanion
    Function({
  required int cityId,
  required String date,
  required String morning,
  required String sunrise,
  required String noon,
  required String afternoon,
  required String sunset,
  required String night,
  Value<int> rowid,
});
typedef $$PrayerTimesTableUpdateCompanionBuilder = PrayerTimesCompanion
    Function({
  Value<int> cityId,
  Value<String> date,
  Value<String> morning,
  Value<String> sunrise,
  Value<String> noon,
  Value<String> afternoon,
  Value<String> sunset,
  Value<String> night,
  Value<int> rowid,
});

class $$PrayerTimesTableFilterComposer
    extends Composer<_$AppDatabase, $PrayerTimesTable> {
  $$PrayerTimesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get cityId => $composableBuilder(
      column: $table.cityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get morning => $composableBuilder(
      column: $table.morning, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sunrise => $composableBuilder(
      column: $table.sunrise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noon => $composableBuilder(
      column: $table.noon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get afternoon => $composableBuilder(
      column: $table.afternoon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sunset => $composableBuilder(
      column: $table.sunset, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get night => $composableBuilder(
      column: $table.night, builder: (column) => ColumnFilters(column));
}

class $$PrayerTimesTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayerTimesTable> {
  $$PrayerTimesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get cityId => $composableBuilder(
      column: $table.cityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get morning => $composableBuilder(
      column: $table.morning, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sunrise => $composableBuilder(
      column: $table.sunrise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noon => $composableBuilder(
      column: $table.noon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get afternoon => $composableBuilder(
      column: $table.afternoon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sunset => $composableBuilder(
      column: $table.sunset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get night => $composableBuilder(
      column: $table.night, builder: (column) => ColumnOrderings(column));
}

class $$PrayerTimesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayerTimesTable> {
  $$PrayerTimesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get cityId =>
      $composableBuilder(column: $table.cityId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get morning =>
      $composableBuilder(column: $table.morning, builder: (column) => column);

  GeneratedColumn<String> get sunrise =>
      $composableBuilder(column: $table.sunrise, builder: (column) => column);

  GeneratedColumn<String> get noon =>
      $composableBuilder(column: $table.noon, builder: (column) => column);

  GeneratedColumn<String> get afternoon =>
      $composableBuilder(column: $table.afternoon, builder: (column) => column);

  GeneratedColumn<String> get sunset =>
      $composableBuilder(column: $table.sunset, builder: (column) => column);

  GeneratedColumn<String> get night =>
      $composableBuilder(column: $table.night, builder: (column) => column);
}

class $$PrayerTimesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrayerTimesTable,
    PrayerTime,
    $$PrayerTimesTableFilterComposer,
    $$PrayerTimesTableOrderingComposer,
    $$PrayerTimesTableAnnotationComposer,
    $$PrayerTimesTableCreateCompanionBuilder,
    $$PrayerTimesTableUpdateCompanionBuilder,
    (PrayerTime, BaseReferences<_$AppDatabase, $PrayerTimesTable, PrayerTime>),
    PrayerTime,
    PrefetchHooks Function()> {
  $$PrayerTimesTableTableManager(_$AppDatabase db, $PrayerTimesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayerTimesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayerTimesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayerTimesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> cityId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> morning = const Value.absent(),
            Value<String> sunrise = const Value.absent(),
            Value<String> noon = const Value.absent(),
            Value<String> afternoon = const Value.absent(),
            Value<String> sunset = const Value.absent(),
            Value<String> night = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrayerTimesCompanion(
            cityId: cityId,
            date: date,
            morning: morning,
            sunrise: sunrise,
            noon: noon,
            afternoon: afternoon,
            sunset: sunset,
            night: night,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int cityId,
            required String date,
            required String morning,
            required String sunrise,
            required String noon,
            required String afternoon,
            required String sunset,
            required String night,
            Value<int> rowid = const Value.absent(),
          }) =>
              PrayerTimesCompanion.insert(
            cityId: cityId,
            date: date,
            morning: morning,
            sunrise: sunrise,
            noon: noon,
            afternoon: afternoon,
            sunset: sunset,
            night: night,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PrayerTimesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PrayerTimesTable,
    PrayerTime,
    $$PrayerTimesTableFilterComposer,
    $$PrayerTimesTableOrderingComposer,
    $$PrayerTimesTableAnnotationComposer,
    $$PrayerTimesTableCreateCompanionBuilder,
    $$PrayerTimesTableUpdateCompanionBuilder,
    (PrayerTime, BaseReferences<_$AppDatabase, $PrayerTimesTable, PrayerTime>),
    PrayerTime,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CitiesTableTableManager get cities =>
      $$CitiesTableTableManager(_db, _db.cities);
  $$PrayerTimesTableTableManager get prayerTimes =>
      $$PrayerTimesTableTableManager(_db, _db.prayerTimes);
}
