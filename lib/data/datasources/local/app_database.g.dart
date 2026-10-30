// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
      'salt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, role, pinHash, salt, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
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
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('salt')) {
      context.handle(
          _saltMeta, salt.isAcceptableOrUnknown(data['salt']!, _saltMeta));
    } else if (isInserting) {
      context.missing(_saltMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash'])!,
      salt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salt'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String role;
  final String pinHash;
  final String salt;
  final bool isActive;
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.name,
      required this.role,
      required this.pinHash,
      required this.salt,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['pin_hash'] = Variable<String>(pinHash);
    map['salt'] = Variable<String>(salt);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      pinHash: Value(pinHash),
      salt: Value(salt),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      salt: serializer.fromJson<String>(json['salt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'pinHash': serializer.toJson<String>(pinHash),
      'salt': serializer.toJson<String>(salt),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          String? role,
          String? pinHash,
          String? salt,
          bool? isActive,
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        pinHash: pinHash ?? this.pinHash,
        salt: salt ?? this.salt,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      salt: data.salt.present ? data.salt.value : this.salt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('salt: $salt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, role, pinHash, salt, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.pinHash == this.pinHash &&
          other.salt == this.salt &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> role;
  final Value<String> pinHash;
  final Value<String> salt;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.salt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String role,
    required String pinHash,
    required String salt,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        role = Value(role),
        pinHash = Value(pinHash),
        salt = Value(salt);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? pinHash,
    Expression<String>? salt,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (pinHash != null) 'pin_hash': pinHash,
      if (salt != null) 'salt': salt,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? role,
      Value<String>? pinHash,
      Value<String>? salt,
      Value<bool>? isActive,
      Value<DateTime>? createdAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      salt: salt ?? this.salt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
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
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('salt: $salt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, name, displayOrder, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
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
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int displayOrder;
  final bool isActive;
  const Category(
      {required this.id,
      required this.name,
      required this.displayOrder,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['display_order'] = Variable<int>(displayOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      displayOrder: Value(displayOrder),
      isActive: Value(isActive),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Category copyWith(
          {int? id, String? name, int? displayOrder, bool? isActive}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        displayOrder: displayOrder ?? this.displayOrder,
        isActive: isActive ?? this.isActive,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, displayOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.displayOrder == this.displayOrder &&
          other.isActive == this.isActive);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> displayOrder;
  final Value<bool> isActive;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.displayOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? displayOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? displayOrder,
      Value<bool>? isActive}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
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
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MenuItemsTable extends MenuItems
    with TableInfo<$MenuItemsTable, MenuItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _taxRateMeta =
      const VerificationMeta('taxRate');
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
      'tax_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(5.0));
  static const VerificationMeta _hsnCodeMeta =
      const VerificationMeta('hsnCode');
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
      'hsn_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isVegMeta = const VerificationMeta('isVeg');
  @override
  late final GeneratedColumn<bool> isVeg = GeneratedColumn<bool>(
      'is_veg', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_veg" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, name, price, taxRate, hsnCode, isVeg, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_items';
  @override
  VerificationContext validateIntegrity(Insertable<MenuItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('tax_rate')) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta));
    }
    if (data.containsKey('hsn_code')) {
      context.handle(_hsnCodeMeta,
          hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta));
    }
    if (data.containsKey('is_veg')) {
      context.handle(
          _isVegMeta, isVeg.isAcceptableOrUnknown(data['is_veg']!, _isVegMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      taxRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_rate'])!,
      hsnCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hsn_code']),
      isVeg: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_veg'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $MenuItemsTable createAlias(String alias) {
    return $MenuItemsTable(attachedDatabase, alias);
  }
}

class MenuItem extends DataClass implements Insertable<MenuItem> {
  final int id;
  final int categoryId;
  final String name;
  final double price;
  final double taxRate;
  final String? hsnCode;
  final bool isVeg;
  final bool isActive;
  const MenuItem(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.price,
      required this.taxRate,
      this.hsnCode,
      required this.isVeg,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['tax_rate'] = Variable<double>(taxRate);
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['is_veg'] = Variable<bool>(isVeg);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MenuItemsCompanion toCompanion(bool nullToAbsent) {
    return MenuItemsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      price: Value(price),
      taxRate: Value(taxRate),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      isVeg: Value(isVeg),
      isActive: Value(isActive),
    );
  }

  factory MenuItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItem(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      isVeg: serializer.fromJson<bool>(json['isVeg']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'taxRate': serializer.toJson<double>(taxRate),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'isVeg': serializer.toJson<bool>(isVeg),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MenuItem copyWith(
          {int? id,
          int? categoryId,
          String? name,
          double? price,
          double? taxRate,
          Value<String?> hsnCode = const Value.absent(),
          bool? isVeg,
          bool? isActive}) =>
      MenuItem(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        price: price ?? this.price,
        taxRate: taxRate ?? this.taxRate,
        hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
        isVeg: isVeg ?? this.isVeg,
        isActive: isActive ?? this.isActive,
      );
  MenuItem copyWithCompanion(MenuItemsCompanion data) {
    return MenuItem(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      isVeg: data.isVeg.present ? data.isVeg.value : this.isVeg,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItem(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('taxRate: $taxRate, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('isVeg: $isVeg, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, categoryId, name, price, taxRate, hsnCode, isVeg, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItem &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.price == this.price &&
          other.taxRate == this.taxRate &&
          other.hsnCode == this.hsnCode &&
          other.isVeg == this.isVeg &&
          other.isActive == this.isActive);
}

class MenuItemsCompanion extends UpdateCompanion<MenuItem> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> name;
  final Value<double> price;
  final Value<double> taxRate;
  final Value<String?> hsnCode;
  final Value<bool> isVeg;
  final Value<bool> isActive;
  const MenuItemsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.isVeg = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MenuItemsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String name,
    required double price,
    this.taxRate = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.isVeg = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : categoryId = Value(categoryId),
        name = Value(name),
        price = Value(price);
  static Insertable<MenuItem> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? name,
    Expression<double>? price,
    Expression<double>? taxRate,
    Expression<String>? hsnCode,
    Expression<bool>? isVeg,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (taxRate != null) 'tax_rate': taxRate,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (isVeg != null) 'is_veg': isVeg,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MenuItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? name,
      Value<double>? price,
      Value<double>? taxRate,
      Value<String?>? hsnCode,
      Value<bool>? isVeg,
      Value<bool>? isActive}) {
    return MenuItemsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      taxRate: taxRate ?? this.taxRate,
      hsnCode: hsnCode ?? this.hsnCode,
      isVeg: isVeg ?? this.isVeg,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (isVeg.present) {
      map['is_veg'] = Variable<bool>(isVeg.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('taxRate: $taxRate, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('isVeg: $isVeg, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tokenNoMeta =
      const VerificationMeta('tokenNo');
  @override
  late final GeneratedColumn<int> tokenNo = GeneratedColumn<int>(
      'token_no', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _orderTypeMeta =
      const VerificationMeta('orderType');
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
      'order_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('takeaway'));
  static const VerificationMeta _tokenStatusMeta =
      const VerificationMeta('tokenStatus');
  @override
  late final GeneratedColumn<String> tokenStatus = GeneratedColumn<String>(
      'token_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('preparing'));
  static const VerificationMeta _waiterIdMeta =
      const VerificationMeta('waiterId');
  @override
  late final GeneratedColumn<int> waiterId = GeneratedColumn<int>(
      'waiter_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tokenNo,
        orderType,
        tokenStatus,
        waiterId,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<Order> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('token_no')) {
      context.handle(_tokenNoMeta,
          tokenNo.isAcceptableOrUnknown(data['token_no']!, _tokenNoMeta));
    }
    if (data.containsKey('order_type')) {
      context.handle(_orderTypeMeta,
          orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta));
    }
    if (data.containsKey('token_status')) {
      context.handle(
          _tokenStatusMeta,
          tokenStatus.isAcceptableOrUnknown(
              data['token_status']!, _tokenStatusMeta));
    }
    if (data.containsKey('waiter_id')) {
      context.handle(_waiterIdMeta,
          waiterId.isAcceptableOrUnknown(data['waiter_id']!, _waiterIdMeta));
    } else if (isInserting) {
      context.missing(_waiterIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tokenNo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}token_no'])!,
      orderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_type'])!,
      tokenStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token_status'])!,
      waiterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}waiter_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final int tokenNo;
  final String orderType;
  final String tokenStatus;
  final int waiterId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Order(
      {required this.id,
      required this.tokenNo,
      required this.orderType,
      required this.tokenStatus,
      required this.waiterId,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['token_no'] = Variable<int>(tokenNo);
    map['order_type'] = Variable<String>(orderType);
    map['token_status'] = Variable<String>(tokenStatus);
    map['waiter_id'] = Variable<int>(waiterId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      tokenNo: Value(tokenNo),
      orderType: Value(orderType),
      tokenStatus: Value(tokenStatus),
      waiterId: Value(waiterId),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      tokenNo: serializer.fromJson<int>(json['tokenNo']),
      orderType: serializer.fromJson<String>(json['orderType']),
      tokenStatus: serializer.fromJson<String>(json['tokenStatus']),
      waiterId: serializer.fromJson<int>(json['waiterId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tokenNo': serializer.toJson<int>(tokenNo),
      'orderType': serializer.toJson<String>(orderType),
      'tokenStatus': serializer.toJson<String>(tokenStatus),
      'waiterId': serializer.toJson<int>(waiterId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Order copyWith(
          {int? id,
          int? tokenNo,
          String? orderType,
          String? tokenStatus,
          int? waiterId,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Order(
        id: id ?? this.id,
        tokenNo: tokenNo ?? this.tokenNo,
        orderType: orderType ?? this.orderType,
        tokenStatus: tokenStatus ?? this.tokenStatus,
        waiterId: waiterId ?? this.waiterId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      tokenNo: data.tokenNo.present ? data.tokenNo.value : this.tokenNo,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      tokenStatus:
          data.tokenStatus.present ? data.tokenStatus.value : this.tokenStatus,
      waiterId: data.waiterId.present ? data.waiterId.value : this.waiterId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('tokenNo: $tokenNo, ')
          ..write('orderType: $orderType, ')
          ..write('tokenStatus: $tokenStatus, ')
          ..write('waiterId: $waiterId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tokenNo, orderType, tokenStatus, waiterId,
      status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.tokenNo == this.tokenNo &&
          other.orderType == this.orderType &&
          other.tokenStatus == this.tokenStatus &&
          other.waiterId == this.waiterId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<int> tokenNo;
  final Value<String> orderType;
  final Value<String> tokenStatus;
  final Value<int> waiterId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.tokenNo = const Value.absent(),
    this.orderType = const Value.absent(),
    this.tokenStatus = const Value.absent(),
    this.waiterId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    this.tokenNo = const Value.absent(),
    this.orderType = const Value.absent(),
    this.tokenStatus = const Value.absent(),
    required int waiterId,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : waiterId = Value(waiterId);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<int>? tokenNo,
    Expression<String>? orderType,
    Expression<String>? tokenStatus,
    Expression<int>? waiterId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokenNo != null) 'token_no': tokenNo,
      if (orderType != null) 'order_type': orderType,
      if (tokenStatus != null) 'token_status': tokenStatus,
      if (waiterId != null) 'waiter_id': waiterId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrdersCompanion copyWith(
      {Value<int>? id,
      Value<int>? tokenNo,
      Value<String>? orderType,
      Value<String>? tokenStatus,
      Value<int>? waiterId,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return OrdersCompanion(
      id: id ?? this.id,
      tokenNo: tokenNo ?? this.tokenNo,
      orderType: orderType ?? this.orderType,
      tokenStatus: tokenStatus ?? this.tokenStatus,
      waiterId: waiterId ?? this.waiterId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tokenNo.present) {
      map['token_no'] = Variable<int>(tokenNo.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (tokenStatus.present) {
      map['token_status'] = Variable<String>(tokenStatus.value);
    }
    if (waiterId.present) {
      map['waiter_id'] = Variable<int>(waiterId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('tokenNo: $tokenNo, ')
          ..write('orderType: $orderType, ')
          ..write('tokenStatus: $tokenStatus, ')
          ..write('waiterId: $waiterId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceAtOrderMeta =
      const VerificationMeta('priceAtOrder');
  @override
  late final GeneratedColumn<double> priceAtOrder = GeneratedColumn<double>(
      'price_at_order', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _taxRateAtOrderMeta =
      const VerificationMeta('taxRateAtOrder');
  @override
  late final GeneratedColumn<double> taxRateAtOrder = GeneratedColumn<double>(
      'tax_rate_at_order', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(5.0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _kotPrintedQuantityMeta =
      const VerificationMeta('kotPrintedQuantity');
  @override
  late final GeneratedColumn<int> kotPrintedQuantity = GeneratedColumn<int>(
      'kot_printed_quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        itemId,
        quantity,
        priceAtOrder,
        taxRateAtOrder,
        notes,
        status,
        kotPrintedQuantity
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price_at_order')) {
      context.handle(
          _priceAtOrderMeta,
          priceAtOrder.isAcceptableOrUnknown(
              data['price_at_order']!, _priceAtOrderMeta));
    } else if (isInserting) {
      context.missing(_priceAtOrderMeta);
    }
    if (data.containsKey('tax_rate_at_order')) {
      context.handle(
          _taxRateAtOrderMeta,
          taxRateAtOrder.isAcceptableOrUnknown(
              data['tax_rate_at_order']!, _taxRateAtOrderMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('kot_printed_quantity')) {
      context.handle(
          _kotPrintedQuantityMeta,
          kotPrintedQuantity.isAcceptableOrUnknown(
              data['kot_printed_quantity']!, _kotPrintedQuantityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      priceAtOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_at_order'])!,
      taxRateAtOrder: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}tax_rate_at_order'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      kotPrintedQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}kot_printed_quantity'])!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final int itemId;
  final int quantity;
  final double priceAtOrder;
  final double taxRateAtOrder;
  final String? notes;
  final String status;
  final int kotPrintedQuantity;
  const OrderItem(
      {required this.id,
      required this.orderId,
      required this.itemId,
      required this.quantity,
      required this.priceAtOrder,
      required this.taxRateAtOrder,
      this.notes,
      required this.status,
      required this.kotPrintedQuantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['item_id'] = Variable<int>(itemId);
    map['quantity'] = Variable<int>(quantity);
    map['price_at_order'] = Variable<double>(priceAtOrder);
    map['tax_rate_at_order'] = Variable<double>(taxRateAtOrder);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['kot_printed_quantity'] = Variable<int>(kotPrintedQuantity);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      itemId: Value(itemId),
      quantity: Value(quantity),
      priceAtOrder: Value(priceAtOrder),
      taxRateAtOrder: Value(taxRateAtOrder),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      status: Value(status),
      kotPrintedQuantity: Value(kotPrintedQuantity),
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      priceAtOrder: serializer.fromJson<double>(json['priceAtOrder']),
      taxRateAtOrder: serializer.fromJson<double>(json['taxRateAtOrder']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      kotPrintedQuantity: serializer.fromJson<int>(json['kotPrintedQuantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'itemId': serializer.toJson<int>(itemId),
      'quantity': serializer.toJson<int>(quantity),
      'priceAtOrder': serializer.toJson<double>(priceAtOrder),
      'taxRateAtOrder': serializer.toJson<double>(taxRateAtOrder),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'kotPrintedQuantity': serializer.toJson<int>(kotPrintedQuantity),
    };
  }

  OrderItem copyWith(
          {int? id,
          int? orderId,
          int? itemId,
          int? quantity,
          double? priceAtOrder,
          double? taxRateAtOrder,
          Value<String?> notes = const Value.absent(),
          String? status,
          int? kotPrintedQuantity}) =>
      OrderItem(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        itemId: itemId ?? this.itemId,
        quantity: quantity ?? this.quantity,
        priceAtOrder: priceAtOrder ?? this.priceAtOrder,
        taxRateAtOrder: taxRateAtOrder ?? this.taxRateAtOrder,
        notes: notes.present ? notes.value : this.notes,
        status: status ?? this.status,
        kotPrintedQuantity: kotPrintedQuantity ?? this.kotPrintedQuantity,
      );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      priceAtOrder: data.priceAtOrder.present
          ? data.priceAtOrder.value
          : this.priceAtOrder,
      taxRateAtOrder: data.taxRateAtOrder.present
          ? data.taxRateAtOrder.value
          : this.taxRateAtOrder,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      kotPrintedQuantity: data.kotPrintedQuantity.present
          ? data.kotPrintedQuantity.value
          : this.kotPrintedQuantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity, ')
          ..write('priceAtOrder: $priceAtOrder, ')
          ..write('taxRateAtOrder: $taxRateAtOrder, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('kotPrintedQuantity: $kotPrintedQuantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, itemId, quantity, priceAtOrder,
      taxRateAtOrder, notes, status, kotPrintedQuantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.itemId == this.itemId &&
          other.quantity == this.quantity &&
          other.priceAtOrder == this.priceAtOrder &&
          other.taxRateAtOrder == this.taxRateAtOrder &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.kotPrintedQuantity == this.kotPrintedQuantity);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> itemId;
  final Value<int> quantity;
  final Value<double> priceAtOrder;
  final Value<double> taxRateAtOrder;
  final Value<String?> notes;
  final Value<String> status;
  final Value<int> kotPrintedQuantity;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceAtOrder = const Value.absent(),
    this.taxRateAtOrder = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.kotPrintedQuantity = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int itemId,
    required int quantity,
    required double priceAtOrder,
    this.taxRateAtOrder = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.kotPrintedQuantity = const Value.absent(),
  })  : orderId = Value(orderId),
        itemId = Value(itemId),
        quantity = Value(quantity),
        priceAtOrder = Value(priceAtOrder);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? itemId,
    Expression<int>? quantity,
    Expression<double>? priceAtOrder,
    Expression<double>? taxRateAtOrder,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<int>? kotPrintedQuantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (itemId != null) 'item_id': itemId,
      if (quantity != null) 'quantity': quantity,
      if (priceAtOrder != null) 'price_at_order': priceAtOrder,
      if (taxRateAtOrder != null) 'tax_rate_at_order': taxRateAtOrder,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (kotPrintedQuantity != null)
        'kot_printed_quantity': kotPrintedQuantity,
    });
  }

  OrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? itemId,
      Value<int>? quantity,
      Value<double>? priceAtOrder,
      Value<double>? taxRateAtOrder,
      Value<String?>? notes,
      Value<String>? status,
      Value<int>? kotPrintedQuantity}) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
      priceAtOrder: priceAtOrder ?? this.priceAtOrder,
      taxRateAtOrder: taxRateAtOrder ?? this.taxRateAtOrder,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      kotPrintedQuantity: kotPrintedQuantity ?? this.kotPrintedQuantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (priceAtOrder.present) {
      map['price_at_order'] = Variable<double>(priceAtOrder.value);
    }
    if (taxRateAtOrder.present) {
      map['tax_rate_at_order'] = Variable<double>(taxRateAtOrder.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (kotPrintedQuantity.present) {
      map['kot_printed_quantity'] = Variable<int>(kotPrintedQuantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity, ')
          ..write('priceAtOrder: $priceAtOrder, ')
          ..write('taxRateAtOrder: $taxRateAtOrder, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('kotPrintedQuantity: $kotPrintedQuantity')
          ..write(')'))
        .toString();
  }
}

class $BillsTable extends Bills with TableInfo<$BillsTable, Bill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _billNoMeta = const VerificationMeta('billNo');
  @override
  late final GeneratedColumn<String> billNo = GeneratedColumn<String>(
      'bill_no', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _discountTypeMeta =
      const VerificationMeta('discountType');
  @override
  late final GeneratedColumn<String> discountType = GeneratedColumn<String>(
      'discount_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('flat'));
  static const VerificationMeta _taxAmountMeta =
      const VerificationMeta('taxAmount');
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
      'tax_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _cgstAmountMeta =
      const VerificationMeta('cgstAmount');
  @override
  late final GeneratedColumn<double> cgstAmount = GeneratedColumn<double>(
      'cgst_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _sgstAmountMeta =
      const VerificationMeta('sgstAmount');
  @override
  late final GeneratedColumn<double> sgstAmount = GeneratedColumn<double>(
      'sgst_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _roundOffMeta =
      const VerificationMeta('roundOff');
  @override
  late final GeneratedColumn<double> roundOff = GeneratedColumn<double>(
      'round_off', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentModeMeta =
      const VerificationMeta('paymentMode');
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
      'payment_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isVoidMeta = const VerificationMeta('isVoid');
  @override
  late final GeneratedColumn<bool> isVoid = GeneratedColumn<bool>(
      'is_void', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_void" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _voidReasonMeta =
      const VerificationMeta('voidReason');
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
      'void_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voidByUserIdMeta =
      const VerificationMeta('voidByUserId');
  @override
  late final GeneratedColumn<int> voidByUserId = GeneratedColumn<int>(
      'void_by_user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        billNo,
        subtotal,
        discount,
        discountType,
        taxAmount,
        cgstAmount,
        sgstAmount,
        roundOff,
        total,
        paymentMode,
        isVoid,
        voidReason,
        voidByUserId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(Insertable<Bill> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('bill_no')) {
      context.handle(_billNoMeta,
          billNo.isAcceptableOrUnknown(data['bill_no']!, _billNoMeta));
    } else if (isInserting) {
      context.missing(_billNoMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('discount_type')) {
      context.handle(
          _discountTypeMeta,
          discountType.isAcceptableOrUnknown(
              data['discount_type']!, _discountTypeMeta));
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta));
    } else if (isInserting) {
      context.missing(_taxAmountMeta);
    }
    if (data.containsKey('cgst_amount')) {
      context.handle(
          _cgstAmountMeta,
          cgstAmount.isAcceptableOrUnknown(
              data['cgst_amount']!, _cgstAmountMeta));
    }
    if (data.containsKey('sgst_amount')) {
      context.handle(
          _sgstAmountMeta,
          sgstAmount.isAcceptableOrUnknown(
              data['sgst_amount']!, _sgstAmountMeta));
    }
    if (data.containsKey('round_off')) {
      context.handle(_roundOffMeta,
          roundOff.isAcceptableOrUnknown(data['round_off']!, _roundOffMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
          _paymentModeMeta,
          paymentMode.isAcceptableOrUnknown(
              data['payment_mode']!, _paymentModeMeta));
    } else if (isInserting) {
      context.missing(_paymentModeMeta);
    }
    if (data.containsKey('is_void')) {
      context.handle(_isVoidMeta,
          isVoid.isAcceptableOrUnknown(data['is_void']!, _isVoidMeta));
    }
    if (data.containsKey('void_reason')) {
      context.handle(
          _voidReasonMeta,
          voidReason.isAcceptableOrUnknown(
              data['void_reason']!, _voidReasonMeta));
    }
    if (data.containsKey('void_by_user_id')) {
      context.handle(
          _voidByUserIdMeta,
          voidByUserId.isAcceptableOrUnknown(
              data['void_by_user_id']!, _voidByUserIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bill(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      billNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_no'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      discountType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}discount_type'])!,
      taxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_amount'])!,
      cgstAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cgst_amount'])!,
      sgstAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sgst_amount'])!,
      roundOff: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}round_off'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      isVoid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_void'])!,
      voidReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}void_reason']),
      voidByUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}void_by_user_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BillsTable createAlias(String alias) {
    return $BillsTable(attachedDatabase, alias);
  }
}

class Bill extends DataClass implements Insertable<Bill> {
  final int id;
  final int orderId;
  final String billNo;
  final double subtotal;
  final double discount;
  final String discountType;
  final double taxAmount;
  final double cgstAmount;
  final double sgstAmount;
  final double roundOff;
  final double total;
  final String paymentMode;
  final bool isVoid;
  final String? voidReason;
  final int? voidByUserId;
  final DateTime createdAt;
  const Bill(
      {required this.id,
      required this.orderId,
      required this.billNo,
      required this.subtotal,
      required this.discount,
      required this.discountType,
      required this.taxAmount,
      required this.cgstAmount,
      required this.sgstAmount,
      required this.roundOff,
      required this.total,
      required this.paymentMode,
      required this.isVoid,
      this.voidReason,
      this.voidByUserId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['bill_no'] = Variable<String>(billNo);
    map['subtotal'] = Variable<double>(subtotal);
    map['discount'] = Variable<double>(discount);
    map['discount_type'] = Variable<String>(discountType);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['cgst_amount'] = Variable<double>(cgstAmount);
    map['sgst_amount'] = Variable<double>(sgstAmount);
    map['round_off'] = Variable<double>(roundOff);
    map['total'] = Variable<double>(total);
    map['payment_mode'] = Variable<String>(paymentMode);
    map['is_void'] = Variable<bool>(isVoid);
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    if (!nullToAbsent || voidByUserId != null) {
      map['void_by_user_id'] = Variable<int>(voidByUserId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BillsCompanion toCompanion(bool nullToAbsent) {
    return BillsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      billNo: Value(billNo),
      subtotal: Value(subtotal),
      discount: Value(discount),
      discountType: Value(discountType),
      taxAmount: Value(taxAmount),
      cgstAmount: Value(cgstAmount),
      sgstAmount: Value(sgstAmount),
      roundOff: Value(roundOff),
      total: Value(total),
      paymentMode: Value(paymentMode),
      isVoid: Value(isVoid),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
      voidByUserId: voidByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(voidByUserId),
      createdAt: Value(createdAt),
    );
  }

  factory Bill.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bill(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      billNo: serializer.fromJson<String>(json['billNo']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discount: serializer.fromJson<double>(json['discount']),
      discountType: serializer.fromJson<String>(json['discountType']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      cgstAmount: serializer.fromJson<double>(json['cgstAmount']),
      sgstAmount: serializer.fromJson<double>(json['sgstAmount']),
      roundOff: serializer.fromJson<double>(json['roundOff']),
      total: serializer.fromJson<double>(json['total']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      isVoid: serializer.fromJson<bool>(json['isVoid']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
      voidByUserId: serializer.fromJson<int?>(json['voidByUserId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'billNo': serializer.toJson<String>(billNo),
      'subtotal': serializer.toJson<double>(subtotal),
      'discount': serializer.toJson<double>(discount),
      'discountType': serializer.toJson<String>(discountType),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'cgstAmount': serializer.toJson<double>(cgstAmount),
      'sgstAmount': serializer.toJson<double>(sgstAmount),
      'roundOff': serializer.toJson<double>(roundOff),
      'total': serializer.toJson<double>(total),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'isVoid': serializer.toJson<bool>(isVoid),
      'voidReason': serializer.toJson<String?>(voidReason),
      'voidByUserId': serializer.toJson<int?>(voidByUserId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bill copyWith(
          {int? id,
          int? orderId,
          String? billNo,
          double? subtotal,
          double? discount,
          String? discountType,
          double? taxAmount,
          double? cgstAmount,
          double? sgstAmount,
          double? roundOff,
          double? total,
          String? paymentMode,
          bool? isVoid,
          Value<String?> voidReason = const Value.absent(),
          Value<int?> voidByUserId = const Value.absent(),
          DateTime? createdAt}) =>
      Bill(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        billNo: billNo ?? this.billNo,
        subtotal: subtotal ?? this.subtotal,
        discount: discount ?? this.discount,
        discountType: discountType ?? this.discountType,
        taxAmount: taxAmount ?? this.taxAmount,
        cgstAmount: cgstAmount ?? this.cgstAmount,
        sgstAmount: sgstAmount ?? this.sgstAmount,
        roundOff: roundOff ?? this.roundOff,
        total: total ?? this.total,
        paymentMode: paymentMode ?? this.paymentMode,
        isVoid: isVoid ?? this.isVoid,
        voidReason: voidReason.present ? voidReason.value : this.voidReason,
        voidByUserId:
            voidByUserId.present ? voidByUserId.value : this.voidByUserId,
        createdAt: createdAt ?? this.createdAt,
      );
  Bill copyWithCompanion(BillsCompanion data) {
    return Bill(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      billNo: data.billNo.present ? data.billNo.value : this.billNo,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      cgstAmount:
          data.cgstAmount.present ? data.cgstAmount.value : this.cgstAmount,
      sgstAmount:
          data.sgstAmount.present ? data.sgstAmount.value : this.sgstAmount,
      roundOff: data.roundOff.present ? data.roundOff.value : this.roundOff,
      total: data.total.present ? data.total.value : this.total,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      isVoid: data.isVoid.present ? data.isVoid.value : this.isVoid,
      voidReason:
          data.voidReason.present ? data.voidReason.value : this.voidReason,
      voidByUserId: data.voidByUserId.present
          ? data.voidByUserId.value
          : this.voidByUserId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bill(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('billNo: $billNo, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('discountType: $discountType, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('roundOff: $roundOff, ')
          ..write('total: $total, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('isVoid: $isVoid, ')
          ..write('voidReason: $voidReason, ')
          ..write('voidByUserId: $voidByUserId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      orderId,
      billNo,
      subtotal,
      discount,
      discountType,
      taxAmount,
      cgstAmount,
      sgstAmount,
      roundOff,
      total,
      paymentMode,
      isVoid,
      voidReason,
      voidByUserId,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bill &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.billNo == this.billNo &&
          other.subtotal == this.subtotal &&
          other.discount == this.discount &&
          other.discountType == this.discountType &&
          other.taxAmount == this.taxAmount &&
          other.cgstAmount == this.cgstAmount &&
          other.sgstAmount == this.sgstAmount &&
          other.roundOff == this.roundOff &&
          other.total == this.total &&
          other.paymentMode == this.paymentMode &&
          other.isVoid == this.isVoid &&
          other.voidReason == this.voidReason &&
          other.voidByUserId == this.voidByUserId &&
          other.createdAt == this.createdAt);
}

class BillsCompanion extends UpdateCompanion<Bill> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<String> billNo;
  final Value<double> subtotal;
  final Value<double> discount;
  final Value<String> discountType;
  final Value<double> taxAmount;
  final Value<double> cgstAmount;
  final Value<double> sgstAmount;
  final Value<double> roundOff;
  final Value<double> total;
  final Value<String> paymentMode;
  final Value<bool> isVoid;
  final Value<String?> voidReason;
  final Value<int?> voidByUserId;
  final Value<DateTime> createdAt;
  const BillsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.billNo = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.discountType = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.roundOff = const Value.absent(),
    this.total = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.isVoid = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.voidByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BillsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required String billNo,
    required double subtotal,
    this.discount = const Value.absent(),
    this.discountType = const Value.absent(),
    required double taxAmount,
    this.cgstAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.roundOff = const Value.absent(),
    required double total,
    required String paymentMode,
    this.isVoid = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.voidByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : orderId = Value(orderId),
        billNo = Value(billNo),
        subtotal = Value(subtotal),
        taxAmount = Value(taxAmount),
        total = Value(total),
        paymentMode = Value(paymentMode);
  static Insertable<Bill> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<String>? billNo,
    Expression<double>? subtotal,
    Expression<double>? discount,
    Expression<String>? discountType,
    Expression<double>? taxAmount,
    Expression<double>? cgstAmount,
    Expression<double>? sgstAmount,
    Expression<double>? roundOff,
    Expression<double>? total,
    Expression<String>? paymentMode,
    Expression<bool>? isVoid,
    Expression<String>? voidReason,
    Expression<int>? voidByUserId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (billNo != null) 'bill_no': billNo,
      if (subtotal != null) 'subtotal': subtotal,
      if (discount != null) 'discount': discount,
      if (discountType != null) 'discount_type': discountType,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (cgstAmount != null) 'cgst_amount': cgstAmount,
      if (sgstAmount != null) 'sgst_amount': sgstAmount,
      if (roundOff != null) 'round_off': roundOff,
      if (total != null) 'total': total,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (isVoid != null) 'is_void': isVoid,
      if (voidReason != null) 'void_reason': voidReason,
      if (voidByUserId != null) 'void_by_user_id': voidByUserId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BillsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<String>? billNo,
      Value<double>? subtotal,
      Value<double>? discount,
      Value<String>? discountType,
      Value<double>? taxAmount,
      Value<double>? cgstAmount,
      Value<double>? sgstAmount,
      Value<double>? roundOff,
      Value<double>? total,
      Value<String>? paymentMode,
      Value<bool>? isVoid,
      Value<String?>? voidReason,
      Value<int?>? voidByUserId,
      Value<DateTime>? createdAt}) {
    return BillsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      billNo: billNo ?? this.billNo,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
      taxAmount: taxAmount ?? this.taxAmount,
      cgstAmount: cgstAmount ?? this.cgstAmount,
      sgstAmount: sgstAmount ?? this.sgstAmount,
      roundOff: roundOff ?? this.roundOff,
      total: total ?? this.total,
      paymentMode: paymentMode ?? this.paymentMode,
      isVoid: isVoid ?? this.isVoid,
      voidReason: voidReason ?? this.voidReason,
      voidByUserId: voidByUserId ?? this.voidByUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (billNo.present) {
      map['bill_no'] = Variable<String>(billNo.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(discountType.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (cgstAmount.present) {
      map['cgst_amount'] = Variable<double>(cgstAmount.value);
    }
    if (sgstAmount.present) {
      map['sgst_amount'] = Variable<double>(sgstAmount.value);
    }
    if (roundOff.present) {
      map['round_off'] = Variable<double>(roundOff.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (isVoid.present) {
      map['is_void'] = Variable<bool>(isVoid.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (voidByUserId.present) {
      map['void_by_user_id'] = Variable<int>(voidByUserId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('billNo: $billNo, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('discountType: $discountType, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('roundOff: $roundOff, ')
          ..write('total: $total, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('isVoid: $isVoid, ')
          ..write('voidReason: $voidReason, ')
          ..write('voidByUserId: $voidByUserId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DayCloseTable extends DayClose
    with TableInfo<$DayCloseTable, DayCloseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayCloseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _openingCashMeta =
      const VerificationMeta('openingCash');
  @override
  late final GeneratedColumn<double> openingCash = GeneratedColumn<double>(
      'opening_cash', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _closingCashMeta =
      const VerificationMeta('closingCash');
  @override
  late final GeneratedColumn<double> closingCash = GeneratedColumn<double>(
      'closing_cash', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalSalesMeta =
      const VerificationMeta('totalSales');
  @override
  late final GeneratedColumn<double> totalSales = GeneratedColumn<double>(
      'total_sales', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalOrdersMeta =
      const VerificationMeta('totalOrders');
  @override
  late final GeneratedColumn<int> totalOrders = GeneratedColumn<int>(
      'total_orders', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discrepancyMeta =
      const VerificationMeta('discrepancy');
  @override
  late final GeneratedColumn<double> discrepancy = GeneratedColumn<double>(
      'discrepancy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _closedByUserIdMeta =
      const VerificationMeta('closedByUserId');
  @override
  late final GeneratedColumn<String> closedByUserId = GeneratedColumn<String>(
      'closed_by_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        openingCash,
        closingCash,
        totalSales,
        totalOrders,
        discrepancy,
        closedByUserId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_close';
  @override
  VerificationContext validateIntegrity(Insertable<DayCloseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('opening_cash')) {
      context.handle(
          _openingCashMeta,
          openingCash.isAcceptableOrUnknown(
              data['opening_cash']!, _openingCashMeta));
    } else if (isInserting) {
      context.missing(_openingCashMeta);
    }
    if (data.containsKey('closing_cash')) {
      context.handle(
          _closingCashMeta,
          closingCash.isAcceptableOrUnknown(
              data['closing_cash']!, _closingCashMeta));
    } else if (isInserting) {
      context.missing(_closingCashMeta);
    }
    if (data.containsKey('total_sales')) {
      context.handle(
          _totalSalesMeta,
          totalSales.isAcceptableOrUnknown(
              data['total_sales']!, _totalSalesMeta));
    } else if (isInserting) {
      context.missing(_totalSalesMeta);
    }
    if (data.containsKey('total_orders')) {
      context.handle(
          _totalOrdersMeta,
          totalOrders.isAcceptableOrUnknown(
              data['total_orders']!, _totalOrdersMeta));
    } else if (isInserting) {
      context.missing(_totalOrdersMeta);
    }
    if (data.containsKey('discrepancy')) {
      context.handle(
          _discrepancyMeta,
          discrepancy.isAcceptableOrUnknown(
              data['discrepancy']!, _discrepancyMeta));
    } else if (isInserting) {
      context.missing(_discrepancyMeta);
    }
    if (data.containsKey('closed_by_user_id')) {
      context.handle(
          _closedByUserIdMeta,
          closedByUserId.isAcceptableOrUnknown(
              data['closed_by_user_id']!, _closedByUserIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayCloseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayCloseData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      openingCash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}opening_cash'])!,
      closingCash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}closing_cash'])!,
      totalSales: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_sales'])!,
      totalOrders: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_orders'])!,
      discrepancy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discrepancy'])!,
      closedByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}closed_by_user_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DayCloseTable createAlias(String alias) {
    return $DayCloseTable(attachedDatabase, alias);
  }
}

class DayCloseData extends DataClass implements Insertable<DayCloseData> {
  final int id;
  final DateTime date;
  final double openingCash;
  final double closingCash;
  final double totalSales;
  final int totalOrders;
  final double discrepancy;
  final String? closedByUserId;
  final DateTime createdAt;
  const DayCloseData(
      {required this.id,
      required this.date,
      required this.openingCash,
      required this.closingCash,
      required this.totalSales,
      required this.totalOrders,
      required this.discrepancy,
      this.closedByUserId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['opening_cash'] = Variable<double>(openingCash);
    map['closing_cash'] = Variable<double>(closingCash);
    map['total_sales'] = Variable<double>(totalSales);
    map['total_orders'] = Variable<int>(totalOrders);
    map['discrepancy'] = Variable<double>(discrepancy);
    if (!nullToAbsent || closedByUserId != null) {
      map['closed_by_user_id'] = Variable<String>(closedByUserId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DayCloseCompanion toCompanion(bool nullToAbsent) {
    return DayCloseCompanion(
      id: Value(id),
      date: Value(date),
      openingCash: Value(openingCash),
      closingCash: Value(closingCash),
      totalSales: Value(totalSales),
      totalOrders: Value(totalOrders),
      discrepancy: Value(discrepancy),
      closedByUserId: closedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(closedByUserId),
      createdAt: Value(createdAt),
    );
  }

  factory DayCloseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayCloseData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      openingCash: serializer.fromJson<double>(json['openingCash']),
      closingCash: serializer.fromJson<double>(json['closingCash']),
      totalSales: serializer.fromJson<double>(json['totalSales']),
      totalOrders: serializer.fromJson<int>(json['totalOrders']),
      discrepancy: serializer.fromJson<double>(json['discrepancy']),
      closedByUserId: serializer.fromJson<String?>(json['closedByUserId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'openingCash': serializer.toJson<double>(openingCash),
      'closingCash': serializer.toJson<double>(closingCash),
      'totalSales': serializer.toJson<double>(totalSales),
      'totalOrders': serializer.toJson<int>(totalOrders),
      'discrepancy': serializer.toJson<double>(discrepancy),
      'closedByUserId': serializer.toJson<String?>(closedByUserId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DayCloseData copyWith(
          {int? id,
          DateTime? date,
          double? openingCash,
          double? closingCash,
          double? totalSales,
          int? totalOrders,
          double? discrepancy,
          Value<String?> closedByUserId = const Value.absent(),
          DateTime? createdAt}) =>
      DayCloseData(
        id: id ?? this.id,
        date: date ?? this.date,
        openingCash: openingCash ?? this.openingCash,
        closingCash: closingCash ?? this.closingCash,
        totalSales: totalSales ?? this.totalSales,
        totalOrders: totalOrders ?? this.totalOrders,
        discrepancy: discrepancy ?? this.discrepancy,
        closedByUserId:
            closedByUserId.present ? closedByUserId.value : this.closedByUserId,
        createdAt: createdAt ?? this.createdAt,
      );
  DayCloseData copyWithCompanion(DayCloseCompanion data) {
    return DayCloseData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      openingCash:
          data.openingCash.present ? data.openingCash.value : this.openingCash,
      closingCash:
          data.closingCash.present ? data.closingCash.value : this.closingCash,
      totalSales:
          data.totalSales.present ? data.totalSales.value : this.totalSales,
      totalOrders:
          data.totalOrders.present ? data.totalOrders.value : this.totalOrders,
      discrepancy:
          data.discrepancy.present ? data.discrepancy.value : this.discrepancy,
      closedByUserId: data.closedByUserId.present
          ? data.closedByUserId.value
          : this.closedByUserId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayCloseData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('openingCash: $openingCash, ')
          ..write('closingCash: $closingCash, ')
          ..write('totalSales: $totalSales, ')
          ..write('totalOrders: $totalOrders, ')
          ..write('discrepancy: $discrepancy, ')
          ..write('closedByUserId: $closedByUserId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, openingCash, closingCash,
      totalSales, totalOrders, discrepancy, closedByUserId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayCloseData &&
          other.id == this.id &&
          other.date == this.date &&
          other.openingCash == this.openingCash &&
          other.closingCash == this.closingCash &&
          other.totalSales == this.totalSales &&
          other.totalOrders == this.totalOrders &&
          other.discrepancy == this.discrepancy &&
          other.closedByUserId == this.closedByUserId &&
          other.createdAt == this.createdAt);
}

class DayCloseCompanion extends UpdateCompanion<DayCloseData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> openingCash;
  final Value<double> closingCash;
  final Value<double> totalSales;
  final Value<int> totalOrders;
  final Value<double> discrepancy;
  final Value<String?> closedByUserId;
  final Value<DateTime> createdAt;
  const DayCloseCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.openingCash = const Value.absent(),
    this.closingCash = const Value.absent(),
    this.totalSales = const Value.absent(),
    this.totalOrders = const Value.absent(),
    this.discrepancy = const Value.absent(),
    this.closedByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DayCloseCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double openingCash,
    required double closingCash,
    required double totalSales,
    required int totalOrders,
    required double discrepancy,
    this.closedByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : date = Value(date),
        openingCash = Value(openingCash),
        closingCash = Value(closingCash),
        totalSales = Value(totalSales),
        totalOrders = Value(totalOrders),
        discrepancy = Value(discrepancy);
  static Insertable<DayCloseData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? openingCash,
    Expression<double>? closingCash,
    Expression<double>? totalSales,
    Expression<int>? totalOrders,
    Expression<double>? discrepancy,
    Expression<String>? closedByUserId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (openingCash != null) 'opening_cash': openingCash,
      if (closingCash != null) 'closing_cash': closingCash,
      if (totalSales != null) 'total_sales': totalSales,
      if (totalOrders != null) 'total_orders': totalOrders,
      if (discrepancy != null) 'discrepancy': discrepancy,
      if (closedByUserId != null) 'closed_by_user_id': closedByUserId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DayCloseCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<double>? openingCash,
      Value<double>? closingCash,
      Value<double>? totalSales,
      Value<int>? totalOrders,
      Value<double>? discrepancy,
      Value<String?>? closedByUserId,
      Value<DateTime>? createdAt}) {
    return DayCloseCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      openingCash: openingCash ?? this.openingCash,
      closingCash: closingCash ?? this.closingCash,
      totalSales: totalSales ?? this.totalSales,
      totalOrders: totalOrders ?? this.totalOrders,
      discrepancy: discrepancy ?? this.discrepancy,
      closedByUserId: closedByUserId ?? this.closedByUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (openingCash.present) {
      map['opening_cash'] = Variable<double>(openingCash.value);
    }
    if (closingCash.present) {
      map['closing_cash'] = Variable<double>(closingCash.value);
    }
    if (totalSales.present) {
      map['total_sales'] = Variable<double>(totalSales.value);
    }
    if (totalOrders.present) {
      map['total_orders'] = Variable<int>(totalOrders.value);
    }
    if (discrepancy.present) {
      map['discrepancy'] = Variable<double>(discrepancy.value);
    }
    if (closedByUserId.present) {
      map['closed_by_user_id'] = Variable<String>(closedByUserId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayCloseCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('openingCash: $openingCash, ')
          ..write('closingCash: $closingCash, ')
          ..write('totalSales: $totalSales, ')
          ..write('totalOrders: $totalOrders, ')
          ..write('discrepancy: $discrepancy, ')
          ..write('closedByUserId: $closedByUserId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RestaurantTablesTable extends RestaurantTables
    with TableInfo<$RestaurantTablesTable, RestaurantTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestaurantTablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tableNoMeta =
      const VerificationMeta('tableNo');
  @override
  late final GeneratedColumn<String> tableNo = GeneratedColumn<String>(
      'table_no', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('available'));
  static const VerificationMeta _currentOrderIdMeta =
      const VerificationMeta('currentOrderId');
  @override
  late final GeneratedColumn<int> currentOrderId = GeneratedColumn<int>(
      'current_order_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, tableNo, capacity, status, currentOrderId, displayOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restaurant_tables';
  @override
  VerificationContext validateIntegrity(Insertable<RestaurantTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_no')) {
      context.handle(_tableNoMeta,
          tableNo.isAcceptableOrUnknown(data['table_no']!, _tableNoMeta));
    } else if (isInserting) {
      context.missing(_tableNoMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('current_order_id')) {
      context.handle(
          _currentOrderIdMeta,
          currentOrderId.isAcceptableOrUnknown(
              data['current_order_id']!, _currentOrderIdMeta));
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestaurantTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestaurantTable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tableNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_no'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      currentOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_order_id']),
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
    );
  }

  @override
  $RestaurantTablesTable createAlias(String alias) {
    return $RestaurantTablesTable(attachedDatabase, alias);
  }
}

class RestaurantTable extends DataClass implements Insertable<RestaurantTable> {
  final int id;
  final String tableNo;
  final int capacity;
  final String status;
  final int? currentOrderId;
  final int displayOrder;
  const RestaurantTable(
      {required this.id,
      required this.tableNo,
      required this.capacity,
      required this.status,
      this.currentOrderId,
      required this.displayOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_no'] = Variable<String>(tableNo);
    map['capacity'] = Variable<int>(capacity);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || currentOrderId != null) {
      map['current_order_id'] = Variable<int>(currentOrderId);
    }
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  RestaurantTablesCompanion toCompanion(bool nullToAbsent) {
    return RestaurantTablesCompanion(
      id: Value(id),
      tableNo: Value(tableNo),
      capacity: Value(capacity),
      status: Value(status),
      currentOrderId: currentOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentOrderId),
      displayOrder: Value(displayOrder),
    );
  }

  factory RestaurantTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestaurantTable(
      id: serializer.fromJson<int>(json['id']),
      tableNo: serializer.fromJson<String>(json['tableNo']),
      capacity: serializer.fromJson<int>(json['capacity']),
      status: serializer.fromJson<String>(json['status']),
      currentOrderId: serializer.fromJson<int?>(json['currentOrderId']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tableNo': serializer.toJson<String>(tableNo),
      'capacity': serializer.toJson<int>(capacity),
      'status': serializer.toJson<String>(status),
      'currentOrderId': serializer.toJson<int?>(currentOrderId),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  RestaurantTable copyWith(
          {int? id,
          String? tableNo,
          int? capacity,
          String? status,
          Value<int?> currentOrderId = const Value.absent(),
          int? displayOrder}) =>
      RestaurantTable(
        id: id ?? this.id,
        tableNo: tableNo ?? this.tableNo,
        capacity: capacity ?? this.capacity,
        status: status ?? this.status,
        currentOrderId:
            currentOrderId.present ? currentOrderId.value : this.currentOrderId,
        displayOrder: displayOrder ?? this.displayOrder,
      );
  RestaurantTable copyWithCompanion(RestaurantTablesCompanion data) {
    return RestaurantTable(
      id: data.id.present ? data.id.value : this.id,
      tableNo: data.tableNo.present ? data.tableNo.value : this.tableNo,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      status: data.status.present ? data.status.value : this.status,
      currentOrderId: data.currentOrderId.present
          ? data.currentOrderId.value
          : this.currentOrderId,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTable(')
          ..write('id: $id, ')
          ..write('tableNo: $tableNo, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('currentOrderId: $currentOrderId, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tableNo, capacity, status, currentOrderId, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantTable &&
          other.id == this.id &&
          other.tableNo == this.tableNo &&
          other.capacity == this.capacity &&
          other.status == this.status &&
          other.currentOrderId == this.currentOrderId &&
          other.displayOrder == this.displayOrder);
}

class RestaurantTablesCompanion extends UpdateCompanion<RestaurantTable> {
  final Value<int> id;
  final Value<String> tableNo;
  final Value<int> capacity;
  final Value<String> status;
  final Value<int?> currentOrderId;
  final Value<int> displayOrder;
  const RestaurantTablesCompanion({
    this.id = const Value.absent(),
    this.tableNo = const Value.absent(),
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.currentOrderId = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  RestaurantTablesCompanion.insert({
    this.id = const Value.absent(),
    required String tableNo,
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.currentOrderId = const Value.absent(),
    this.displayOrder = const Value.absent(),
  }) : tableNo = Value(tableNo);
  static Insertable<RestaurantTable> custom({
    Expression<int>? id,
    Expression<String>? tableNo,
    Expression<int>? capacity,
    Expression<String>? status,
    Expression<int>? currentOrderId,
    Expression<int>? displayOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableNo != null) 'table_no': tableNo,
      if (capacity != null) 'capacity': capacity,
      if (status != null) 'status': status,
      if (currentOrderId != null) 'current_order_id': currentOrderId,
      if (displayOrder != null) 'display_order': displayOrder,
    });
  }

  RestaurantTablesCompanion copyWith(
      {Value<int>? id,
      Value<String>? tableNo,
      Value<int>? capacity,
      Value<String>? status,
      Value<int?>? currentOrderId,
      Value<int>? displayOrder}) {
    return RestaurantTablesCompanion(
      id: id ?? this.id,
      tableNo: tableNo ?? this.tableNo,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      currentOrderId: currentOrderId ?? this.currentOrderId,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tableNo.present) {
      map['table_no'] = Variable<String>(tableNo.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (currentOrderId.present) {
      map['current_order_id'] = Variable<int>(currentOrderId.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTablesCompanion(')
          ..write('id: $id, ')
          ..write('tableNo: $tableNo, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('currentOrderId: $currentOrderId, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $MenuItemsTable menuItems = $MenuItemsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $BillsTable bills = $BillsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $DayCloseTable dayClose = $DayCloseTable(this);
  late final $RestaurantTablesTable restaurantTables =
      $RestaurantTablesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        categories,
        menuItems,
        orders,
        orderItems,
        bills,
        settings,
        dayClose,
        restaurantTables
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String name,
  required String role,
  required String pinHash,
  required String salt,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> role,
  Value<String> pinHash,
  Value<String> salt,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
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

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> pinHash = const Value.absent(),
            Value<String> salt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            role: role,
            pinHash: pinHash,
            salt: salt,
            isActive: isActive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String role,
            required String pinHash,
            required String salt,
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            role: role,
            pinHash: pinHash,
            salt: salt,
            isActive: isActive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> displayOrder,
  Value<bool> isActive,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> displayOrder,
  Value<bool> isActive,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
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

  GeneratedColumn<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
    Category,
    PrefetchHooks Function()> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            displayOrder: displayOrder,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> displayOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            displayOrder: displayOrder,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
    Category,
    PrefetchHooks Function()>;
typedef $$MenuItemsTableCreateCompanionBuilder = MenuItemsCompanion Function({
  Value<int> id,
  required int categoryId,
  required String name,
  required double price,
  Value<double> taxRate,
  Value<String?> hsnCode,
  Value<bool> isVeg,
  Value<bool> isActive,
});
typedef $$MenuItemsTableUpdateCompanionBuilder = MenuItemsCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String> name,
  Value<double> price,
  Value<double> taxRate,
  Value<String?> hsnCode,
  Value<bool> isVeg,
  Value<bool> isActive,
});

class $$MenuItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxRate => $composableBuilder(
      column: $table.taxRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hsnCode => $composableBuilder(
      column: $table.hsnCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVeg => $composableBuilder(
      column: $table.isVeg, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$MenuItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxRate => $composableBuilder(
      column: $table.taxRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hsnCode => $composableBuilder(
      column: $table.hsnCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVeg => $composableBuilder(
      column: $table.isVeg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$MenuItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<bool> get isVeg =>
      $composableBuilder(column: $table.isVeg, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$MenuItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MenuItemsTable,
    MenuItem,
    $$MenuItemsTableFilterComposer,
    $$MenuItemsTableOrderingComposer,
    $$MenuItemsTableAnnotationComposer,
    $$MenuItemsTableCreateCompanionBuilder,
    $$MenuItemsTableUpdateCompanionBuilder,
    (MenuItem, BaseReferences<_$AppDatabase, $MenuItemsTable, MenuItem>),
    MenuItem,
    PrefetchHooks Function()> {
  $$MenuItemsTableTableManager(_$AppDatabase db, $MenuItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> taxRate = const Value.absent(),
            Value<String?> hsnCode = const Value.absent(),
            Value<bool> isVeg = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              MenuItemsCompanion(
            id: id,
            categoryId: categoryId,
            name: name,
            price: price,
            taxRate: taxRate,
            hsnCode: hsnCode,
            isVeg: isVeg,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required String name,
            required double price,
            Value<double> taxRate = const Value.absent(),
            Value<String?> hsnCode = const Value.absent(),
            Value<bool> isVeg = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              MenuItemsCompanion.insert(
            id: id,
            categoryId: categoryId,
            name: name,
            price: price,
            taxRate: taxRate,
            hsnCode: hsnCode,
            isVeg: isVeg,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MenuItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MenuItemsTable,
    MenuItem,
    $$MenuItemsTableFilterComposer,
    $$MenuItemsTableOrderingComposer,
    $$MenuItemsTableAnnotationComposer,
    $$MenuItemsTableCreateCompanionBuilder,
    $$MenuItemsTableUpdateCompanionBuilder,
    (MenuItem, BaseReferences<_$AppDatabase, $MenuItemsTable, MenuItem>),
    MenuItem,
    PrefetchHooks Function()>;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<int> tokenNo,
  Value<String> orderType,
  Value<String> tokenStatus,
  required int waiterId,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<int> tokenNo,
  Value<String> orderType,
  Value<String> tokenStatus,
  Value<int> waiterId,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tokenNo => $composableBuilder(
      column: $table.tokenNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tokenStatus => $composableBuilder(
      column: $table.tokenStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get waiterId => $composableBuilder(
      column: $table.waiterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tokenNo => $composableBuilder(
      column: $table.tokenNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tokenStatus => $composableBuilder(
      column: $table.tokenStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get waiterId => $composableBuilder(
      column: $table.waiterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tokenNo =>
      $composableBuilder(column: $table.tokenNo, builder: (column) => column);

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get tokenStatus => $composableBuilder(
      column: $table.tokenStatus, builder: (column) => column);

  GeneratedColumn<int> get waiterId =>
      $composableBuilder(column: $table.waiterId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
    Order,
    PrefetchHooks Function()> {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tokenNo = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<String> tokenStatus = const Value.absent(),
            Value<int> waiterId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              OrdersCompanion(
            id: id,
            tokenNo: tokenNo,
            orderType: orderType,
            tokenStatus: tokenStatus,
            waiterId: waiterId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tokenNo = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<String> tokenStatus = const Value.absent(),
            required int waiterId,
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              OrdersCompanion.insert(
            id: id,
            tokenNo: tokenNo,
            orderType: orderType,
            tokenStatus: tokenStatus,
            waiterId: waiterId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
    Order,
    PrefetchHooks Function()>;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  required int itemId,
  required int quantity,
  required double priceAtOrder,
  Value<double> taxRateAtOrder,
  Value<String?> notes,
  Value<String> status,
  Value<int> kotPrintedQuantity,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> itemId,
  Value<int> quantity,
  Value<double> priceAtOrder,
  Value<double> taxRateAtOrder,
  Value<String?> notes,
  Value<String> status,
  Value<int> kotPrintedQuantity,
});

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get priceAtOrder => $composableBuilder(
      column: $table.priceAtOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxRateAtOrder => $composableBuilder(
      column: $table.taxRateAtOrder,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kotPrintedQuantity => $composableBuilder(
      column: $table.kotPrintedQuantity,
      builder: (column) => ColumnFilters(column));
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get priceAtOrder => $composableBuilder(
      column: $table.priceAtOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxRateAtOrder => $composableBuilder(
      column: $table.taxRateAtOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kotPrintedQuantity => $composableBuilder(
      column: $table.kotPrintedQuantity,
      builder: (column) => ColumnOrderings(column));
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get priceAtOrder => $composableBuilder(
      column: $table.priceAtOrder, builder: (column) => column);

  GeneratedColumn<double> get taxRateAtOrder => $composableBuilder(
      column: $table.taxRateAtOrder, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get kotPrintedQuantity => $composableBuilder(
      column: $table.kotPrintedQuantity, builder: (column) => column);
}

class $$OrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem>),
    OrderItem,
    PrefetchHooks Function()> {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> priceAtOrder = const Value.absent(),
            Value<double> taxRateAtOrder = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> kotPrintedQuantity = const Value.absent(),
          }) =>
              OrderItemsCompanion(
            id: id,
            orderId: orderId,
            itemId: itemId,
            quantity: quantity,
            priceAtOrder: priceAtOrder,
            taxRateAtOrder: taxRateAtOrder,
            notes: notes,
            status: status,
            kotPrintedQuantity: kotPrintedQuantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int itemId,
            required int quantity,
            required double priceAtOrder,
            Value<double> taxRateAtOrder = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> kotPrintedQuantity = const Value.absent(),
          }) =>
              OrderItemsCompanion.insert(
            id: id,
            orderId: orderId,
            itemId: itemId,
            quantity: quantity,
            priceAtOrder: priceAtOrder,
            taxRateAtOrder: taxRateAtOrder,
            notes: notes,
            status: status,
            kotPrintedQuantity: kotPrintedQuantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem>),
    OrderItem,
    PrefetchHooks Function()>;
typedef $$BillsTableCreateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  required int orderId,
  required String billNo,
  required double subtotal,
  Value<double> discount,
  Value<String> discountType,
  required double taxAmount,
  Value<double> cgstAmount,
  Value<double> sgstAmount,
  Value<double> roundOff,
  required double total,
  required String paymentMode,
  Value<bool> isVoid,
  Value<String?> voidReason,
  Value<int?> voidByUserId,
  Value<DateTime> createdAt,
});
typedef $$BillsTableUpdateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<String> billNo,
  Value<double> subtotal,
  Value<double> discount,
  Value<String> discountType,
  Value<double> taxAmount,
  Value<double> cgstAmount,
  Value<double> sgstAmount,
  Value<double> roundOff,
  Value<double> total,
  Value<String> paymentMode,
  Value<bool> isVoid,
  Value<String?> voidReason,
  Value<int?> voidByUserId,
  Value<DateTime> createdAt,
});

class $$BillsTableFilterComposer extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billNo => $composableBuilder(
      column: $table.billNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get discountType => $composableBuilder(
      column: $table.discountType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cgstAmount => $composableBuilder(
      column: $table.cgstAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sgstAmount => $composableBuilder(
      column: $table.sgstAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get roundOff => $composableBuilder(
      column: $table.roundOff, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVoid => $composableBuilder(
      column: $table.isVoid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voidReason => $composableBuilder(
      column: $table.voidReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get voidByUserId => $composableBuilder(
      column: $table.voidByUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BillsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billNo => $composableBuilder(
      column: $table.billNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get discountType => $composableBuilder(
      column: $table.discountType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cgstAmount => $composableBuilder(
      column: $table.cgstAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sgstAmount => $composableBuilder(
      column: $table.sgstAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get roundOff => $composableBuilder(
      column: $table.roundOff, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVoid => $composableBuilder(
      column: $table.isVoid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voidReason => $composableBuilder(
      column: $table.voidReason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get voidByUserId => $composableBuilder(
      column: $table.voidByUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get billNo =>
      $composableBuilder(column: $table.billNo, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<String> get discountType => $composableBuilder(
      column: $table.discountType, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get cgstAmount => $composableBuilder(
      column: $table.cgstAmount, builder: (column) => column);

  GeneratedColumn<double> get sgstAmount => $composableBuilder(
      column: $table.sgstAmount, builder: (column) => column);

  GeneratedColumn<double> get roundOff =>
      $composableBuilder(column: $table.roundOff, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => column);

  GeneratedColumn<bool> get isVoid =>
      $composableBuilder(column: $table.isVoid, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
      column: $table.voidReason, builder: (column) => column);

  GeneratedColumn<int> get voidByUserId => $composableBuilder(
      column: $table.voidByUserId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillsTable,
    Bill,
    $$BillsTableFilterComposer,
    $$BillsTableOrderingComposer,
    $$BillsTableAnnotationComposer,
    $$BillsTableCreateCompanionBuilder,
    $$BillsTableUpdateCompanionBuilder,
    (Bill, BaseReferences<_$AppDatabase, $BillsTable, Bill>),
    Bill,
    PrefetchHooks Function()> {
  $$BillsTableTableManager(_$AppDatabase db, $BillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<String> billNo = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<String> discountType = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> cgstAmount = const Value.absent(),
            Value<double> sgstAmount = const Value.absent(),
            Value<double> roundOff = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<bool> isVoid = const Value.absent(),
            Value<String?> voidReason = const Value.absent(),
            Value<int?> voidByUserId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BillsCompanion(
            id: id,
            orderId: orderId,
            billNo: billNo,
            subtotal: subtotal,
            discount: discount,
            discountType: discountType,
            taxAmount: taxAmount,
            cgstAmount: cgstAmount,
            sgstAmount: sgstAmount,
            roundOff: roundOff,
            total: total,
            paymentMode: paymentMode,
            isVoid: isVoid,
            voidReason: voidReason,
            voidByUserId: voidByUserId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required String billNo,
            required double subtotal,
            Value<double> discount = const Value.absent(),
            Value<String> discountType = const Value.absent(),
            required double taxAmount,
            Value<double> cgstAmount = const Value.absent(),
            Value<double> sgstAmount = const Value.absent(),
            Value<double> roundOff = const Value.absent(),
            required double total,
            required String paymentMode,
            Value<bool> isVoid = const Value.absent(),
            Value<String?> voidReason = const Value.absent(),
            Value<int?> voidByUserId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BillsCompanion.insert(
            id: id,
            orderId: orderId,
            billNo: billNo,
            subtotal: subtotal,
            discount: discount,
            discountType: discountType,
            taxAmount: taxAmount,
            cgstAmount: cgstAmount,
            sgstAmount: sgstAmount,
            roundOff: roundOff,
            total: total,
            paymentMode: paymentMode,
            isVoid: isVoid,
            voidReason: voidReason,
            voidByUserId: voidByUserId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillsTable,
    Bill,
    $$BillsTableFilterComposer,
    $$BillsTableOrderingComposer,
    $$BillsTableAnnotationComposer,
    $$BillsTableCreateCompanionBuilder,
    $$BillsTableUpdateCompanionBuilder,
    (Bill, BaseReferences<_$AppDatabase, $BillsTable, Bill>),
    Bill,
    PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;
typedef $$DayCloseTableCreateCompanionBuilder = DayCloseCompanion Function({
  Value<int> id,
  required DateTime date,
  required double openingCash,
  required double closingCash,
  required double totalSales,
  required int totalOrders,
  required double discrepancy,
  Value<String?> closedByUserId,
  Value<DateTime> createdAt,
});
typedef $$DayCloseTableUpdateCompanionBuilder = DayCloseCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<double> openingCash,
  Value<double> closingCash,
  Value<double> totalSales,
  Value<int> totalOrders,
  Value<double> discrepancy,
  Value<String?> closedByUserId,
  Value<DateTime> createdAt,
});

class $$DayCloseTableFilterComposer
    extends Composer<_$AppDatabase, $DayCloseTable> {
  $$DayCloseTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openingCash => $composableBuilder(
      column: $table.openingCash, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get closingCash => $composableBuilder(
      column: $table.closingCash, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalSales => $composableBuilder(
      column: $table.totalSales, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalOrders => $composableBuilder(
      column: $table.totalOrders, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discrepancy => $composableBuilder(
      column: $table.discrepancy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closedByUserId => $composableBuilder(
      column: $table.closedByUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DayCloseTableOrderingComposer
    extends Composer<_$AppDatabase, $DayCloseTable> {
  $$DayCloseTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openingCash => $composableBuilder(
      column: $table.openingCash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get closingCash => $composableBuilder(
      column: $table.closingCash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalSales => $composableBuilder(
      column: $table.totalSales, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalOrders => $composableBuilder(
      column: $table.totalOrders, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discrepancy => $composableBuilder(
      column: $table.discrepancy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closedByUserId => $composableBuilder(
      column: $table.closedByUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DayCloseTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayCloseTable> {
  $$DayCloseTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get openingCash => $composableBuilder(
      column: $table.openingCash, builder: (column) => column);

  GeneratedColumn<double> get closingCash => $composableBuilder(
      column: $table.closingCash, builder: (column) => column);

  GeneratedColumn<double> get totalSales => $composableBuilder(
      column: $table.totalSales, builder: (column) => column);

  GeneratedColumn<int> get totalOrders => $composableBuilder(
      column: $table.totalOrders, builder: (column) => column);

  GeneratedColumn<double> get discrepancy => $composableBuilder(
      column: $table.discrepancy, builder: (column) => column);

  GeneratedColumn<String> get closedByUserId => $composableBuilder(
      column: $table.closedByUserId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DayCloseTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DayCloseTable,
    DayCloseData,
    $$DayCloseTableFilterComposer,
    $$DayCloseTableOrderingComposer,
    $$DayCloseTableAnnotationComposer,
    $$DayCloseTableCreateCompanionBuilder,
    $$DayCloseTableUpdateCompanionBuilder,
    (DayCloseData, BaseReferences<_$AppDatabase, $DayCloseTable, DayCloseData>),
    DayCloseData,
    PrefetchHooks Function()> {
  $$DayCloseTableTableManager(_$AppDatabase db, $DayCloseTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayCloseTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayCloseTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayCloseTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> openingCash = const Value.absent(),
            Value<double> closingCash = const Value.absent(),
            Value<double> totalSales = const Value.absent(),
            Value<int> totalOrders = const Value.absent(),
            Value<double> discrepancy = const Value.absent(),
            Value<String?> closedByUserId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DayCloseCompanion(
            id: id,
            date: date,
            openingCash: openingCash,
            closingCash: closingCash,
            totalSales: totalSales,
            totalOrders: totalOrders,
            discrepancy: discrepancy,
            closedByUserId: closedByUserId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required double openingCash,
            required double closingCash,
            required double totalSales,
            required int totalOrders,
            required double discrepancy,
            Value<String?> closedByUserId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DayCloseCompanion.insert(
            id: id,
            date: date,
            openingCash: openingCash,
            closingCash: closingCash,
            totalSales: totalSales,
            totalOrders: totalOrders,
            discrepancy: discrepancy,
            closedByUserId: closedByUserId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DayCloseTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DayCloseTable,
    DayCloseData,
    $$DayCloseTableFilterComposer,
    $$DayCloseTableOrderingComposer,
    $$DayCloseTableAnnotationComposer,
    $$DayCloseTableCreateCompanionBuilder,
    $$DayCloseTableUpdateCompanionBuilder,
    (DayCloseData, BaseReferences<_$AppDatabase, $DayCloseTable, DayCloseData>),
    DayCloseData,
    PrefetchHooks Function()>;
typedef $$RestaurantTablesTableCreateCompanionBuilder
    = RestaurantTablesCompanion Function({
  Value<int> id,
  required String tableNo,
  Value<int> capacity,
  Value<String> status,
  Value<int?> currentOrderId,
  Value<int> displayOrder,
});
typedef $$RestaurantTablesTableUpdateCompanionBuilder
    = RestaurantTablesCompanion Function({
  Value<int> id,
  Value<String> tableNo,
  Value<int> capacity,
  Value<String> status,
  Value<int?> currentOrderId,
  Value<int> displayOrder,
});

class $$RestaurantTablesTableFilterComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableNo => $composableBuilder(
      column: $table.tableNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentOrderId => $composableBuilder(
      column: $table.currentOrderId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => ColumnFilters(column));
}

class $$RestaurantTablesTableOrderingComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableNo => $composableBuilder(
      column: $table.tableNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentOrderId => $composableBuilder(
      column: $table.currentOrderId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder,
      builder: (column) => ColumnOrderings(column));
}

class $$RestaurantTablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tableNo =>
      $composableBuilder(column: $table.tableNo, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get currentOrderId => $composableBuilder(
      column: $table.currentOrderId, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => column);
}

class $$RestaurantTablesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RestaurantTablesTable,
    RestaurantTable,
    $$RestaurantTablesTableFilterComposer,
    $$RestaurantTablesTableOrderingComposer,
    $$RestaurantTablesTableAnnotationComposer,
    $$RestaurantTablesTableCreateCompanionBuilder,
    $$RestaurantTablesTableUpdateCompanionBuilder,
    (
      RestaurantTable,
      BaseReferences<_$AppDatabase, $RestaurantTablesTable, RestaurantTable>
    ),
    RestaurantTable,
    PrefetchHooks Function()> {
  $$RestaurantTablesTableTableManager(
      _$AppDatabase db, $RestaurantTablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestaurantTablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestaurantTablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestaurantTablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> tableNo = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> currentOrderId = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
          }) =>
              RestaurantTablesCompanion(
            id: id,
            tableNo: tableNo,
            capacity: capacity,
            status: status,
            currentOrderId: currentOrderId,
            displayOrder: displayOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String tableNo,
            Value<int> capacity = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> currentOrderId = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
          }) =>
              RestaurantTablesCompanion.insert(
            id: id,
            tableNo: tableNo,
            capacity: capacity,
            status: status,
            currentOrderId: currentOrderId,
            displayOrder: displayOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RestaurantTablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RestaurantTablesTable,
    RestaurantTable,
    $$RestaurantTablesTableFilterComposer,
    $$RestaurantTablesTableOrderingComposer,
    $$RestaurantTablesTableAnnotationComposer,
    $$RestaurantTablesTableCreateCompanionBuilder,
    $$RestaurantTablesTableUpdateCompanionBuilder,
    (
      RestaurantTable,
      BaseReferences<_$AppDatabase, $RestaurantTablesTable, RestaurantTable>
    ),
    RestaurantTable,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$MenuItemsTableTableManager get menuItems =>
      $$MenuItemsTableTableManager(_db, _db.menuItems);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db, _db.bills);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$DayCloseTableTableManager get dayClose =>
      $$DayCloseTableTableManager(_db, _db.dayClose);
  $$RestaurantTablesTableTableManager get restaurantTables =>
      $$RestaurantTablesTableTableManager(_db, _db.restaurantTables);
}
