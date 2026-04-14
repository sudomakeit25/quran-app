// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SurahsTable extends Surahs with TableInfo<$SurahsTable, Surah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameArabicMeta =
      const VerificationMeta('nameArabic');
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
      'name_arabic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnglishMeta =
      const VerificationMeta('nameEnglish');
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
      'name_english', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameTranslationMeta =
      const VerificationMeta('nameTranslation');
  @override
  late final GeneratedColumn<String> nameTranslation = GeneratedColumn<String>(
      'name_translation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _revelationPlaceMeta =
      const VerificationMeta('revelationPlace');
  @override
  late final GeneratedColumn<String> revelationPlace = GeneratedColumn<String>(
      'revelation_place', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versesCountMeta =
      const VerificationMeta('versesCount');
  @override
  late final GeneratedColumn<int> versesCount = GeneratedColumn<int>(
      'verses_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        number,
        nameArabic,
        nameEnglish,
        nameTranslation,
        revelationPlace,
        versesCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(Insertable<Surah> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
          _nameArabicMeta,
          nameArabic.isAcceptableOrUnknown(
              data['name_arabic']!, _nameArabicMeta));
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
          _nameEnglishMeta,
          nameEnglish.isAcceptableOrUnknown(
              data['name_english']!, _nameEnglishMeta));
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('name_translation')) {
      context.handle(
          _nameTranslationMeta,
          nameTranslation.isAcceptableOrUnknown(
              data['name_translation']!, _nameTranslationMeta));
    } else if (isInserting) {
      context.missing(_nameTranslationMeta);
    }
    if (data.containsKey('revelation_place')) {
      context.handle(
          _revelationPlaceMeta,
          revelationPlace.isAcceptableOrUnknown(
              data['revelation_place']!, _revelationPlaceMeta));
    } else if (isInserting) {
      context.missing(_revelationPlaceMeta);
    }
    if (data.containsKey('verses_count')) {
      context.handle(
          _versesCountMeta,
          versesCount.isAcceptableOrUnknown(
              data['verses_count']!, _versesCountMeta));
    } else if (isInserting) {
      context.missing(_versesCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {number};
  @override
  Surah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surah(
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      nameArabic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_arabic'])!,
      nameEnglish: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_english'])!,
      nameTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}name_translation'])!,
      revelationPlace: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}revelation_place'])!,
      versesCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verses_count'])!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class Surah extends DataClass implements Insertable<Surah> {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTranslation;
  final String revelationPlace;
  final int versesCount;
  const Surah(
      {required this.number,
      required this.nameArabic,
      required this.nameEnglish,
      required this.nameTranslation,
      required this.revelationPlace,
      required this.versesCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['number'] = Variable<int>(number);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['name_english'] = Variable<String>(nameEnglish);
    map['name_translation'] = Variable<String>(nameTranslation);
    map['revelation_place'] = Variable<String>(revelationPlace);
    map['verses_count'] = Variable<int>(versesCount);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      number: Value(number),
      nameArabic: Value(nameArabic),
      nameEnglish: Value(nameEnglish),
      nameTranslation: Value(nameTranslation),
      revelationPlace: Value(revelationPlace),
      versesCount: Value(versesCount),
    );
  }

  factory Surah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surah(
      number: serializer.fromJson<int>(json['number']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      nameTranslation: serializer.fromJson<String>(json['nameTranslation']),
      revelationPlace: serializer.fromJson<String>(json['revelationPlace']),
      versesCount: serializer.fromJson<int>(json['versesCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'number': serializer.toJson<int>(number),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'nameTranslation': serializer.toJson<String>(nameTranslation),
      'revelationPlace': serializer.toJson<String>(revelationPlace),
      'versesCount': serializer.toJson<int>(versesCount),
    };
  }

  Surah copyWith(
          {int? number,
          String? nameArabic,
          String? nameEnglish,
          String? nameTranslation,
          String? revelationPlace,
          int? versesCount}) =>
      Surah(
        number: number ?? this.number,
        nameArabic: nameArabic ?? this.nameArabic,
        nameEnglish: nameEnglish ?? this.nameEnglish,
        nameTranslation: nameTranslation ?? this.nameTranslation,
        revelationPlace: revelationPlace ?? this.revelationPlace,
        versesCount: versesCount ?? this.versesCount,
      );
  Surah copyWithCompanion(SurahsCompanion data) {
    return Surah(
      number: data.number.present ? data.number.value : this.number,
      nameArabic:
          data.nameArabic.present ? data.nameArabic.value : this.nameArabic,
      nameEnglish:
          data.nameEnglish.present ? data.nameEnglish.value : this.nameEnglish,
      nameTranslation: data.nameTranslation.present
          ? data.nameTranslation.value
          : this.nameTranslation,
      revelationPlace: data.revelationPlace.present
          ? data.revelationPlace.value
          : this.revelationPlace,
      versesCount:
          data.versesCount.present ? data.versesCount.value : this.versesCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Surah(')
          ..write('number: $number, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('nameTranslation: $nameTranslation, ')
          ..write('revelationPlace: $revelationPlace, ')
          ..write('versesCount: $versesCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(number, nameArabic, nameEnglish,
      nameTranslation, revelationPlace, versesCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.number == this.number &&
          other.nameArabic == this.nameArabic &&
          other.nameEnglish == this.nameEnglish &&
          other.nameTranslation == this.nameTranslation &&
          other.revelationPlace == this.revelationPlace &&
          other.versesCount == this.versesCount);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<int> number;
  final Value<String> nameArabic;
  final Value<String> nameEnglish;
  final Value<String> nameTranslation;
  final Value<String> revelationPlace;
  final Value<int> versesCount;
  const SurahsCompanion({
    this.number = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.nameTranslation = const Value.absent(),
    this.revelationPlace = const Value.absent(),
    this.versesCount = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.number = const Value.absent(),
    required String nameArabic,
    required String nameEnglish,
    required String nameTranslation,
    required String revelationPlace,
    required int versesCount,
  })  : nameArabic = Value(nameArabic),
        nameEnglish = Value(nameEnglish),
        nameTranslation = Value(nameTranslation),
        revelationPlace = Value(revelationPlace),
        versesCount = Value(versesCount);
  static Insertable<Surah> custom({
    Expression<int>? number,
    Expression<String>? nameArabic,
    Expression<String>? nameEnglish,
    Expression<String>? nameTranslation,
    Expression<String>? revelationPlace,
    Expression<int>? versesCount,
  }) {
    return RawValuesInsertable({
      if (number != null) 'number': number,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (nameTranslation != null) 'name_translation': nameTranslation,
      if (revelationPlace != null) 'revelation_place': revelationPlace,
      if (versesCount != null) 'verses_count': versesCount,
    });
  }

  SurahsCompanion copyWith(
      {Value<int>? number,
      Value<String>? nameArabic,
      Value<String>? nameEnglish,
      Value<String>? nameTranslation,
      Value<String>? revelationPlace,
      Value<int>? versesCount}) {
    return SurahsCompanion(
      number: number ?? this.number,
      nameArabic: nameArabic ?? this.nameArabic,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      nameTranslation: nameTranslation ?? this.nameTranslation,
      revelationPlace: revelationPlace ?? this.revelationPlace,
      versesCount: versesCount ?? this.versesCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (nameTranslation.present) {
      map['name_translation'] = Variable<String>(nameTranslation.value);
    }
    if (revelationPlace.present) {
      map['revelation_place'] = Variable<String>(revelationPlace.value);
    }
    if (versesCount.present) {
      map['verses_count'] = Variable<int>(versesCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('number: $number, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('nameTranslation: $nameTranslation, ')
          ..write('revelationPlace: $revelationPlace, ')
          ..write('versesCount: $versesCount')
          ..write(')'))
        .toString();
  }
}

class $AyahsTable extends Ayahs with TableInfo<$AyahsTable, Ayah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _surahNumberMeta =
      const VerificationMeta('surahNumber');
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
      'surah_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (number)'));
  static const VerificationMeta _ayahNumberMeta =
      const VerificationMeta('ayahNumber');
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
      'ayah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textArabicMeta =
      const VerificationMeta('textArabic');
  @override
  late final GeneratedColumn<String> textArabic = GeneratedColumn<String>(
      'text_arabic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _juzMeta = const VerificationMeta('juz');
  @override
  late final GeneratedColumn<int> juz = GeneratedColumn<int>(
      'juz', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
      'page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [surahNumber, ayahNumber, textArabic, juz, page];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayahs';
  @override
  VerificationContext validateIntegrity(Insertable<Ayah> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('surah_number')) {
      context.handle(
          _surahNumberMeta,
          surahNumber.isAcceptableOrUnknown(
              data['surah_number']!, _surahNumberMeta));
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
          _ayahNumberMeta,
          ayahNumber.isAcceptableOrUnknown(
              data['ayah_number']!, _ayahNumberMeta));
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('text_arabic')) {
      context.handle(
          _textArabicMeta,
          textArabic.isAcceptableOrUnknown(
              data['text_arabic']!, _textArabicMeta));
    } else if (isInserting) {
      context.missing(_textArabicMeta);
    }
    if (data.containsKey('juz')) {
      context.handle(
          _juzMeta, juz.isAcceptableOrUnknown(data['juz']!, _juzMeta));
    }
    if (data.containsKey('page')) {
      context.handle(
          _pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {surahNumber, ayahNumber};
  @override
  Ayah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ayah(
      surahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_number'])!,
      ayahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ayah_number'])!,
      textArabic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_arabic'])!,
      juz: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}juz'])!,
      page: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page'])!,
    );
  }

  @override
  $AyahsTable createAlias(String alias) {
    return $AyahsTable(attachedDatabase, alias);
  }
}

class Ayah extends DataClass implements Insertable<Ayah> {
  final int surahNumber;
  final int ayahNumber;
  final String textArabic;
  final int juz;
  final int page;
  const Ayah(
      {required this.surahNumber,
      required this.ayahNumber,
      required this.textArabic,
      required this.juz,
      required this.page});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['text_arabic'] = Variable<String>(textArabic);
    map['juz'] = Variable<int>(juz);
    map['page'] = Variable<int>(page);
    return map;
  }

  AyahsCompanion toCompanion(bool nullToAbsent) {
    return AyahsCompanion(
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      textArabic: Value(textArabic),
      juz: Value(juz),
      page: Value(page),
    );
  }

  factory Ayah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ayah(
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      textArabic: serializer.fromJson<String>(json['textArabic']),
      juz: serializer.fromJson<int>(json['juz']),
      page: serializer.fromJson<int>(json['page']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'textArabic': serializer.toJson<String>(textArabic),
      'juz': serializer.toJson<int>(juz),
      'page': serializer.toJson<int>(page),
    };
  }

  Ayah copyWith(
          {int? surahNumber,
          int? ayahNumber,
          String? textArabic,
          int? juz,
          int? page}) =>
      Ayah(
        surahNumber: surahNumber ?? this.surahNumber,
        ayahNumber: ayahNumber ?? this.ayahNumber,
        textArabic: textArabic ?? this.textArabic,
        juz: juz ?? this.juz,
        page: page ?? this.page,
      );
  Ayah copyWithCompanion(AyahsCompanion data) {
    return Ayah(
      surahNumber:
          data.surahNumber.present ? data.surahNumber.value : this.surahNumber,
      ayahNumber:
          data.ayahNumber.present ? data.ayahNumber.value : this.ayahNumber,
      textArabic:
          data.textArabic.present ? data.textArabic.value : this.textArabic,
      juz: data.juz.present ? data.juz.value : this.juz,
      page: data.page.present ? data.page.value : this.page,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ayah(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('textArabic: $textArabic, ')
          ..write('juz: $juz, ')
          ..write('page: $page')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(surahNumber, ayahNumber, textArabic, juz, page);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ayah &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.textArabic == this.textArabic &&
          other.juz == this.juz &&
          other.page == this.page);
}

class AyahsCompanion extends UpdateCompanion<Ayah> {
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String> textArabic;
  final Value<int> juz;
  final Value<int> page;
  final Value<int> rowid;
  const AyahsCompanion({
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.textArabic = const Value.absent(),
    this.juz = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AyahsCompanion.insert({
    required int surahNumber,
    required int ayahNumber,
    required String textArabic,
    this.juz = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : surahNumber = Value(surahNumber),
        ayahNumber = Value(ayahNumber),
        textArabic = Value(textArabic);
  static Insertable<Ayah> custom({
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? textArabic,
    Expression<int>? juz,
    Expression<int>? page,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (textArabic != null) 'text_arabic': textArabic,
      if (juz != null) 'juz': juz,
      if (page != null) 'page': page,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AyahsCompanion copyWith(
      {Value<int>? surahNumber,
      Value<int>? ayahNumber,
      Value<String>? textArabic,
      Value<int>? juz,
      Value<int>? page,
      Value<int>? rowid}) {
    return AyahsCompanion(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      textArabic: textArabic ?? this.textArabic,
      juz: juz ?? this.juz,
      page: page ?? this.page,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (textArabic.present) {
      map['text_arabic'] = Variable<String>(textArabic.value);
    }
    if (juz.present) {
      map['juz'] = Variable<int>(juz.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahsCompanion(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('textArabic: $textArabic, ')
          ..write('juz: $juz, ')
          ..write('page: $page, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AyahTranslationsTable extends AyahTranslations
    with TableInfo<$AyahTranslationsTable, AyahTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _surahNumberMeta =
      const VerificationMeta('surahNumber');
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
      'surah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ayahNumberMeta =
      const VerificationMeta('ayahNumber');
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
      'ayah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _translatorMeta =
      const VerificationMeta('translator');
  @override
  late final GeneratedColumn<String> translator = GeneratedColumn<String>(
      'translator', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [surahNumber, ayahNumber, language, translator, body];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayah_translations';
  @override
  VerificationContext validateIntegrity(Insertable<AyahTranslation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('surah_number')) {
      context.handle(
          _surahNumberMeta,
          surahNumber.isAcceptableOrUnknown(
              data['surah_number']!, _surahNumberMeta));
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
          _ayahNumberMeta,
          ayahNumber.isAcceptableOrUnknown(
              data['ayah_number']!, _ayahNumberMeta));
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('translator')) {
      context.handle(
          _translatorMeta,
          translator.isAcceptableOrUnknown(
              data['translator']!, _translatorMeta));
    } else if (isInserting) {
      context.missing(_translatorMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey =>
      {surahNumber, ayahNumber, language, translator};
  @override
  AyahTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AyahTranslation(
      surahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_number'])!,
      ayahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ayah_number'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      translator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translator'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
    );
  }

  @override
  $AyahTranslationsTable createAlias(String alias) {
    return $AyahTranslationsTable(attachedDatabase, alias);
  }
}

class AyahTranslation extends DataClass implements Insertable<AyahTranslation> {
  final int surahNumber;
  final int ayahNumber;
  final String language;
  final String translator;
  final String body;
  const AyahTranslation(
      {required this.surahNumber,
      required this.ayahNumber,
      required this.language,
      required this.translator,
      required this.body});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['language'] = Variable<String>(language);
    map['translator'] = Variable<String>(translator);
    map['body'] = Variable<String>(body);
    return map;
  }

  AyahTranslationsCompanion toCompanion(bool nullToAbsent) {
    return AyahTranslationsCompanion(
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      language: Value(language),
      translator: Value(translator),
      body: Value(body),
    );
  }

  factory AyahTranslation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AyahTranslation(
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      language: serializer.fromJson<String>(json['language']),
      translator: serializer.fromJson<String>(json['translator']),
      body: serializer.fromJson<String>(json['body']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'language': serializer.toJson<String>(language),
      'translator': serializer.toJson<String>(translator),
      'body': serializer.toJson<String>(body),
    };
  }

  AyahTranslation copyWith(
          {int? surahNumber,
          int? ayahNumber,
          String? language,
          String? translator,
          String? body}) =>
      AyahTranslation(
        surahNumber: surahNumber ?? this.surahNumber,
        ayahNumber: ayahNumber ?? this.ayahNumber,
        language: language ?? this.language,
        translator: translator ?? this.translator,
        body: body ?? this.body,
      );
  AyahTranslation copyWithCompanion(AyahTranslationsCompanion data) {
    return AyahTranslation(
      surahNumber:
          data.surahNumber.present ? data.surahNumber.value : this.surahNumber,
      ayahNumber:
          data.ayahNumber.present ? data.ayahNumber.value : this.ayahNumber,
      language: data.language.present ? data.language.value : this.language,
      translator:
          data.translator.present ? data.translator.value : this.translator,
      body: data.body.present ? data.body.value : this.body,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AyahTranslation(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('language: $language, ')
          ..write('translator: $translator, ')
          ..write('body: $body')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(surahNumber, ayahNumber, language, translator, body);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AyahTranslation &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.language == this.language &&
          other.translator == this.translator &&
          other.body == this.body);
}

class AyahTranslationsCompanion extends UpdateCompanion<AyahTranslation> {
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String> language;
  final Value<String> translator;
  final Value<String> body;
  final Value<int> rowid;
  const AyahTranslationsCompanion({
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.language = const Value.absent(),
    this.translator = const Value.absent(),
    this.body = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AyahTranslationsCompanion.insert({
    required int surahNumber,
    required int ayahNumber,
    required String language,
    required String translator,
    required String body,
    this.rowid = const Value.absent(),
  })  : surahNumber = Value(surahNumber),
        ayahNumber = Value(ayahNumber),
        language = Value(language),
        translator = Value(translator),
        body = Value(body);
  static Insertable<AyahTranslation> custom({
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? language,
    Expression<String>? translator,
    Expression<String>? body,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (language != null) 'language': language,
      if (translator != null) 'translator': translator,
      if (body != null) 'body': body,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AyahTranslationsCompanion copyWith(
      {Value<int>? surahNumber,
      Value<int>? ayahNumber,
      Value<String>? language,
      Value<String>? translator,
      Value<String>? body,
      Value<int>? rowid}) {
    return AyahTranslationsCompanion(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      language: language ?? this.language,
      translator: translator ?? this.translator,
      body: body ?? this.body,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (translator.present) {
      map['translator'] = Variable<String>(translator.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahTranslationsCompanion(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('language: $language, ')
          ..write('translator: $translator, ')
          ..write('body: $body, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $AyahsTable ayahs = $AyahsTable(this);
  late final $AyahTranslationsTable ayahTranslations =
      $AyahTranslationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [surahs, ayahs, ayahTranslations];
}

typedef $$SurahsTableCreateCompanionBuilder = SurahsCompanion Function({
  Value<int> number,
  required String nameArabic,
  required String nameEnglish,
  required String nameTranslation,
  required String revelationPlace,
  required int versesCount,
});
typedef $$SurahsTableUpdateCompanionBuilder = SurahsCompanion Function({
  Value<int> number,
  Value<String> nameArabic,
  Value<String> nameEnglish,
  Value<String> nameTranslation,
  Value<String> revelationPlace,
  Value<int> versesCount,
});

final class $$SurahsTableReferences
    extends BaseReferences<_$AppDatabase, $SurahsTable, Surah> {
  $$SurahsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AyahsTable, List<Ayah>> _ayahsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.ayahs,
          aliasName:
              $_aliasNameGenerator(db.surahs.number, db.ayahs.surahNumber));

  $$AyahsTableProcessedTableManager get ayahsRefs {
    final manager = $$AyahsTableTableManager($_db, $_db.ayahs).filter(
        (f) => f.surahNumber.number.sqlEquals($_itemColumn<int>('number')!));

    final cache = $_typedResult.readTableOrNull(_ayahsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SurahsTableFilterComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameArabic => $composableBuilder(
      column: $table.nameArabic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameTranslation => $composableBuilder(
      column: $table.nameTranslation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get revelationPlace => $composableBuilder(
      column: $table.revelationPlace,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get versesCount => $composableBuilder(
      column: $table.versesCount, builder: (column) => ColumnFilters(column));

  Expression<bool> ayahsRefs(
      Expression<bool> Function($$AyahsTableFilterComposer f) f) {
    final $$AyahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.number,
        referencedTable: $db.ayahs,
        getReferencedColumn: (t) => t.surahNumber,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AyahsTableFilterComposer(
              $db: $db,
              $table: $db.ayahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SurahsTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameArabic => $composableBuilder(
      column: $table.nameArabic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameTranslation => $composableBuilder(
      column: $table.nameTranslation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get revelationPlace => $composableBuilder(
      column: $table.revelationPlace,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get versesCount => $composableBuilder(
      column: $table.versesCount, builder: (column) => ColumnOrderings(column));
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
      column: $table.nameArabic, builder: (column) => column);

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => column);

  GeneratedColumn<String> get nameTranslation => $composableBuilder(
      column: $table.nameTranslation, builder: (column) => column);

  GeneratedColumn<String> get revelationPlace => $composableBuilder(
      column: $table.revelationPlace, builder: (column) => column);

  GeneratedColumn<int> get versesCount => $composableBuilder(
      column: $table.versesCount, builder: (column) => column);

  Expression<T> ayahsRefs<T extends Object>(
      Expression<T> Function($$AyahsTableAnnotationComposer a) f) {
    final $$AyahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.number,
        referencedTable: $db.ayahs,
        getReferencedColumn: (t) => t.surahNumber,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AyahsTableAnnotationComposer(
              $db: $db,
              $table: $db.ayahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SurahsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SurahsTable,
    Surah,
    $$SurahsTableFilterComposer,
    $$SurahsTableOrderingComposer,
    $$SurahsTableAnnotationComposer,
    $$SurahsTableCreateCompanionBuilder,
    $$SurahsTableUpdateCompanionBuilder,
    (Surah, $$SurahsTableReferences),
    Surah,
    PrefetchHooks Function({bool ayahsRefs})> {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> number = const Value.absent(),
            Value<String> nameArabic = const Value.absent(),
            Value<String> nameEnglish = const Value.absent(),
            Value<String> nameTranslation = const Value.absent(),
            Value<String> revelationPlace = const Value.absent(),
            Value<int> versesCount = const Value.absent(),
          }) =>
              SurahsCompanion(
            number: number,
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            nameTranslation: nameTranslation,
            revelationPlace: revelationPlace,
            versesCount: versesCount,
          ),
          createCompanionCallback: ({
            Value<int> number = const Value.absent(),
            required String nameArabic,
            required String nameEnglish,
            required String nameTranslation,
            required String revelationPlace,
            required int versesCount,
          }) =>
              SurahsCompanion.insert(
            number: number,
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            nameTranslation: nameTranslation,
            revelationPlace: revelationPlace,
            versesCount: versesCount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SurahsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({ayahsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ayahsRefs) db.ayahs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ayahsRefs)
                    await $_getPrefetchedData<Surah, $SurahsTable, Ayah>(
                        currentTable: table,
                        referencedTable:
                            $$SurahsTableReferences._ayahsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SurahsTableReferences(db, table, p0).ayahsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.surahNumber == item.number),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SurahsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SurahsTable,
    Surah,
    $$SurahsTableFilterComposer,
    $$SurahsTableOrderingComposer,
    $$SurahsTableAnnotationComposer,
    $$SurahsTableCreateCompanionBuilder,
    $$SurahsTableUpdateCompanionBuilder,
    (Surah, $$SurahsTableReferences),
    Surah,
    PrefetchHooks Function({bool ayahsRefs})>;
typedef $$AyahsTableCreateCompanionBuilder = AyahsCompanion Function({
  required int surahNumber,
  required int ayahNumber,
  required String textArabic,
  Value<int> juz,
  Value<int> page,
  Value<int> rowid,
});
typedef $$AyahsTableUpdateCompanionBuilder = AyahsCompanion Function({
  Value<int> surahNumber,
  Value<int> ayahNumber,
  Value<String> textArabic,
  Value<int> juz,
  Value<int> page,
  Value<int> rowid,
});

final class $$AyahsTableReferences
    extends BaseReferences<_$AppDatabase, $AyahsTable, Ayah> {
  $$AyahsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SurahsTable _surahNumberTable(_$AppDatabase db) =>
      db.surahs.createAlias(
          $_aliasNameGenerator(db.ayahs.surahNumber, db.surahs.number));

  $$SurahsTableProcessedTableManager get surahNumber {
    final $_column = $_itemColumn<int>('surah_number')!;

    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.number.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahNumberTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AyahsTableFilterComposer extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ayahNumber => $composableBuilder(
      column: $table.ayahNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textArabic => $composableBuilder(
      column: $table.textArabic, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get juz => $composableBuilder(
      column: $table.juz, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnFilters(column));

  $$SurahsTableFilterComposer get surahNumber {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahNumber,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.number,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AyahsTableOrderingComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ayahNumber => $composableBuilder(
      column: $table.ayahNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textArabic => $composableBuilder(
      column: $table.textArabic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get juz => $composableBuilder(
      column: $table.juz, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnOrderings(column));

  $$SurahsTableOrderingComposer get surahNumber {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahNumber,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.number,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AyahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ayahNumber => $composableBuilder(
      column: $table.ayahNumber, builder: (column) => column);

  GeneratedColumn<String> get textArabic => $composableBuilder(
      column: $table.textArabic, builder: (column) => column);

  GeneratedColumn<int> get juz =>
      $composableBuilder(column: $table.juz, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  $$SurahsTableAnnotationComposer get surahNumber {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahNumber,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.number,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AyahsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AyahsTable,
    Ayah,
    $$AyahsTableFilterComposer,
    $$AyahsTableOrderingComposer,
    $$AyahsTableAnnotationComposer,
    $$AyahsTableCreateCompanionBuilder,
    $$AyahsTableUpdateCompanionBuilder,
    (Ayah, $$AyahsTableReferences),
    Ayah,
    PrefetchHooks Function({bool surahNumber})> {
  $$AyahsTableTableManager(_$AppDatabase db, $AyahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AyahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AyahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AyahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> surahNumber = const Value.absent(),
            Value<int> ayahNumber = const Value.absent(),
            Value<String> textArabic = const Value.absent(),
            Value<int> juz = const Value.absent(),
            Value<int> page = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AyahsCompanion(
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            textArabic: textArabic,
            juz: juz,
            page: page,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int surahNumber,
            required int ayahNumber,
            required String textArabic,
            Value<int> juz = const Value.absent(),
            Value<int> page = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AyahsCompanion.insert(
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            textArabic: textArabic,
            juz: juz,
            page: page,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AyahsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({surahNumber = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (surahNumber) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.surahNumber,
                    referencedTable:
                        $$AyahsTableReferences._surahNumberTable(db),
                    referencedColumn:
                        $$AyahsTableReferences._surahNumberTable(db).number,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AyahsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AyahsTable,
    Ayah,
    $$AyahsTableFilterComposer,
    $$AyahsTableOrderingComposer,
    $$AyahsTableAnnotationComposer,
    $$AyahsTableCreateCompanionBuilder,
    $$AyahsTableUpdateCompanionBuilder,
    (Ayah, $$AyahsTableReferences),
    Ayah,
    PrefetchHooks Function({bool surahNumber})>;
typedef $$AyahTranslationsTableCreateCompanionBuilder
    = AyahTranslationsCompanion Function({
  required int surahNumber,
  required int ayahNumber,
  required String language,
  required String translator,
  required String body,
  Value<int> rowid,
});
typedef $$AyahTranslationsTableUpdateCompanionBuilder
    = AyahTranslationsCompanion Function({
  Value<int> surahNumber,
  Value<int> ayahNumber,
  Value<String> language,
  Value<String> translator,
  Value<String> body,
  Value<int> rowid,
});

class $$AyahTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $AyahTranslationsTable> {
  $$AyahTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ayahNumber => $composableBuilder(
      column: $table.ayahNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translator => $composableBuilder(
      column: $table.translator, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));
}

class $$AyahTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AyahTranslationsTable> {
  $$AyahTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
      column: $table.ayahNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translator => $composableBuilder(
      column: $table.translator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));
}

class $$AyahTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AyahTranslationsTable> {
  $$AyahTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => column);

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
      column: $table.ayahNumber, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get translator => $composableBuilder(
      column: $table.translator, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);
}

class $$AyahTranslationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AyahTranslationsTable,
    AyahTranslation,
    $$AyahTranslationsTableFilterComposer,
    $$AyahTranslationsTableOrderingComposer,
    $$AyahTranslationsTableAnnotationComposer,
    $$AyahTranslationsTableCreateCompanionBuilder,
    $$AyahTranslationsTableUpdateCompanionBuilder,
    (
      AyahTranslation,
      BaseReferences<_$AppDatabase, $AyahTranslationsTable, AyahTranslation>
    ),
    AyahTranslation,
    PrefetchHooks Function()> {
  $$AyahTranslationsTableTableManager(
      _$AppDatabase db, $AyahTranslationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AyahTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AyahTranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AyahTranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> surahNumber = const Value.absent(),
            Value<int> ayahNumber = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> translator = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AyahTranslationsCompanion(
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            language: language,
            translator: translator,
            body: body,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int surahNumber,
            required int ayahNumber,
            required String language,
            required String translator,
            required String body,
            Value<int> rowid = const Value.absent(),
          }) =>
              AyahTranslationsCompanion.insert(
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            language: language,
            translator: translator,
            body: body,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AyahTranslationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AyahTranslationsTable,
    AyahTranslation,
    $$AyahTranslationsTableFilterComposer,
    $$AyahTranslationsTableOrderingComposer,
    $$AyahTranslationsTableAnnotationComposer,
    $$AyahTranslationsTableCreateCompanionBuilder,
    $$AyahTranslationsTableUpdateCompanionBuilder,
    (
      AyahTranslation,
      BaseReferences<_$AppDatabase, $AyahTranslationsTable, AyahTranslation>
    ),
    AyahTranslation,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$AyahsTableTableManager get ayahs =>
      $$AyahsTableTableManager(_db, _db.ayahs);
  $$AyahTranslationsTableTableManager get ayahTranslations =>
      $$AyahTranslationsTableTableManager(_db, _db.ayahTranslations);
}
