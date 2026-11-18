// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, Producto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _porcentajeivaMeta = const VerificationMeta(
    'porcentajeiva',
  );
  @override
  late final GeneratedColumn<int> porcentajeiva = GeneratedColumn<int>(
    'porcentajeiva',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, cantidad, porcentajeiva];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Producto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('porcentajeiva')) {
      context.handle(
        _porcentajeivaMeta,
        porcentajeiva.isAcceptableOrUnknown(
          data['porcentajeiva']!,
          _porcentajeivaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_porcentajeivaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Producto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Producto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      porcentajeiva: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}porcentajeiva'],
      )!,
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class Producto extends DataClass implements Insertable<Producto> {
  final int id;
  final String nombre;
  final int cantidad;
  final int porcentajeiva;
  const Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.porcentajeiva,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['cantidad'] = Variable<int>(cantidad);
    map['porcentajeiva'] = Variable<int>(porcentajeiva);
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      cantidad: Value(cantidad),
      porcentajeiva: Value(porcentajeiva),
    );
  }

  factory Producto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Producto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      porcentajeiva: serializer.fromJson<int>(json['porcentajeiva']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'cantidad': serializer.toJson<int>(cantidad),
      'porcentajeiva': serializer.toJson<int>(porcentajeiva),
    };
  }

  Producto copyWith({
    int? id,
    String? nombre,
    int? cantidad,
    int? porcentajeiva,
  }) => Producto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    cantidad: cantidad ?? this.cantidad,
    porcentajeiva: porcentajeiva ?? this.porcentajeiva,
  );
  Producto copyWithCompanion(ProductosCompanion data) {
    return Producto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      porcentajeiva: data.porcentajeiva.present
          ? data.porcentajeiva.value
          : this.porcentajeiva,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Producto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('porcentajeiva: $porcentajeiva')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, cantidad, porcentajeiva);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Producto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.cantidad == this.cantidad &&
          other.porcentajeiva == this.porcentajeiva);
}

class ProductosCompanion extends UpdateCompanion<Producto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> cantidad;
  final Value<int> porcentajeiva;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.porcentajeiva = const Value.absent(),
  });
  ProductosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int cantidad,
    required int porcentajeiva,
  }) : nombre = Value(nombre),
       cantidad = Value(cantidad),
       porcentajeiva = Value(porcentajeiva);
  static Insertable<Producto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? cantidad,
    Expression<int>? porcentajeiva,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (cantidad != null) 'cantidad': cantidad,
      if (porcentajeiva != null) 'porcentajeiva': porcentajeiva,
    });
  }

  ProductosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<int>? cantidad,
    Value<int>? porcentajeiva,
  }) {
    return ProductosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      porcentajeiva: porcentajeiva ?? this.porcentajeiva,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (porcentajeiva.present) {
      map['porcentajeiva'] = Variable<int>(porcentajeiva.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('porcentajeiva: $porcentajeiva')
          ..write(')'))
        .toString();
  }
}

class $CategoriasClienteTable extends CategoriasCliente
    with TableInfo<$CategoriasClienteTable, CategoriaCliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasClienteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias_cliente';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriaCliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriaCliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriaCliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $CategoriasClienteTable createAlias(String alias) {
    return $CategoriasClienteTable(attachedDatabase, alias);
  }
}

class CategoriaCliente extends DataClass
    implements Insertable<CategoriaCliente> {
  final int id;
  final String nombre;
  const CategoriaCliente({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  CategoriasClienteCompanion toCompanion(bool nullToAbsent) {
    return CategoriasClienteCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory CategoriaCliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriaCliente(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  CategoriaCliente copyWith({int? id, String? nombre}) =>
      CategoriaCliente(id: id ?? this.id, nombre: nombre ?? this.nombre);
  CategoriaCliente copyWithCompanion(CategoriasClienteCompanion data) {
    return CategoriaCliente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriaCliente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriaCliente &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class CategoriasClienteCompanion extends UpdateCompanion<CategoriaCliente> {
  final Value<int> id;
  final Value<String> nombre;
  const CategoriasClienteCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  CategoriasClienteCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<CategoriaCliente> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  CategoriasClienteCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return CategoriasClienteCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasClienteCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $TiposDocumentoTable extends TiposDocumento
    with TableInfo<$TiposDocumentoTable, TipoDocumento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TiposDocumentoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tipos_documento';
  @override
  VerificationContext validateIntegrity(
    Insertable<TipoDocumento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TipoDocumento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TipoDocumento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $TiposDocumentoTable createAlias(String alias) {
    return $TiposDocumentoTable(attachedDatabase, alias);
  }
}

class TipoDocumento extends DataClass implements Insertable<TipoDocumento> {
  final int id;
  final String nombre;
  const TipoDocumento({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  TiposDocumentoCompanion toCompanion(bool nullToAbsent) {
    return TiposDocumentoCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory TipoDocumento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TipoDocumento(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  TipoDocumento copyWith({int? id, String? nombre}) =>
      TipoDocumento(id: id ?? this.id, nombre: nombre ?? this.nombre);
  TipoDocumento copyWithCompanion(TiposDocumentoCompanion data) {
    return TipoDocumento(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TipoDocumento(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TipoDocumento &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class TiposDocumentoCompanion extends UpdateCompanion<TipoDocumento> {
  final Value<int> id;
  final Value<String> nombre;
  const TiposDocumentoCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  TiposDocumentoCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<TipoDocumento> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  TiposDocumentoCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return TiposDocumentoCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TiposDocumentoCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $FormasPagoTable extends FormasPago
    with TableInfo<$FormasPagoTable, FormaPago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormasPagoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idformapagoMeta = const VerificationMeta(
    'idformapago',
  );
  @override
  late final GeneratedColumn<int> idformapago = GeneratedColumn<int>(
    'idformapago',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreformapagoMeta = const VerificationMeta(
    'nombreformapago',
  );
  @override
  late final GeneratedColumn<String> nombreformapago = GeneratedColumn<String>(
    'nombreformapago',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [idformapago, nombreformapago];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forma_pago';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormaPago> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('idformapago')) {
      context.handle(
        _idformapagoMeta,
        idformapago.isAcceptableOrUnknown(
          data['idformapago']!,
          _idformapagoMeta,
        ),
      );
    }
    if (data.containsKey('nombreformapago')) {
      context.handle(
        _nombreformapagoMeta,
        nombreformapago.isAcceptableOrUnknown(
          data['nombreformapago']!,
          _nombreformapagoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreformapagoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idformapago};
  @override
  FormaPago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormaPago(
      idformapago: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idformapago'],
      )!,
      nombreformapago: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombreformapago'],
      )!,
    );
  }

  @override
  $FormasPagoTable createAlias(String alias) {
    return $FormasPagoTable(attachedDatabase, alias);
  }
}

class FormaPago extends DataClass implements Insertable<FormaPago> {
  final int idformapago;
  final String nombreformapago;
  const FormaPago({required this.idformapago, required this.nombreformapago});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['idformapago'] = Variable<int>(idformapago);
    map['nombreformapago'] = Variable<String>(nombreformapago);
    return map;
  }

  FormasPagoCompanion toCompanion(bool nullToAbsent) {
    return FormasPagoCompanion(
      idformapago: Value(idformapago),
      nombreformapago: Value(nombreformapago),
    );
  }

  factory FormaPago.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormaPago(
      idformapago: serializer.fromJson<int>(json['idformapago']),
      nombreformapago: serializer.fromJson<String>(json['nombreformapago']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idformapago': serializer.toJson<int>(idformapago),
      'nombreformapago': serializer.toJson<String>(nombreformapago),
    };
  }

  FormaPago copyWith({int? idformapago, String? nombreformapago}) => FormaPago(
    idformapago: idformapago ?? this.idformapago,
    nombreformapago: nombreformapago ?? this.nombreformapago,
  );
  FormaPago copyWithCompanion(FormasPagoCompanion data) {
    return FormaPago(
      idformapago: data.idformapago.present
          ? data.idformapago.value
          : this.idformapago,
      nombreformapago: data.nombreformapago.present
          ? data.nombreformapago.value
          : this.nombreformapago,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormaPago(')
          ..write('idformapago: $idformapago, ')
          ..write('nombreformapago: $nombreformapago')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idformapago, nombreformapago);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormaPago &&
          other.idformapago == this.idformapago &&
          other.nombreformapago == this.nombreformapago);
}

class FormasPagoCompanion extends UpdateCompanion<FormaPago> {
  final Value<int> idformapago;
  final Value<String> nombreformapago;
  const FormasPagoCompanion({
    this.idformapago = const Value.absent(),
    this.nombreformapago = const Value.absent(),
  });
  FormasPagoCompanion.insert({
    this.idformapago = const Value.absent(),
    required String nombreformapago,
  }) : nombreformapago = Value(nombreformapago);
  static Insertable<FormaPago> custom({
    Expression<int>? idformapago,
    Expression<String>? nombreformapago,
  }) {
    return RawValuesInsertable({
      if (idformapago != null) 'idformapago': idformapago,
      if (nombreformapago != null) 'nombreformapago': nombreformapago,
    });
  }

  FormasPagoCompanion copyWith({
    Value<int>? idformapago,
    Value<String>? nombreformapago,
  }) {
    return FormasPagoCompanion(
      idformapago: idformapago ?? this.idformapago,
      nombreformapago: nombreformapago ?? this.nombreformapago,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idformapago.present) {
      map['idformapago'] = Variable<int>(idformapago.value);
    }
    if (nombreformapago.present) {
      map['nombreformapago'] = Variable<String>(nombreformapago.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormasPagoCompanion(')
          ..write('idformapago: $idformapago, ')
          ..write('nombreformapago: $nombreformapago')
          ..write(')'))
        .toString();
  }
}

class $RutasTable extends Rutas with TableInfo<$RutasTable, Ruta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RutasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idRutaMeta = const VerificationMeta('idRuta');
  @override
  late final GeneratedColumn<int> idRuta = GeneratedColumn<int>(
    'id_ruta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idZonaMeta = const VerificationMeta('idZona');
  @override
  late final GeneratedColumn<int> idZona = GeneratedColumn<int>(
    'id_zona',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombrezonaMeta = const VerificationMeta(
    'nombrezona',
  );
  @override
  late final GeneratedColumn<String> nombrezona = GeneratedColumn<String>(
    'nombrezona',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<bool> estado = GeneratedColumn<bool>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("estado" IN (0, 1))',
    ),
  );
  static const VerificationMeta _nombreEstadoMeta = const VerificationMeta(
    'nombreEstado',
  );
  @override
  late final GeneratedColumn<String> nombreEstado = GeneratedColumn<String>(
    'nombre_estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idRuta,
    nombre,
    idZona,
    nombrezona,
    estado,
    nombreEstado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rutas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ruta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_ruta')) {
      context.handle(
        _idRutaMeta,
        idRuta.isAcceptableOrUnknown(data['id_ruta']!, _idRutaMeta),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('id_zona')) {
      context.handle(
        _idZonaMeta,
        idZona.isAcceptableOrUnknown(data['id_zona']!, _idZonaMeta),
      );
    } else if (isInserting) {
      context.missing(_idZonaMeta);
    }
    if (data.containsKey('nombrezona')) {
      context.handle(
        _nombrezonaMeta,
        nombrezona.isAcceptableOrUnknown(data['nombrezona']!, _nombrezonaMeta),
      );
    } else if (isInserting) {
      context.missing(_nombrezonaMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('nombre_estado')) {
      context.handle(
        _nombreEstadoMeta,
        nombreEstado.isAcceptableOrUnknown(
          data['nombre_estado']!,
          _nombreEstadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreEstadoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idRuta};
  @override
  Ruta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ruta(
      idRuta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_ruta'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      idZona: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_zona'],
      )!,
      nombrezona: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombrezona'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}estado'],
      )!,
      nombreEstado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_estado'],
      )!,
    );
  }

  @override
  $RutasTable createAlias(String alias) {
    return $RutasTable(attachedDatabase, alias);
  }
}

class Ruta extends DataClass implements Insertable<Ruta> {
  final int idRuta;
  final String nombre;
  final int idZona;
  final String nombrezona;
  final bool estado;
  final String nombreEstado;
  const Ruta({
    required this.idRuta,
    required this.nombre,
    required this.idZona,
    required this.nombrezona,
    required this.estado,
    required this.nombreEstado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_ruta'] = Variable<int>(idRuta);
    map['nombre'] = Variable<String>(nombre);
    map['id_zona'] = Variable<int>(idZona);
    map['nombrezona'] = Variable<String>(nombrezona);
    map['estado'] = Variable<bool>(estado);
    map['nombre_estado'] = Variable<String>(nombreEstado);
    return map;
  }

  RutasCompanion toCompanion(bool nullToAbsent) {
    return RutasCompanion(
      idRuta: Value(idRuta),
      nombre: Value(nombre),
      idZona: Value(idZona),
      nombrezona: Value(nombrezona),
      estado: Value(estado),
      nombreEstado: Value(nombreEstado),
    );
  }

  factory Ruta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ruta(
      idRuta: serializer.fromJson<int>(json['idRuta']),
      nombre: serializer.fromJson<String>(json['nombre']),
      idZona: serializer.fromJson<int>(json['idZona']),
      nombrezona: serializer.fromJson<String>(json['nombrezona']),
      estado: serializer.fromJson<bool>(json['estado']),
      nombreEstado: serializer.fromJson<String>(json['nombreEstado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idRuta': serializer.toJson<int>(idRuta),
      'nombre': serializer.toJson<String>(nombre),
      'idZona': serializer.toJson<int>(idZona),
      'nombrezona': serializer.toJson<String>(nombrezona),
      'estado': serializer.toJson<bool>(estado),
      'nombreEstado': serializer.toJson<String>(nombreEstado),
    };
  }

  Ruta copyWith({
    int? idRuta,
    String? nombre,
    int? idZona,
    String? nombrezona,
    bool? estado,
    String? nombreEstado,
  }) => Ruta(
    idRuta: idRuta ?? this.idRuta,
    nombre: nombre ?? this.nombre,
    idZona: idZona ?? this.idZona,
    nombrezona: nombrezona ?? this.nombrezona,
    estado: estado ?? this.estado,
    nombreEstado: nombreEstado ?? this.nombreEstado,
  );
  Ruta copyWithCompanion(RutasCompanion data) {
    return Ruta(
      idRuta: data.idRuta.present ? data.idRuta.value : this.idRuta,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      idZona: data.idZona.present ? data.idZona.value : this.idZona,
      nombrezona: data.nombrezona.present
          ? data.nombrezona.value
          : this.nombrezona,
      estado: data.estado.present ? data.estado.value : this.estado,
      nombreEstado: data.nombreEstado.present
          ? data.nombreEstado.value
          : this.nombreEstado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ruta(')
          ..write('idRuta: $idRuta, ')
          ..write('nombre: $nombre, ')
          ..write('idZona: $idZona, ')
          ..write('nombrezona: $nombrezona, ')
          ..write('estado: $estado, ')
          ..write('nombreEstado: $nombreEstado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idRuta, nombre, idZona, nombrezona, estado, nombreEstado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ruta &&
          other.idRuta == this.idRuta &&
          other.nombre == this.nombre &&
          other.idZona == this.idZona &&
          other.nombrezona == this.nombrezona &&
          other.estado == this.estado &&
          other.nombreEstado == this.nombreEstado);
}

class RutasCompanion extends UpdateCompanion<Ruta> {
  final Value<int> idRuta;
  final Value<String> nombre;
  final Value<int> idZona;
  final Value<String> nombrezona;
  final Value<bool> estado;
  final Value<String> nombreEstado;
  const RutasCompanion({
    this.idRuta = const Value.absent(),
    this.nombre = const Value.absent(),
    this.idZona = const Value.absent(),
    this.nombrezona = const Value.absent(),
    this.estado = const Value.absent(),
    this.nombreEstado = const Value.absent(),
  });
  RutasCompanion.insert({
    this.idRuta = const Value.absent(),
    required String nombre,
    required int idZona,
    required String nombrezona,
    required bool estado,
    required String nombreEstado,
  }) : nombre = Value(nombre),
       idZona = Value(idZona),
       nombrezona = Value(nombrezona),
       estado = Value(estado),
       nombreEstado = Value(nombreEstado);
  static Insertable<Ruta> custom({
    Expression<int>? idRuta,
    Expression<String>? nombre,
    Expression<int>? idZona,
    Expression<String>? nombrezona,
    Expression<bool>? estado,
    Expression<String>? nombreEstado,
  }) {
    return RawValuesInsertable({
      if (idRuta != null) 'id_ruta': idRuta,
      if (nombre != null) 'nombre': nombre,
      if (idZona != null) 'id_zona': idZona,
      if (nombrezona != null) 'nombrezona': nombrezona,
      if (estado != null) 'estado': estado,
      if (nombreEstado != null) 'nombre_estado': nombreEstado,
    });
  }

  RutasCompanion copyWith({
    Value<int>? idRuta,
    Value<String>? nombre,
    Value<int>? idZona,
    Value<String>? nombrezona,
    Value<bool>? estado,
    Value<String>? nombreEstado,
  }) {
    return RutasCompanion(
      idRuta: idRuta ?? this.idRuta,
      nombre: nombre ?? this.nombre,
      idZona: idZona ?? this.idZona,
      nombrezona: nombrezona ?? this.nombrezona,
      estado: estado ?? this.estado,
      nombreEstado: nombreEstado ?? this.nombreEstado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idRuta.present) {
      map['id_ruta'] = Variable<int>(idRuta.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (idZona.present) {
      map['id_zona'] = Variable<int>(idZona.value);
    }
    if (nombrezona.present) {
      map['nombrezona'] = Variable<String>(nombrezona.value);
    }
    if (estado.present) {
      map['estado'] = Variable<bool>(estado.value);
    }
    if (nombreEstado.present) {
      map['nombre_estado'] = Variable<String>(nombreEstado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RutasCompanion(')
          ..write('idRuta: $idRuta, ')
          ..write('nombre: $nombre, ')
          ..write('idZona: $idZona, ')
          ..write('nombrezona: $nombrezona, ')
          ..write('estado: $estado, ')
          ..write('nombreEstado: $nombreEstado')
          ..write(')'))
        .toString();
  }
}

class $CiudadesTable extends Ciudades with TableInfo<$CiudadesTable, Ciudad> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CiudadesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ciudades';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ciudad> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ciudad map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ciudad(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $CiudadesTable createAlias(String alias) {
    return $CiudadesTable(attachedDatabase, alias);
  }
}

class Ciudad extends DataClass implements Insertable<Ciudad> {
  final int id;
  final String nombre;
  const Ciudad({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  CiudadesCompanion toCompanion(bool nullToAbsent) {
    return CiudadesCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory Ciudad.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ciudad(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  Ciudad copyWith({int? id, String? nombre}) =>
      Ciudad(id: id ?? this.id, nombre: nombre ?? this.nombre);
  Ciudad copyWithCompanion(CiudadesCompanion data) {
    return Ciudad(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ciudad(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ciudad && other.id == this.id && other.nombre == this.nombre);
}

class CiudadesCompanion extends UpdateCompanion<Ciudad> {
  final Value<int> id;
  final Value<String> nombre;
  const CiudadesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  CiudadesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<Ciudad> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  CiudadesCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return CiudadesCompanion(id: id ?? this.id, nombre: nombre ?? this.nombre);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CiudadesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoDocumentoIdMeta = const VerificationMeta(
    'tipoDocumentoId',
  );
  @override
  late final GeneratedColumn<int> tipoDocumentoId = GeneratedColumn<int>(
    'tipo_documento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tipos_documento (id)',
    ),
  );
  static const VerificationMeta _documentoMeta = const VerificationMeta(
    'documento',
  );
  @override
  late final GeneratedColumn<String> documento = GeneratedColumn<String>(
    'documento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreEstablecimientoMeta =
      const VerificationMeta('nombreEstablecimiento');
  @override
  late final GeneratedColumn<String> nombreEstablecimiento =
      GeneratedColumn<String>(
        'nombre_establecimiento',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _administradorMeta = const VerificationMeta(
    'administrador',
  );
  @override
  late final GeneratedColumn<String> administrador = GeneratedColumn<String>(
    'administrador',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barrioMeta = const VerificationMeta('barrio');
  @override
  late final GeneratedColumn<String> barrio = GeneratedColumn<String>(
    'barrio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpsLatMeta = const VerificationMeta('gpsLat');
  @override
  late final GeneratedColumn<double> gpsLat = GeneratedColumn<double>(
    'gps_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpsLngMeta = const VerificationMeta('gpsLng');
  @override
  late final GeneratedColumn<double> gpsLng = GeneratedColumn<double>(
    'gps_lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consecutivoEntregaMeta =
      const VerificationMeta('consecutivoEntrega');
  @override
  late final GeneratedColumn<int> consecutivoEntrega = GeneratedColumn<int>(
    'consecutivo_entrega',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ivaDiscriminaMeta = const VerificationMeta(
    'ivaDiscrimina',
  );
  @override
  late final GeneratedColumn<bool> ivaDiscrimina = GeneratedColumn<bool>(
    'iva_discrimina',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("iva_discrimina" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pagoCreditoMeta = const VerificationMeta(
    'pagoCredito',
  );
  @override
  late final GeneratedColumn<bool> pagoCredito = GeneratedColumn<bool>(
    'pago_credito',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pago_credito" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cupoMeta = const VerificationMeta('cupo');
  @override
  late final GeneratedColumn<double> cupo = GeneratedColumn<double>(
    'cupo',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plazoMeta = const VerificationMeta('plazo');
  @override
  late final GeneratedColumn<int> plazo = GeneratedColumn<int>(
    'plazo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _categoriaClienteIdMeta =
      const VerificationMeta('categoriaClienteId');
  @override
  late final GeneratedColumn<int> categoriaClienteId = GeneratedColumn<int>(
    'categoria_cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias_cliente (id)',
    ),
  );
  static const VerificationMeta _rutaIdMeta = const VerificationMeta('rutaId');
  @override
  late final GeneratedColumn<int> rutaId = GeneratedColumn<int>(
    'ruta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ciudadIdMeta = const VerificationMeta(
    'ciudadId',
  );
  @override
  late final GeneratedColumn<int> ciudadId = GeneratedColumn<int>(
    'ciudad_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ciudades (id)',
    ),
  );
  static const VerificationMeta _horarioDesdeMeta = const VerificationMeta(
    'horarioDesde',
  );
  @override
  late final GeneratedColumn<String> horarioDesde = GeneratedColumn<String>(
    'horario_desde',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _horarioHastaMeta = const VerificationMeta(
    'horarioHasta',
  );
  @override
  late final GeneratedColumn<String> horarioHasta = GeneratedColumn<String>(
    'horario_hasta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipoDocumentoId,
    documento,
    nombreEstablecimiento,
    direccion,
    telefono,
    email,
    administrador,
    barrio,
    gpsLat,
    gpsLng,
    consecutivoEntrega,
    ivaDiscrimina,
    pagoCredito,
    cupo,
    plazo,
    activo,
    categoriaClienteId,
    rutaId,
    ciudadId,
    horarioDesde,
    horarioHasta,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo_documento_id')) {
      context.handle(
        _tipoDocumentoIdMeta,
        tipoDocumentoId.isAcceptableOrUnknown(
          data['tipo_documento_id']!,
          _tipoDocumentoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoDocumentoIdMeta);
    }
    if (data.containsKey('documento')) {
      context.handle(
        _documentoMeta,
        documento.isAcceptableOrUnknown(data['documento']!, _documentoMeta),
      );
    } else if (isInserting) {
      context.missing(_documentoMeta);
    }
    if (data.containsKey('nombre_establecimiento')) {
      context.handle(
        _nombreEstablecimientoMeta,
        nombreEstablecimiento.isAcceptableOrUnknown(
          data['nombre_establecimiento']!,
          _nombreEstablecimientoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreEstablecimientoMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('administrador')) {
      context.handle(
        _administradorMeta,
        administrador.isAcceptableOrUnknown(
          data['administrador']!,
          _administradorMeta,
        ),
      );
    }
    if (data.containsKey('barrio')) {
      context.handle(
        _barrioMeta,
        barrio.isAcceptableOrUnknown(data['barrio']!, _barrioMeta),
      );
    }
    if (data.containsKey('gps_lat')) {
      context.handle(
        _gpsLatMeta,
        gpsLat.isAcceptableOrUnknown(data['gps_lat']!, _gpsLatMeta),
      );
    }
    if (data.containsKey('gps_lng')) {
      context.handle(
        _gpsLngMeta,
        gpsLng.isAcceptableOrUnknown(data['gps_lng']!, _gpsLngMeta),
      );
    }
    if (data.containsKey('consecutivo_entrega')) {
      context.handle(
        _consecutivoEntregaMeta,
        consecutivoEntrega.isAcceptableOrUnknown(
          data['consecutivo_entrega']!,
          _consecutivoEntregaMeta,
        ),
      );
    }
    if (data.containsKey('iva_discrimina')) {
      context.handle(
        _ivaDiscriminaMeta,
        ivaDiscrimina.isAcceptableOrUnknown(
          data['iva_discrimina']!,
          _ivaDiscriminaMeta,
        ),
      );
    }
    if (data.containsKey('pago_credito')) {
      context.handle(
        _pagoCreditoMeta,
        pagoCredito.isAcceptableOrUnknown(
          data['pago_credito']!,
          _pagoCreditoMeta,
        ),
      );
    }
    if (data.containsKey('cupo')) {
      context.handle(
        _cupoMeta,
        cupo.isAcceptableOrUnknown(data['cupo']!, _cupoMeta),
      );
    }
    if (data.containsKey('plazo')) {
      context.handle(
        _plazoMeta,
        plazo.isAcceptableOrUnknown(data['plazo']!, _plazoMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('categoria_cliente_id')) {
      context.handle(
        _categoriaClienteIdMeta,
        categoriaClienteId.isAcceptableOrUnknown(
          data['categoria_cliente_id']!,
          _categoriaClienteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaClienteIdMeta);
    }
    if (data.containsKey('ruta_id')) {
      context.handle(
        _rutaIdMeta,
        rutaId.isAcceptableOrUnknown(data['ruta_id']!, _rutaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rutaIdMeta);
    }
    if (data.containsKey('ciudad_id')) {
      context.handle(
        _ciudadIdMeta,
        ciudadId.isAcceptableOrUnknown(data['ciudad_id']!, _ciudadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ciudadIdMeta);
    }
    if (data.containsKey('horario_desde')) {
      context.handle(
        _horarioDesdeMeta,
        horarioDesde.isAcceptableOrUnknown(
          data['horario_desde']!,
          _horarioDesdeMeta,
        ),
      );
    }
    if (data.containsKey('horario_hasta')) {
      context.handle(
        _horarioHastaMeta,
        horarioHasta.isAcceptableOrUnknown(
          data['horario_hasta']!,
          _horarioHastaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipoDocumentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo_documento_id'],
      )!,
      documento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}documento'],
      )!,
      nombreEstablecimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_establecimiento'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      administrador: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}administrador'],
      ),
      barrio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barrio'],
      ),
      gpsLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gps_lat'],
      ),
      gpsLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gps_lng'],
      ),
      consecutivoEntrega: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutivo_entrega'],
      )!,
      ivaDiscrimina: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}iva_discrimina'],
      )!,
      pagoCredito: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pago_credito'],
      )!,
      cupo: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cupo'],
      )!,
      plazo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plazo'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      categoriaClienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_cliente_id'],
      )!,
      rutaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ruta_id'],
      )!,
      ciudadId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ciudad_id'],
      )!,
      horarioDesde: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}horario_desde'],
      ),
      horarioHasta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}horario_hasta'],
      ),
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final int tipoDocumentoId;
  final String documento;
  final String nombreEstablecimiento;
  final String direccion;
  final String? telefono;
  final String? email;
  final String? administrador;
  final String? barrio;
  final double? gpsLat;
  final double? gpsLng;
  final int consecutivoEntrega;
  final bool ivaDiscrimina;
  final bool pagoCredito;
  final double cupo;
  final int? plazo;
  final bool activo;
  final int categoriaClienteId;
  final int rutaId;
  final int ciudadId;
  final String? horarioDesde;
  final String? horarioHasta;
  const Cliente({
    required this.id,
    required this.tipoDocumentoId,
    required this.documento,
    required this.nombreEstablecimiento,
    required this.direccion,
    this.telefono,
    this.email,
    this.administrador,
    this.barrio,
    this.gpsLat,
    this.gpsLng,
    required this.consecutivoEntrega,
    required this.ivaDiscrimina,
    required this.pagoCredito,
    required this.cupo,
    this.plazo,
    required this.activo,
    required this.categoriaClienteId,
    required this.rutaId,
    required this.ciudadId,
    this.horarioDesde,
    this.horarioHasta,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo_documento_id'] = Variable<int>(tipoDocumentoId);
    map['documento'] = Variable<String>(documento);
    map['nombre_establecimiento'] = Variable<String>(nombreEstablecimiento);
    map['direccion'] = Variable<String>(direccion);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || administrador != null) {
      map['administrador'] = Variable<String>(administrador);
    }
    if (!nullToAbsent || barrio != null) {
      map['barrio'] = Variable<String>(barrio);
    }
    if (!nullToAbsent || gpsLat != null) {
      map['gps_lat'] = Variable<double>(gpsLat);
    }
    if (!nullToAbsent || gpsLng != null) {
      map['gps_lng'] = Variable<double>(gpsLng);
    }
    map['consecutivo_entrega'] = Variable<int>(consecutivoEntrega);
    map['iva_discrimina'] = Variable<bool>(ivaDiscrimina);
    map['pago_credito'] = Variable<bool>(pagoCredito);
    map['cupo'] = Variable<double>(cupo);
    if (!nullToAbsent || plazo != null) {
      map['plazo'] = Variable<int>(plazo);
    }
    map['activo'] = Variable<bool>(activo);
    map['categoria_cliente_id'] = Variable<int>(categoriaClienteId);
    map['ruta_id'] = Variable<int>(rutaId);
    map['ciudad_id'] = Variable<int>(ciudadId);
    if (!nullToAbsent || horarioDesde != null) {
      map['horario_desde'] = Variable<String>(horarioDesde);
    }
    if (!nullToAbsent || horarioHasta != null) {
      map['horario_hasta'] = Variable<String>(horarioHasta);
    }
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      tipoDocumentoId: Value(tipoDocumentoId),
      documento: Value(documento),
      nombreEstablecimiento: Value(nombreEstablecimiento),
      direccion: Value(direccion),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      administrador: administrador == null && nullToAbsent
          ? const Value.absent()
          : Value(administrador),
      barrio: barrio == null && nullToAbsent
          ? const Value.absent()
          : Value(barrio),
      gpsLat: gpsLat == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsLat),
      gpsLng: gpsLng == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsLng),
      consecutivoEntrega: Value(consecutivoEntrega),
      ivaDiscrimina: Value(ivaDiscrimina),
      pagoCredito: Value(pagoCredito),
      cupo: Value(cupo),
      plazo: plazo == null && nullToAbsent
          ? const Value.absent()
          : Value(plazo),
      activo: Value(activo),
      categoriaClienteId: Value(categoriaClienteId),
      rutaId: Value(rutaId),
      ciudadId: Value(ciudadId),
      horarioDesde: horarioDesde == null && nullToAbsent
          ? const Value.absent()
          : Value(horarioDesde),
      horarioHasta: horarioHasta == null && nullToAbsent
          ? const Value.absent()
          : Value(horarioHasta),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<int>(json['id']),
      tipoDocumentoId: serializer.fromJson<int>(json['tipoDocumentoId']),
      documento: serializer.fromJson<String>(json['documento']),
      nombreEstablecimiento: serializer.fromJson<String>(
        json['nombreEstablecimiento'],
      ),
      direccion: serializer.fromJson<String>(json['direccion']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      administrador: serializer.fromJson<String?>(json['administrador']),
      barrio: serializer.fromJson<String?>(json['barrio']),
      gpsLat: serializer.fromJson<double?>(json['gpsLat']),
      gpsLng: serializer.fromJson<double?>(json['gpsLng']),
      consecutivoEntrega: serializer.fromJson<int>(json['consecutivoEntrega']),
      ivaDiscrimina: serializer.fromJson<bool>(json['ivaDiscrimina']),
      pagoCredito: serializer.fromJson<bool>(json['pagoCredito']),
      cupo: serializer.fromJson<double>(json['cupo']),
      plazo: serializer.fromJson<int?>(json['plazo']),
      activo: serializer.fromJson<bool>(json['activo']),
      categoriaClienteId: serializer.fromJson<int>(json['categoriaClienteId']),
      rutaId: serializer.fromJson<int>(json['rutaId']),
      ciudadId: serializer.fromJson<int>(json['ciudadId']),
      horarioDesde: serializer.fromJson<String?>(json['horarioDesde']),
      horarioHasta: serializer.fromJson<String?>(json['horarioHasta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipoDocumentoId': serializer.toJson<int>(tipoDocumentoId),
      'documento': serializer.toJson<String>(documento),
      'nombreEstablecimiento': serializer.toJson<String>(nombreEstablecimiento),
      'direccion': serializer.toJson<String>(direccion),
      'telefono': serializer.toJson<String?>(telefono),
      'email': serializer.toJson<String?>(email),
      'administrador': serializer.toJson<String?>(administrador),
      'barrio': serializer.toJson<String?>(barrio),
      'gpsLat': serializer.toJson<double?>(gpsLat),
      'gpsLng': serializer.toJson<double?>(gpsLng),
      'consecutivoEntrega': serializer.toJson<int>(consecutivoEntrega),
      'ivaDiscrimina': serializer.toJson<bool>(ivaDiscrimina),
      'pagoCredito': serializer.toJson<bool>(pagoCredito),
      'cupo': serializer.toJson<double>(cupo),
      'plazo': serializer.toJson<int?>(plazo),
      'activo': serializer.toJson<bool>(activo),
      'categoriaClienteId': serializer.toJson<int>(categoriaClienteId),
      'rutaId': serializer.toJson<int>(rutaId),
      'ciudadId': serializer.toJson<int>(ciudadId),
      'horarioDesde': serializer.toJson<String?>(horarioDesde),
      'horarioHasta': serializer.toJson<String?>(horarioHasta),
    };
  }

  Cliente copyWith({
    int? id,
    int? tipoDocumentoId,
    String? documento,
    String? nombreEstablecimiento,
    String? direccion,
    Value<String?> telefono = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> administrador = const Value.absent(),
    Value<String?> barrio = const Value.absent(),
    Value<double?> gpsLat = const Value.absent(),
    Value<double?> gpsLng = const Value.absent(),
    int? consecutivoEntrega,
    bool? ivaDiscrimina,
    bool? pagoCredito,
    double? cupo,
    Value<int?> plazo = const Value.absent(),
    bool? activo,
    int? categoriaClienteId,
    int? rutaId,
    int? ciudadId,
    Value<String?> horarioDesde = const Value.absent(),
    Value<String?> horarioHasta = const Value.absent(),
  }) => Cliente(
    id: id ?? this.id,
    tipoDocumentoId: tipoDocumentoId ?? this.tipoDocumentoId,
    documento: documento ?? this.documento,
    nombreEstablecimiento: nombreEstablecimiento ?? this.nombreEstablecimiento,
    direccion: direccion ?? this.direccion,
    telefono: telefono.present ? telefono.value : this.telefono,
    email: email.present ? email.value : this.email,
    administrador: administrador.present
        ? administrador.value
        : this.administrador,
    barrio: barrio.present ? barrio.value : this.barrio,
    gpsLat: gpsLat.present ? gpsLat.value : this.gpsLat,
    gpsLng: gpsLng.present ? gpsLng.value : this.gpsLng,
    consecutivoEntrega: consecutivoEntrega ?? this.consecutivoEntrega,
    ivaDiscrimina: ivaDiscrimina ?? this.ivaDiscrimina,
    pagoCredito: pagoCredito ?? this.pagoCredito,
    cupo: cupo ?? this.cupo,
    plazo: plazo.present ? plazo.value : this.plazo,
    activo: activo ?? this.activo,
    categoriaClienteId: categoriaClienteId ?? this.categoriaClienteId,
    rutaId: rutaId ?? this.rutaId,
    ciudadId: ciudadId ?? this.ciudadId,
    horarioDesde: horarioDesde.present ? horarioDesde.value : this.horarioDesde,
    horarioHasta: horarioHasta.present ? horarioHasta.value : this.horarioHasta,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      tipoDocumentoId: data.tipoDocumentoId.present
          ? data.tipoDocumentoId.value
          : this.tipoDocumentoId,
      documento: data.documento.present ? data.documento.value : this.documento,
      nombreEstablecimiento: data.nombreEstablecimiento.present
          ? data.nombreEstablecimiento.value
          : this.nombreEstablecimiento,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      administrador: data.administrador.present
          ? data.administrador.value
          : this.administrador,
      barrio: data.barrio.present ? data.barrio.value : this.barrio,
      gpsLat: data.gpsLat.present ? data.gpsLat.value : this.gpsLat,
      gpsLng: data.gpsLng.present ? data.gpsLng.value : this.gpsLng,
      consecutivoEntrega: data.consecutivoEntrega.present
          ? data.consecutivoEntrega.value
          : this.consecutivoEntrega,
      ivaDiscrimina: data.ivaDiscrimina.present
          ? data.ivaDiscrimina.value
          : this.ivaDiscrimina,
      pagoCredito: data.pagoCredito.present
          ? data.pagoCredito.value
          : this.pagoCredito,
      cupo: data.cupo.present ? data.cupo.value : this.cupo,
      plazo: data.plazo.present ? data.plazo.value : this.plazo,
      activo: data.activo.present ? data.activo.value : this.activo,
      categoriaClienteId: data.categoriaClienteId.present
          ? data.categoriaClienteId.value
          : this.categoriaClienteId,
      rutaId: data.rutaId.present ? data.rutaId.value : this.rutaId,
      ciudadId: data.ciudadId.present ? data.ciudadId.value : this.ciudadId,
      horarioDesde: data.horarioDesde.present
          ? data.horarioDesde.value
          : this.horarioDesde,
      horarioHasta: data.horarioHasta.present
          ? data.horarioHasta.value
          : this.horarioHasta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('tipoDocumentoId: $tipoDocumentoId, ')
          ..write('documento: $documento, ')
          ..write('nombreEstablecimiento: $nombreEstablecimiento, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('administrador: $administrador, ')
          ..write('barrio: $barrio, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('consecutivoEntrega: $consecutivoEntrega, ')
          ..write('ivaDiscrimina: $ivaDiscrimina, ')
          ..write('pagoCredito: $pagoCredito, ')
          ..write('cupo: $cupo, ')
          ..write('plazo: $plazo, ')
          ..write('activo: $activo, ')
          ..write('categoriaClienteId: $categoriaClienteId, ')
          ..write('rutaId: $rutaId, ')
          ..write('ciudadId: $ciudadId, ')
          ..write('horarioDesde: $horarioDesde, ')
          ..write('horarioHasta: $horarioHasta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    tipoDocumentoId,
    documento,
    nombreEstablecimiento,
    direccion,
    telefono,
    email,
    administrador,
    barrio,
    gpsLat,
    gpsLng,
    consecutivoEntrega,
    ivaDiscrimina,
    pagoCredito,
    cupo,
    plazo,
    activo,
    categoriaClienteId,
    rutaId,
    ciudadId,
    horarioDesde,
    horarioHasta,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.tipoDocumentoId == this.tipoDocumentoId &&
          other.documento == this.documento &&
          other.nombreEstablecimiento == this.nombreEstablecimiento &&
          other.direccion == this.direccion &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.administrador == this.administrador &&
          other.barrio == this.barrio &&
          other.gpsLat == this.gpsLat &&
          other.gpsLng == this.gpsLng &&
          other.consecutivoEntrega == this.consecutivoEntrega &&
          other.ivaDiscrimina == this.ivaDiscrimina &&
          other.pagoCredito == this.pagoCredito &&
          other.cupo == this.cupo &&
          other.plazo == this.plazo &&
          other.activo == this.activo &&
          other.categoriaClienteId == this.categoriaClienteId &&
          other.rutaId == this.rutaId &&
          other.ciudadId == this.ciudadId &&
          other.horarioDesde == this.horarioDesde &&
          other.horarioHasta == this.horarioHasta);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> id;
  final Value<int> tipoDocumentoId;
  final Value<String> documento;
  final Value<String> nombreEstablecimiento;
  final Value<String> direccion;
  final Value<String?> telefono;
  final Value<String?> email;
  final Value<String?> administrador;
  final Value<String?> barrio;
  final Value<double?> gpsLat;
  final Value<double?> gpsLng;
  final Value<int> consecutivoEntrega;
  final Value<bool> ivaDiscrimina;
  final Value<bool> pagoCredito;
  final Value<double> cupo;
  final Value<int?> plazo;
  final Value<bool> activo;
  final Value<int> categoriaClienteId;
  final Value<int> rutaId;
  final Value<int> ciudadId;
  final Value<String?> horarioDesde;
  final Value<String?> horarioHasta;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.tipoDocumentoId = const Value.absent(),
    this.documento = const Value.absent(),
    this.nombreEstablecimiento = const Value.absent(),
    this.direccion = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.administrador = const Value.absent(),
    this.barrio = const Value.absent(),
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.consecutivoEntrega = const Value.absent(),
    this.ivaDiscrimina = const Value.absent(),
    this.pagoCredito = const Value.absent(),
    this.cupo = const Value.absent(),
    this.plazo = const Value.absent(),
    this.activo = const Value.absent(),
    this.categoriaClienteId = const Value.absent(),
    this.rutaId = const Value.absent(),
    this.ciudadId = const Value.absent(),
    this.horarioDesde = const Value.absent(),
    this.horarioHasta = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required int tipoDocumentoId,
    required String documento,
    required String nombreEstablecimiento,
    required String direccion,
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.administrador = const Value.absent(),
    this.barrio = const Value.absent(),
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.consecutivoEntrega = const Value.absent(),
    this.ivaDiscrimina = const Value.absent(),
    this.pagoCredito = const Value.absent(),
    this.cupo = const Value.absent(),
    this.plazo = const Value.absent(),
    this.activo = const Value.absent(),
    required int categoriaClienteId,
    required int rutaId,
    required int ciudadId,
    this.horarioDesde = const Value.absent(),
    this.horarioHasta = const Value.absent(),
  }) : tipoDocumentoId = Value(tipoDocumentoId),
       documento = Value(documento),
       nombreEstablecimiento = Value(nombreEstablecimiento),
       direccion = Value(direccion),
       categoriaClienteId = Value(categoriaClienteId),
       rutaId = Value(rutaId),
       ciudadId = Value(ciudadId);
  static Insertable<Cliente> custom({
    Expression<int>? id,
    Expression<int>? tipoDocumentoId,
    Expression<String>? documento,
    Expression<String>? nombreEstablecimiento,
    Expression<String>? direccion,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? administrador,
    Expression<String>? barrio,
    Expression<double>? gpsLat,
    Expression<double>? gpsLng,
    Expression<int>? consecutivoEntrega,
    Expression<bool>? ivaDiscrimina,
    Expression<bool>? pagoCredito,
    Expression<double>? cupo,
    Expression<int>? plazo,
    Expression<bool>? activo,
    Expression<int>? categoriaClienteId,
    Expression<int>? rutaId,
    Expression<int>? ciudadId,
    Expression<String>? horarioDesde,
    Expression<String>? horarioHasta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipoDocumentoId != null) 'tipo_documento_id': tipoDocumentoId,
      if (documento != null) 'documento': documento,
      if (nombreEstablecimiento != null)
        'nombre_establecimiento': nombreEstablecimiento,
      if (direccion != null) 'direccion': direccion,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (administrador != null) 'administrador': administrador,
      if (barrio != null) 'barrio': barrio,
      if (gpsLat != null) 'gps_lat': gpsLat,
      if (gpsLng != null) 'gps_lng': gpsLng,
      if (consecutivoEntrega != null) 'consecutivo_entrega': consecutivoEntrega,
      if (ivaDiscrimina != null) 'iva_discrimina': ivaDiscrimina,
      if (pagoCredito != null) 'pago_credito': pagoCredito,
      if (cupo != null) 'cupo': cupo,
      if (plazo != null) 'plazo': plazo,
      if (activo != null) 'activo': activo,
      if (categoriaClienteId != null)
        'categoria_cliente_id': categoriaClienteId,
      if (rutaId != null) 'ruta_id': rutaId,
      if (ciudadId != null) 'ciudad_id': ciudadId,
      if (horarioDesde != null) 'horario_desde': horarioDesde,
      if (horarioHasta != null) 'horario_hasta': horarioHasta,
    });
  }

  ClientesCompanion copyWith({
    Value<int>? id,
    Value<int>? tipoDocumentoId,
    Value<String>? documento,
    Value<String>? nombreEstablecimiento,
    Value<String>? direccion,
    Value<String?>? telefono,
    Value<String?>? email,
    Value<String?>? administrador,
    Value<String?>? barrio,
    Value<double?>? gpsLat,
    Value<double?>? gpsLng,
    Value<int>? consecutivoEntrega,
    Value<bool>? ivaDiscrimina,
    Value<bool>? pagoCredito,
    Value<double>? cupo,
    Value<int?>? plazo,
    Value<bool>? activo,
    Value<int>? categoriaClienteId,
    Value<int>? rutaId,
    Value<int>? ciudadId,
    Value<String?>? horarioDesde,
    Value<String?>? horarioHasta,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      tipoDocumentoId: tipoDocumentoId ?? this.tipoDocumentoId,
      documento: documento ?? this.documento,
      nombreEstablecimiento:
          nombreEstablecimiento ?? this.nombreEstablecimiento,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      administrador: administrador ?? this.administrador,
      barrio: barrio ?? this.barrio,
      gpsLat: gpsLat ?? this.gpsLat,
      gpsLng: gpsLng ?? this.gpsLng,
      consecutivoEntrega: consecutivoEntrega ?? this.consecutivoEntrega,
      ivaDiscrimina: ivaDiscrimina ?? this.ivaDiscrimina,
      pagoCredito: pagoCredito ?? this.pagoCredito,
      cupo: cupo ?? this.cupo,
      plazo: plazo ?? this.plazo,
      activo: activo ?? this.activo,
      categoriaClienteId: categoriaClienteId ?? this.categoriaClienteId,
      rutaId: rutaId ?? this.rutaId,
      ciudadId: ciudadId ?? this.ciudadId,
      horarioDesde: horarioDesde ?? this.horarioDesde,
      horarioHasta: horarioHasta ?? this.horarioHasta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipoDocumentoId.present) {
      map['tipo_documento_id'] = Variable<int>(tipoDocumentoId.value);
    }
    if (documento.present) {
      map['documento'] = Variable<String>(documento.value);
    }
    if (nombreEstablecimiento.present) {
      map['nombre_establecimiento'] = Variable<String>(
        nombreEstablecimiento.value,
      );
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (administrador.present) {
      map['administrador'] = Variable<String>(administrador.value);
    }
    if (barrio.present) {
      map['barrio'] = Variable<String>(barrio.value);
    }
    if (gpsLat.present) {
      map['gps_lat'] = Variable<double>(gpsLat.value);
    }
    if (gpsLng.present) {
      map['gps_lng'] = Variable<double>(gpsLng.value);
    }
    if (consecutivoEntrega.present) {
      map['consecutivo_entrega'] = Variable<int>(consecutivoEntrega.value);
    }
    if (ivaDiscrimina.present) {
      map['iva_discrimina'] = Variable<bool>(ivaDiscrimina.value);
    }
    if (pagoCredito.present) {
      map['pago_credito'] = Variable<bool>(pagoCredito.value);
    }
    if (cupo.present) {
      map['cupo'] = Variable<double>(cupo.value);
    }
    if (plazo.present) {
      map['plazo'] = Variable<int>(plazo.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (categoriaClienteId.present) {
      map['categoria_cliente_id'] = Variable<int>(categoriaClienteId.value);
    }
    if (rutaId.present) {
      map['ruta_id'] = Variable<int>(rutaId.value);
    }
    if (ciudadId.present) {
      map['ciudad_id'] = Variable<int>(ciudadId.value);
    }
    if (horarioDesde.present) {
      map['horario_desde'] = Variable<String>(horarioDesde.value);
    }
    if (horarioHasta.present) {
      map['horario_hasta'] = Variable<String>(horarioHasta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('tipoDocumentoId: $tipoDocumentoId, ')
          ..write('documento: $documento, ')
          ..write('nombreEstablecimiento: $nombreEstablecimiento, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('administrador: $administrador, ')
          ..write('barrio: $barrio, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('consecutivoEntrega: $consecutivoEntrega, ')
          ..write('ivaDiscrimina: $ivaDiscrimina, ')
          ..write('pagoCredito: $pagoCredito, ')
          ..write('cupo: $cupo, ')
          ..write('plazo: $plazo, ')
          ..write('activo: $activo, ')
          ..write('categoriaClienteId: $categoriaClienteId, ')
          ..write('rutaId: $rutaId, ')
          ..write('ciudadId: $ciudadId, ')
          ..write('horarioDesde: $horarioDesde, ')
          ..write('horarioHasta: $horarioHasta')
          ..write(')'))
        .toString();
  }
}

class $PreciosTable extends Precios with TableInfo<$PreciosTable, Precio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreciosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id)',
    ),
  );
  static const VerificationMeta _categoriaClienteIdMeta =
      const VerificationMeta('categoriaClienteId');
  @override
  late final GeneratedColumn<int> categoriaClienteId = GeneratedColumn<int>(
    'categoria_cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias_cliente (id)',
    ),
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productoId,
    categoriaClienteId,
    valor,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'precios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Precio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('categoria_cliente_id')) {
      context.handle(
        _categoriaClienteIdMeta,
        categoriaClienteId.isAcceptableOrUnknown(
          data['categoria_cliente_id']!,
          _categoriaClienteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaClienteIdMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {productoId, categoriaClienteId, fecha},
  ];
  @override
  Precio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Precio(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      categoriaClienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_cliente_id'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  $PreciosTable createAlias(String alias) {
    return $PreciosTable(attachedDatabase, alias);
  }
}

class Precio extends DataClass implements Insertable<Precio> {
  final int id;
  final int productoId;
  final int categoriaClienteId;
  final double valor;
  final DateTime fecha;
  const Precio({
    required this.id,
    required this.productoId,
    required this.categoriaClienteId,
    required this.valor,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['producto_id'] = Variable<int>(productoId);
    map['categoria_cliente_id'] = Variable<int>(categoriaClienteId);
    map['valor'] = Variable<double>(valor);
    map['fecha'] = Variable<DateTime>(fecha);
    return map;
  }

  PreciosCompanion toCompanion(bool nullToAbsent) {
    return PreciosCompanion(
      id: Value(id),
      productoId: Value(productoId),
      categoriaClienteId: Value(categoriaClienteId),
      valor: Value(valor),
      fecha: Value(fecha),
    );
  }

  factory Precio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Precio(
      id: serializer.fromJson<int>(json['id']),
      productoId: serializer.fromJson<int>(json['productoId']),
      categoriaClienteId: serializer.fromJson<int>(json['categoriaClienteId']),
      valor: serializer.fromJson<double>(json['valor']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productoId': serializer.toJson<int>(productoId),
      'categoriaClienteId': serializer.toJson<int>(categoriaClienteId),
      'valor': serializer.toJson<double>(valor),
      'fecha': serializer.toJson<DateTime>(fecha),
    };
  }

  Precio copyWith({
    int? id,
    int? productoId,
    int? categoriaClienteId,
    double? valor,
    DateTime? fecha,
  }) => Precio(
    id: id ?? this.id,
    productoId: productoId ?? this.productoId,
    categoriaClienteId: categoriaClienteId ?? this.categoriaClienteId,
    valor: valor ?? this.valor,
    fecha: fecha ?? this.fecha,
  );
  Precio copyWithCompanion(PreciosCompanion data) {
    return Precio(
      id: data.id.present ? data.id.value : this.id,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      categoriaClienteId: data.categoriaClienteId.present
          ? data.categoriaClienteId.value
          : this.categoriaClienteId,
      valor: data.valor.present ? data.valor.value : this.valor,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Precio(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('categoriaClienteId: $categoriaClienteId, ')
          ..write('valor: $valor, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productoId, categoriaClienteId, valor, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Precio &&
          other.id == this.id &&
          other.productoId == this.productoId &&
          other.categoriaClienteId == this.categoriaClienteId &&
          other.valor == this.valor &&
          other.fecha == this.fecha);
}

class PreciosCompanion extends UpdateCompanion<Precio> {
  final Value<int> id;
  final Value<int> productoId;
  final Value<int> categoriaClienteId;
  final Value<double> valor;
  final Value<DateTime> fecha;
  const PreciosCompanion({
    this.id = const Value.absent(),
    this.productoId = const Value.absent(),
    this.categoriaClienteId = const Value.absent(),
    this.valor = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  PreciosCompanion.insert({
    this.id = const Value.absent(),
    required int productoId,
    required int categoriaClienteId,
    required double valor,
    required DateTime fecha,
  }) : productoId = Value(productoId),
       categoriaClienteId = Value(categoriaClienteId),
       valor = Value(valor),
       fecha = Value(fecha);
  static Insertable<Precio> custom({
    Expression<int>? id,
    Expression<int>? productoId,
    Expression<int>? categoriaClienteId,
    Expression<double>? valor,
    Expression<DateTime>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productoId != null) 'producto_id': productoId,
      if (categoriaClienteId != null)
        'categoria_cliente_id': categoriaClienteId,
      if (valor != null) 'valor': valor,
      if (fecha != null) 'fecha': fecha,
    });
  }

  PreciosCompanion copyWith({
    Value<int>? id,
    Value<int>? productoId,
    Value<int>? categoriaClienteId,
    Value<double>? valor,
    Value<DateTime>? fecha,
  }) {
    return PreciosCompanion(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      categoriaClienteId: categoriaClienteId ?? this.categoriaClienteId,
      valor: valor ?? this.valor,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (categoriaClienteId.present) {
      map['categoria_cliente_id'] = Variable<int>(categoriaClienteId.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreciosCompanion(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('categoriaClienteId: $categoriaClienteId, ')
          ..write('valor: $valor, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $PromocionesTable extends Promociones
    with TableInfo<$PromocionesTable, Promocion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromocionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idpromocionMeta = const VerificationMeta(
    'idpromocion',
  );
  @override
  late final GeneratedColumn<int> idpromocion = GeneratedColumn<int>(
    'idpromocion',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _promocionparaMeta = const VerificationMeta(
    'promocionpara',
  );
  @override
  late final GeneratedColumn<String> promocionpara = GeneratedColumn<String>(
    'promocionpara',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promociondeMeta = const VerificationMeta(
    'promocionde',
  );
  @override
  late final GeneratedColumn<String> promocionde = GeneratedColumn<String>(
    'promocionde',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadventaMeta = const VerificationMeta(
    'cantidadventa',
  );
  @override
  late final GeneratedColumn<int> cantidadventa = GeneratedColumn<int>(
    'cantidadventa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cantidadsobreventaMeta =
      const VerificationMeta('cantidadsobreventa');
  @override
  late final GeneratedColumn<int> cantidadsobreventa = GeneratedColumn<int>(
    'cantidadsobreventa',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _porcentajesobreventaMeta =
      const VerificationMeta('porcentajesobreventa');
  @override
  late final GeneratedColumn<int> porcentajesobreventa = GeneratedColumn<int>(
    'porcentajesobreventa',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechadesdeMeta = const VerificationMeta(
    'fechadesde',
  );
  @override
  late final GeneratedColumn<DateTime> fechadesde = GeneratedColumn<DateTime>(
    'fechadesde',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechahastaMeta = const VerificationMeta(
    'fechahasta',
  );
  @override
  late final GeneratedColumn<DateTime> fechahasta = GeneratedColumn<DateTime>(
    'fechahasta',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutaIdMeta = const VerificationMeta('rutaId');
  @override
  late final GeneratedColumn<int> rutaId = GeneratedColumn<int>(
    'ruta_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id)',
    ),
  );
  static const VerificationMeta _categoriaClienteIdMeta =
      const VerificationMeta('categoriaClienteId');
  @override
  late final GeneratedColumn<int> categoriaClienteId = GeneratedColumn<int>(
    'categoria_cliente_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias_cliente (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idpromocion,
    promocionpara,
    promocionde,
    cantidadventa,
    cantidadsobreventa,
    porcentajesobreventa,
    fechadesde,
    fechahasta,
    rutaId,
    productoId,
    categoriaClienteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promociones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Promocion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('idpromocion')) {
      context.handle(
        _idpromocionMeta,
        idpromocion.isAcceptableOrUnknown(
          data['idpromocion']!,
          _idpromocionMeta,
        ),
      );
    }
    if (data.containsKey('promocionpara')) {
      context.handle(
        _promocionparaMeta,
        promocionpara.isAcceptableOrUnknown(
          data['promocionpara']!,
          _promocionparaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_promocionparaMeta);
    }
    if (data.containsKey('promocionde')) {
      context.handle(
        _promociondeMeta,
        promocionde.isAcceptableOrUnknown(
          data['promocionde']!,
          _promociondeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_promociondeMeta);
    }
    if (data.containsKey('cantidadventa')) {
      context.handle(
        _cantidadventaMeta,
        cantidadventa.isAcceptableOrUnknown(
          data['cantidadventa']!,
          _cantidadventaMeta,
        ),
      );
    }
    if (data.containsKey('cantidadsobreventa')) {
      context.handle(
        _cantidadsobreventaMeta,
        cantidadsobreventa.isAcceptableOrUnknown(
          data['cantidadsobreventa']!,
          _cantidadsobreventaMeta,
        ),
      );
    }
    if (data.containsKey('porcentajesobreventa')) {
      context.handle(
        _porcentajesobreventaMeta,
        porcentajesobreventa.isAcceptableOrUnknown(
          data['porcentajesobreventa']!,
          _porcentajesobreventaMeta,
        ),
      );
    }
    if (data.containsKey('fechadesde')) {
      context.handle(
        _fechadesdeMeta,
        fechadesde.isAcceptableOrUnknown(data['fechadesde']!, _fechadesdeMeta),
      );
    } else if (isInserting) {
      context.missing(_fechadesdeMeta);
    }
    if (data.containsKey('fechahasta')) {
      context.handle(
        _fechahastaMeta,
        fechahasta.isAcceptableOrUnknown(data['fechahasta']!, _fechahastaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechahastaMeta);
    }
    if (data.containsKey('ruta_id')) {
      context.handle(
        _rutaIdMeta,
        rutaId.isAcceptableOrUnknown(data['ruta_id']!, _rutaIdMeta),
      );
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('categoria_cliente_id')) {
      context.handle(
        _categoriaClienteIdMeta,
        categoriaClienteId.isAcceptableOrUnknown(
          data['categoria_cliente_id']!,
          _categoriaClienteIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idpromocion};
  @override
  Promocion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Promocion(
      idpromocion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idpromocion'],
      )!,
      promocionpara: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}promocionpara'],
      )!,
      promocionde: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}promocionde'],
      )!,
      cantidadventa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidadventa'],
      )!,
      cantidadsobreventa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidadsobreventa'],
      ),
      porcentajesobreventa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}porcentajesobreventa'],
      ),
      fechadesde: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fechadesde'],
      )!,
      fechahasta: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fechahasta'],
      )!,
      rutaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ruta_id'],
      ),
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      categoriaClienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_cliente_id'],
      ),
    );
  }

  @override
  $PromocionesTable createAlias(String alias) {
    return $PromocionesTable(attachedDatabase, alias);
  }
}

class Promocion extends DataClass implements Insertable<Promocion> {
  final int idpromocion;
  final String promocionpara;
  final String promocionde;
  final int cantidadventa;
  final int? cantidadsobreventa;
  final int? porcentajesobreventa;
  final DateTime fechadesde;
  final DateTime fechahasta;
  final int? rutaId;
  final int productoId;
  final int? categoriaClienteId;
  const Promocion({
    required this.idpromocion,
    required this.promocionpara,
    required this.promocionde,
    required this.cantidadventa,
    this.cantidadsobreventa,
    this.porcentajesobreventa,
    required this.fechadesde,
    required this.fechahasta,
    this.rutaId,
    required this.productoId,
    this.categoriaClienteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['idpromocion'] = Variable<int>(idpromocion);
    map['promocionpara'] = Variable<String>(promocionpara);
    map['promocionde'] = Variable<String>(promocionde);
    map['cantidadventa'] = Variable<int>(cantidadventa);
    if (!nullToAbsent || cantidadsobreventa != null) {
      map['cantidadsobreventa'] = Variable<int>(cantidadsobreventa);
    }
    if (!nullToAbsent || porcentajesobreventa != null) {
      map['porcentajesobreventa'] = Variable<int>(porcentajesobreventa);
    }
    map['fechadesde'] = Variable<DateTime>(fechadesde);
    map['fechahasta'] = Variable<DateTime>(fechahasta);
    if (!nullToAbsent || rutaId != null) {
      map['ruta_id'] = Variable<int>(rutaId);
    }
    map['producto_id'] = Variable<int>(productoId);
    if (!nullToAbsent || categoriaClienteId != null) {
      map['categoria_cliente_id'] = Variable<int>(categoriaClienteId);
    }
    return map;
  }

  PromocionesCompanion toCompanion(bool nullToAbsent) {
    return PromocionesCompanion(
      idpromocion: Value(idpromocion),
      promocionpara: Value(promocionpara),
      promocionde: Value(promocionde),
      cantidadventa: Value(cantidadventa),
      cantidadsobreventa: cantidadsobreventa == null && nullToAbsent
          ? const Value.absent()
          : Value(cantidadsobreventa),
      porcentajesobreventa: porcentajesobreventa == null && nullToAbsent
          ? const Value.absent()
          : Value(porcentajesobreventa),
      fechadesde: Value(fechadesde),
      fechahasta: Value(fechahasta),
      rutaId: rutaId == null && nullToAbsent
          ? const Value.absent()
          : Value(rutaId),
      productoId: Value(productoId),
      categoriaClienteId: categoriaClienteId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaClienteId),
    );
  }

  factory Promocion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Promocion(
      idpromocion: serializer.fromJson<int>(json['idpromocion']),
      promocionpara: serializer.fromJson<String>(json['promocionpara']),
      promocionde: serializer.fromJson<String>(json['promocionde']),
      cantidadventa: serializer.fromJson<int>(json['cantidadventa']),
      cantidadsobreventa: serializer.fromJson<int?>(json['cantidadsobreventa']),
      porcentajesobreventa: serializer.fromJson<int?>(
        json['porcentajesobreventa'],
      ),
      fechadesde: serializer.fromJson<DateTime>(json['fechadesde']),
      fechahasta: serializer.fromJson<DateTime>(json['fechahasta']),
      rutaId: serializer.fromJson<int?>(json['rutaId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      categoriaClienteId: serializer.fromJson<int?>(json['categoriaClienteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idpromocion': serializer.toJson<int>(idpromocion),
      'promocionpara': serializer.toJson<String>(promocionpara),
      'promocionde': serializer.toJson<String>(promocionde),
      'cantidadventa': serializer.toJson<int>(cantidadventa),
      'cantidadsobreventa': serializer.toJson<int?>(cantidadsobreventa),
      'porcentajesobreventa': serializer.toJson<int?>(porcentajesobreventa),
      'fechadesde': serializer.toJson<DateTime>(fechadesde),
      'fechahasta': serializer.toJson<DateTime>(fechahasta),
      'rutaId': serializer.toJson<int?>(rutaId),
      'productoId': serializer.toJson<int>(productoId),
      'categoriaClienteId': serializer.toJson<int?>(categoriaClienteId),
    };
  }

  Promocion copyWith({
    int? idpromocion,
    String? promocionpara,
    String? promocionde,
    int? cantidadventa,
    Value<int?> cantidadsobreventa = const Value.absent(),
    Value<int?> porcentajesobreventa = const Value.absent(),
    DateTime? fechadesde,
    DateTime? fechahasta,
    Value<int?> rutaId = const Value.absent(),
    int? productoId,
    Value<int?> categoriaClienteId = const Value.absent(),
  }) => Promocion(
    idpromocion: idpromocion ?? this.idpromocion,
    promocionpara: promocionpara ?? this.promocionpara,
    promocionde: promocionde ?? this.promocionde,
    cantidadventa: cantidadventa ?? this.cantidadventa,
    cantidadsobreventa: cantidadsobreventa.present
        ? cantidadsobreventa.value
        : this.cantidadsobreventa,
    porcentajesobreventa: porcentajesobreventa.present
        ? porcentajesobreventa.value
        : this.porcentajesobreventa,
    fechadesde: fechadesde ?? this.fechadesde,
    fechahasta: fechahasta ?? this.fechahasta,
    rutaId: rutaId.present ? rutaId.value : this.rutaId,
    productoId: productoId ?? this.productoId,
    categoriaClienteId: categoriaClienteId.present
        ? categoriaClienteId.value
        : this.categoriaClienteId,
  );
  Promocion copyWithCompanion(PromocionesCompanion data) {
    return Promocion(
      idpromocion: data.idpromocion.present
          ? data.idpromocion.value
          : this.idpromocion,
      promocionpara: data.promocionpara.present
          ? data.promocionpara.value
          : this.promocionpara,
      promocionde: data.promocionde.present
          ? data.promocionde.value
          : this.promocionde,
      cantidadventa: data.cantidadventa.present
          ? data.cantidadventa.value
          : this.cantidadventa,
      cantidadsobreventa: data.cantidadsobreventa.present
          ? data.cantidadsobreventa.value
          : this.cantidadsobreventa,
      porcentajesobreventa: data.porcentajesobreventa.present
          ? data.porcentajesobreventa.value
          : this.porcentajesobreventa,
      fechadesde: data.fechadesde.present
          ? data.fechadesde.value
          : this.fechadesde,
      fechahasta: data.fechahasta.present
          ? data.fechahasta.value
          : this.fechahasta,
      rutaId: data.rutaId.present ? data.rutaId.value : this.rutaId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      categoriaClienteId: data.categoriaClienteId.present
          ? data.categoriaClienteId.value
          : this.categoriaClienteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Promocion(')
          ..write('idpromocion: $idpromocion, ')
          ..write('promocionpara: $promocionpara, ')
          ..write('promocionde: $promocionde, ')
          ..write('cantidadventa: $cantidadventa, ')
          ..write('cantidadsobreventa: $cantidadsobreventa, ')
          ..write('porcentajesobreventa: $porcentajesobreventa, ')
          ..write('fechadesde: $fechadesde, ')
          ..write('fechahasta: $fechahasta, ')
          ..write('rutaId: $rutaId, ')
          ..write('productoId: $productoId, ')
          ..write('categoriaClienteId: $categoriaClienteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idpromocion,
    promocionpara,
    promocionde,
    cantidadventa,
    cantidadsobreventa,
    porcentajesobreventa,
    fechadesde,
    fechahasta,
    rutaId,
    productoId,
    categoriaClienteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Promocion &&
          other.idpromocion == this.idpromocion &&
          other.promocionpara == this.promocionpara &&
          other.promocionde == this.promocionde &&
          other.cantidadventa == this.cantidadventa &&
          other.cantidadsobreventa == this.cantidadsobreventa &&
          other.porcentajesobreventa == this.porcentajesobreventa &&
          other.fechadesde == this.fechadesde &&
          other.fechahasta == this.fechahasta &&
          other.rutaId == this.rutaId &&
          other.productoId == this.productoId &&
          other.categoriaClienteId == this.categoriaClienteId);
}

class PromocionesCompanion extends UpdateCompanion<Promocion> {
  final Value<int> idpromocion;
  final Value<String> promocionpara;
  final Value<String> promocionde;
  final Value<int> cantidadventa;
  final Value<int?> cantidadsobreventa;
  final Value<int?> porcentajesobreventa;
  final Value<DateTime> fechadesde;
  final Value<DateTime> fechahasta;
  final Value<int?> rutaId;
  final Value<int> productoId;
  final Value<int?> categoriaClienteId;
  const PromocionesCompanion({
    this.idpromocion = const Value.absent(),
    this.promocionpara = const Value.absent(),
    this.promocionde = const Value.absent(),
    this.cantidadventa = const Value.absent(),
    this.cantidadsobreventa = const Value.absent(),
    this.porcentajesobreventa = const Value.absent(),
    this.fechadesde = const Value.absent(),
    this.fechahasta = const Value.absent(),
    this.rutaId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.categoriaClienteId = const Value.absent(),
  });
  PromocionesCompanion.insert({
    this.idpromocion = const Value.absent(),
    required String promocionpara,
    required String promocionde,
    this.cantidadventa = const Value.absent(),
    this.cantidadsobreventa = const Value.absent(),
    this.porcentajesobreventa = const Value.absent(),
    required DateTime fechadesde,
    required DateTime fechahasta,
    this.rutaId = const Value.absent(),
    required int productoId,
    this.categoriaClienteId = const Value.absent(),
  }) : promocionpara = Value(promocionpara),
       promocionde = Value(promocionde),
       fechadesde = Value(fechadesde),
       fechahasta = Value(fechahasta),
       productoId = Value(productoId);
  static Insertable<Promocion> custom({
    Expression<int>? idpromocion,
    Expression<String>? promocionpara,
    Expression<String>? promocionde,
    Expression<int>? cantidadventa,
    Expression<int>? cantidadsobreventa,
    Expression<int>? porcentajesobreventa,
    Expression<DateTime>? fechadesde,
    Expression<DateTime>? fechahasta,
    Expression<int>? rutaId,
    Expression<int>? productoId,
    Expression<int>? categoriaClienteId,
  }) {
    return RawValuesInsertable({
      if (idpromocion != null) 'idpromocion': idpromocion,
      if (promocionpara != null) 'promocionpara': promocionpara,
      if (promocionde != null) 'promocionde': promocionde,
      if (cantidadventa != null) 'cantidadventa': cantidadventa,
      if (cantidadsobreventa != null) 'cantidadsobreventa': cantidadsobreventa,
      if (porcentajesobreventa != null)
        'porcentajesobreventa': porcentajesobreventa,
      if (fechadesde != null) 'fechadesde': fechadesde,
      if (fechahasta != null) 'fechahasta': fechahasta,
      if (rutaId != null) 'ruta_id': rutaId,
      if (productoId != null) 'producto_id': productoId,
      if (categoriaClienteId != null)
        'categoria_cliente_id': categoriaClienteId,
    });
  }

  PromocionesCompanion copyWith({
    Value<int>? idpromocion,
    Value<String>? promocionpara,
    Value<String>? promocionde,
    Value<int>? cantidadventa,
    Value<int?>? cantidadsobreventa,
    Value<int?>? porcentajesobreventa,
    Value<DateTime>? fechadesde,
    Value<DateTime>? fechahasta,
    Value<int?>? rutaId,
    Value<int>? productoId,
    Value<int?>? categoriaClienteId,
  }) {
    return PromocionesCompanion(
      idpromocion: idpromocion ?? this.idpromocion,
      promocionpara: promocionpara ?? this.promocionpara,
      promocionde: promocionde ?? this.promocionde,
      cantidadventa: cantidadventa ?? this.cantidadventa,
      cantidadsobreventa: cantidadsobreventa ?? this.cantidadsobreventa,
      porcentajesobreventa: porcentajesobreventa ?? this.porcentajesobreventa,
      fechadesde: fechadesde ?? this.fechadesde,
      fechahasta: fechahasta ?? this.fechahasta,
      rutaId: rutaId ?? this.rutaId,
      productoId: productoId ?? this.productoId,
      categoriaClienteId: categoriaClienteId ?? this.categoriaClienteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idpromocion.present) {
      map['idpromocion'] = Variable<int>(idpromocion.value);
    }
    if (promocionpara.present) {
      map['promocionpara'] = Variable<String>(promocionpara.value);
    }
    if (promocionde.present) {
      map['promocionde'] = Variable<String>(promocionde.value);
    }
    if (cantidadventa.present) {
      map['cantidadventa'] = Variable<int>(cantidadventa.value);
    }
    if (cantidadsobreventa.present) {
      map['cantidadsobreventa'] = Variable<int>(cantidadsobreventa.value);
    }
    if (porcentajesobreventa.present) {
      map['porcentajesobreventa'] = Variable<int>(porcentajesobreventa.value);
    }
    if (fechadesde.present) {
      map['fechadesde'] = Variable<DateTime>(fechadesde.value);
    }
    if (fechahasta.present) {
      map['fechahasta'] = Variable<DateTime>(fechahasta.value);
    }
    if (rutaId.present) {
      map['ruta_id'] = Variable<int>(rutaId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (categoriaClienteId.present) {
      map['categoria_cliente_id'] = Variable<int>(categoriaClienteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromocionesCompanion(')
          ..write('idpromocion: $idpromocion, ')
          ..write('promocionpara: $promocionpara, ')
          ..write('promocionde: $promocionde, ')
          ..write('cantidadventa: $cantidadventa, ')
          ..write('cantidadsobreventa: $cantidadsobreventa, ')
          ..write('porcentajesobreventa: $porcentajesobreventa, ')
          ..write('fechadesde: $fechadesde, ')
          ..write('fechahasta: $fechahasta, ')
          ..write('rutaId: $rutaId, ')
          ..write('productoId: $productoId, ')
          ..write('categoriaClienteId: $categoriaClienteId')
          ..write(')'))
        .toString();
  }
}

class $PromocionesClientesTable extends PromocionesClientes
    with TableInfo<$PromocionesClientesTable, PromocionCliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromocionesClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _promocionIdMeta = const VerificationMeta(
    'promocionId',
  );
  @override
  late final GeneratedColumn<int> promocionId = GeneratedColumn<int>(
    'promocion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES promociones (idpromocion)',
    ),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, promocionId, clienteId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promociones_clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PromocionCliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('promocion_id')) {
      context.handle(
        _promocionIdMeta,
        promocionId.isAcceptableOrUnknown(
          data['promocion_id']!,
          _promocionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_promocionIdMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {promocionId, clienteId},
  ];
  @override
  PromocionCliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromocionCliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      promocionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}promocion_id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
    );
  }

  @override
  $PromocionesClientesTable createAlias(String alias) {
    return $PromocionesClientesTable(attachedDatabase, alias);
  }
}

class PromocionCliente extends DataClass
    implements Insertable<PromocionCliente> {
  final int id;
  final int promocionId;
  final int clienteId;
  const PromocionCliente({
    required this.id,
    required this.promocionId,
    required this.clienteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['promocion_id'] = Variable<int>(promocionId);
    map['cliente_id'] = Variable<int>(clienteId);
    return map;
  }

  PromocionesClientesCompanion toCompanion(bool nullToAbsent) {
    return PromocionesClientesCompanion(
      id: Value(id),
      promocionId: Value(promocionId),
      clienteId: Value(clienteId),
    );
  }

  factory PromocionCliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromocionCliente(
      id: serializer.fromJson<int>(json['id']),
      promocionId: serializer.fromJson<int>(json['promocionId']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'promocionId': serializer.toJson<int>(promocionId),
      'clienteId': serializer.toJson<int>(clienteId),
    };
  }

  PromocionCliente copyWith({int? id, int? promocionId, int? clienteId}) =>
      PromocionCliente(
        id: id ?? this.id,
        promocionId: promocionId ?? this.promocionId,
        clienteId: clienteId ?? this.clienteId,
      );
  PromocionCliente copyWithCompanion(PromocionesClientesCompanion data) {
    return PromocionCliente(
      id: data.id.present ? data.id.value : this.id,
      promocionId: data.promocionId.present
          ? data.promocionId.value
          : this.promocionId,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromocionCliente(')
          ..write('id: $id, ')
          ..write('promocionId: $promocionId, ')
          ..write('clienteId: $clienteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, promocionId, clienteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromocionCliente &&
          other.id == this.id &&
          other.promocionId == this.promocionId &&
          other.clienteId == this.clienteId);
}

class PromocionesClientesCompanion extends UpdateCompanion<PromocionCliente> {
  final Value<int> id;
  final Value<int> promocionId;
  final Value<int> clienteId;
  const PromocionesClientesCompanion({
    this.id = const Value.absent(),
    this.promocionId = const Value.absent(),
    this.clienteId = const Value.absent(),
  });
  PromocionesClientesCompanion.insert({
    this.id = const Value.absent(),
    required int promocionId,
    required int clienteId,
  }) : promocionId = Value(promocionId),
       clienteId = Value(clienteId);
  static Insertable<PromocionCliente> custom({
    Expression<int>? id,
    Expression<int>? promocionId,
    Expression<int>? clienteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (promocionId != null) 'promocion_id': promocionId,
      if (clienteId != null) 'cliente_id': clienteId,
    });
  }

  PromocionesClientesCompanion copyWith({
    Value<int>? id,
    Value<int>? promocionId,
    Value<int>? clienteId,
  }) {
    return PromocionesClientesCompanion(
      id: id ?? this.id,
      promocionId: promocionId ?? this.promocionId,
      clienteId: clienteId ?? this.clienteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (promocionId.present) {
      map['promocion_id'] = Variable<int>(promocionId.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromocionesClientesCompanion(')
          ..write('id: $id, ')
          ..write('promocionId: $promocionId, ')
          ..write('clienteId: $clienteId')
          ..write(')'))
        .toString();
  }
}

class $VentasTable extends Ventas with TableInfo<$VentasTable, Venta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idBackendMeta = const VerificationMeta(
    'idBackend',
  );
  @override
  late final GeneratedColumn<int> idBackend = GeneratedColumn<int>(
    'id_backend',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consecutivoMeta = const VerificationMeta(
    'consecutivo',
  );
  @override
  late final GeneratedColumn<int> consecutivo = GeneratedColumn<int>(
    'consecutivo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  static const VerificationMeta _vendedorIdMeta = const VerificationMeta(
    'vendedorId',
  );
  @override
  late final GeneratedColumn<int> vendedorId = GeneratedColumn<int>(
    'vendedor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutaIdMeta = const VerificationMeta('rutaId');
  @override
  late final GeneratedColumn<int> rutaId = GeneratedColumn<int>(
    'ruta_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rutas (id_ruta)',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sincronizadoMeta = const VerificationMeta(
    'sincronizado',
  );
  @override
  late final GeneratedColumn<bool> sincronizado = GeneratedColumn<bool>(
    'sincronizado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sincronizado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fechaSincronizacionMeta =
      const VerificationMeta('fechaSincronizacion');
  @override
  late final GeneratedColumn<DateTime> fechaSincronizacion =
      GeneratedColumn<DateTime>(
        'fecha_sincronizacion',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idBackend,
    consecutivo,
    clienteId,
    vendedorId,
    rutaId,
    fecha,
    total,
    sincronizado,
    fechaSincronizacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Venta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_backend')) {
      context.handle(
        _idBackendMeta,
        idBackend.isAcceptableOrUnknown(data['id_backend']!, _idBackendMeta),
      );
    }
    if (data.containsKey('consecutivo')) {
      context.handle(
        _consecutivoMeta,
        consecutivo.isAcceptableOrUnknown(
          data['consecutivo']!,
          _consecutivoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consecutivoMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('vendedor_id')) {
      context.handle(
        _vendedorIdMeta,
        vendedorId.isAcceptableOrUnknown(data['vendedor_id']!, _vendedorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendedorIdMeta);
    }
    if (data.containsKey('ruta_id')) {
      context.handle(
        _rutaIdMeta,
        rutaId.isAcceptableOrUnknown(data['ruta_id']!, _rutaIdMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('sincronizado')) {
      context.handle(
        _sincronizadoMeta,
        sincronizado.isAcceptableOrUnknown(
          data['sincronizado']!,
          _sincronizadoMeta,
        ),
      );
    }
    if (data.containsKey('fecha_sincronizacion')) {
      context.handle(
        _fechaSincronizacionMeta,
        fechaSincronizacion.isAcceptableOrUnknown(
          data['fecha_sincronizacion']!,
          _fechaSincronizacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Venta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Venta(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idBackend: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_backend'],
      ),
      consecutivo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutivo'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      vendedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vendedor_id'],
      )!,
      rutaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ruta_id'],
      ),
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      sincronizado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sincronizado'],
      )!,
      fechaSincronizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_sincronizacion'],
      ),
    );
  }

  @override
  $VentasTable createAlias(String alias) {
    return $VentasTable(attachedDatabase, alias);
  }
}

class Venta extends DataClass implements Insertable<Venta> {
  final int id;
  final int? idBackend;
  final int consecutivo;
  final int clienteId;
  final int vendedorId;
  final int? rutaId;
  final DateTime fecha;
  final double total;
  final bool sincronizado;
  final DateTime? fechaSincronizacion;
  const Venta({
    required this.id,
    this.idBackend,
    required this.consecutivo,
    required this.clienteId,
    required this.vendedorId,
    this.rutaId,
    required this.fecha,
    required this.total,
    required this.sincronizado,
    this.fechaSincronizacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || idBackend != null) {
      map['id_backend'] = Variable<int>(idBackend);
    }
    map['consecutivo'] = Variable<int>(consecutivo);
    map['cliente_id'] = Variable<int>(clienteId);
    map['vendedor_id'] = Variable<int>(vendedorId);
    if (!nullToAbsent || rutaId != null) {
      map['ruta_id'] = Variable<int>(rutaId);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    map['total'] = Variable<double>(total);
    map['sincronizado'] = Variable<bool>(sincronizado);
    if (!nullToAbsent || fechaSincronizacion != null) {
      map['fecha_sincronizacion'] = Variable<DateTime>(fechaSincronizacion);
    }
    return map;
  }

  VentasCompanion toCompanion(bool nullToAbsent) {
    return VentasCompanion(
      id: Value(id),
      idBackend: idBackend == null && nullToAbsent
          ? const Value.absent()
          : Value(idBackend),
      consecutivo: Value(consecutivo),
      clienteId: Value(clienteId),
      vendedorId: Value(vendedorId),
      rutaId: rutaId == null && nullToAbsent
          ? const Value.absent()
          : Value(rutaId),
      fecha: Value(fecha),
      total: Value(total),
      sincronizado: Value(sincronizado),
      fechaSincronizacion: fechaSincronizacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaSincronizacion),
    );
  }

  factory Venta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Venta(
      id: serializer.fromJson<int>(json['id']),
      idBackend: serializer.fromJson<int?>(json['idBackend']),
      consecutivo: serializer.fromJson<int>(json['consecutivo']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      vendedorId: serializer.fromJson<int>(json['vendedorId']),
      rutaId: serializer.fromJson<int?>(json['rutaId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      total: serializer.fromJson<double>(json['total']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      fechaSincronizacion: serializer.fromJson<DateTime?>(
        json['fechaSincronizacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idBackend': serializer.toJson<int?>(idBackend),
      'consecutivo': serializer.toJson<int>(consecutivo),
      'clienteId': serializer.toJson<int>(clienteId),
      'vendedorId': serializer.toJson<int>(vendedorId),
      'rutaId': serializer.toJson<int?>(rutaId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'total': serializer.toJson<double>(total),
      'sincronizado': serializer.toJson<bool>(sincronizado),
      'fechaSincronizacion': serializer.toJson<DateTime?>(fechaSincronizacion),
    };
  }

  Venta copyWith({
    int? id,
    Value<int?> idBackend = const Value.absent(),
    int? consecutivo,
    int? clienteId,
    int? vendedorId,
    Value<int?> rutaId = const Value.absent(),
    DateTime? fecha,
    double? total,
    bool? sincronizado,
    Value<DateTime?> fechaSincronizacion = const Value.absent(),
  }) => Venta(
    id: id ?? this.id,
    idBackend: idBackend.present ? idBackend.value : this.idBackend,
    consecutivo: consecutivo ?? this.consecutivo,
    clienteId: clienteId ?? this.clienteId,
    vendedorId: vendedorId ?? this.vendedorId,
    rutaId: rutaId.present ? rutaId.value : this.rutaId,
    fecha: fecha ?? this.fecha,
    total: total ?? this.total,
    sincronizado: sincronizado ?? this.sincronizado,
    fechaSincronizacion: fechaSincronizacion.present
        ? fechaSincronizacion.value
        : this.fechaSincronizacion,
  );
  Venta copyWithCompanion(VentasCompanion data) {
    return Venta(
      id: data.id.present ? data.id.value : this.id,
      idBackend: data.idBackend.present ? data.idBackend.value : this.idBackend,
      consecutivo: data.consecutivo.present
          ? data.consecutivo.value
          : this.consecutivo,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      vendedorId: data.vendedorId.present
          ? data.vendedorId.value
          : this.vendedorId,
      rutaId: data.rutaId.present ? data.rutaId.value : this.rutaId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      total: data.total.present ? data.total.value : this.total,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      fechaSincronizacion: data.fechaSincronizacion.present
          ? data.fechaSincronizacion.value
          : this.fechaSincronizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Venta(')
          ..write('id: $id, ')
          ..write('idBackend: $idBackend, ')
          ..write('consecutivo: $consecutivo, ')
          ..write('clienteId: $clienteId, ')
          ..write('vendedorId: $vendedorId, ')
          ..write('rutaId: $rutaId, ')
          ..write('fecha: $fecha, ')
          ..write('total: $total, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('fechaSincronizacion: $fechaSincronizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idBackend,
    consecutivo,
    clienteId,
    vendedorId,
    rutaId,
    fecha,
    total,
    sincronizado,
    fechaSincronizacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Venta &&
          other.id == this.id &&
          other.idBackend == this.idBackend &&
          other.consecutivo == this.consecutivo &&
          other.clienteId == this.clienteId &&
          other.vendedorId == this.vendedorId &&
          other.rutaId == this.rutaId &&
          other.fecha == this.fecha &&
          other.total == this.total &&
          other.sincronizado == this.sincronizado &&
          other.fechaSincronizacion == this.fechaSincronizacion);
}

class VentasCompanion extends UpdateCompanion<Venta> {
  final Value<int> id;
  final Value<int?> idBackend;
  final Value<int> consecutivo;
  final Value<int> clienteId;
  final Value<int> vendedorId;
  final Value<int?> rutaId;
  final Value<DateTime> fecha;
  final Value<double> total;
  final Value<bool> sincronizado;
  final Value<DateTime?> fechaSincronizacion;
  const VentasCompanion({
    this.id = const Value.absent(),
    this.idBackend = const Value.absent(),
    this.consecutivo = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.vendedorId = const Value.absent(),
    this.rutaId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.total = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.fechaSincronizacion = const Value.absent(),
  });
  VentasCompanion.insert({
    this.id = const Value.absent(),
    this.idBackend = const Value.absent(),
    required int consecutivo,
    required int clienteId,
    required int vendedorId,
    this.rutaId = const Value.absent(),
    this.fecha = const Value.absent(),
    required double total,
    this.sincronizado = const Value.absent(),
    this.fechaSincronizacion = const Value.absent(),
  }) : consecutivo = Value(consecutivo),
       clienteId = Value(clienteId),
       vendedorId = Value(vendedorId),
       total = Value(total);
  static Insertable<Venta> custom({
    Expression<int>? id,
    Expression<int>? idBackend,
    Expression<int>? consecutivo,
    Expression<int>? clienteId,
    Expression<int>? vendedorId,
    Expression<int>? rutaId,
    Expression<DateTime>? fecha,
    Expression<double>? total,
    Expression<bool>? sincronizado,
    Expression<DateTime>? fechaSincronizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idBackend != null) 'id_backend': idBackend,
      if (consecutivo != null) 'consecutivo': consecutivo,
      if (clienteId != null) 'cliente_id': clienteId,
      if (vendedorId != null) 'vendedor_id': vendedorId,
      if (rutaId != null) 'ruta_id': rutaId,
      if (fecha != null) 'fecha': fecha,
      if (total != null) 'total': total,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (fechaSincronizacion != null)
        'fecha_sincronizacion': fechaSincronizacion,
    });
  }

  VentasCompanion copyWith({
    Value<int>? id,
    Value<int?>? idBackend,
    Value<int>? consecutivo,
    Value<int>? clienteId,
    Value<int>? vendedorId,
    Value<int?>? rutaId,
    Value<DateTime>? fecha,
    Value<double>? total,
    Value<bool>? sincronizado,
    Value<DateTime?>? fechaSincronizacion,
  }) {
    return VentasCompanion(
      id: id ?? this.id,
      idBackend: idBackend ?? this.idBackend,
      consecutivo: consecutivo ?? this.consecutivo,
      clienteId: clienteId ?? this.clienteId,
      vendedorId: vendedorId ?? this.vendedorId,
      rutaId: rutaId ?? this.rutaId,
      fecha: fecha ?? this.fecha,
      total: total ?? this.total,
      sincronizado: sincronizado ?? this.sincronizado,
      fechaSincronizacion: fechaSincronizacion ?? this.fechaSincronizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idBackend.present) {
      map['id_backend'] = Variable<int>(idBackend.value);
    }
    if (consecutivo.present) {
      map['consecutivo'] = Variable<int>(consecutivo.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (vendedorId.present) {
      map['vendedor_id'] = Variable<int>(vendedorId.value);
    }
    if (rutaId.present) {
      map['ruta_id'] = Variable<int>(rutaId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (sincronizado.present) {
      map['sincronizado'] = Variable<bool>(sincronizado.value);
    }
    if (fechaSincronizacion.present) {
      map['fecha_sincronizacion'] = Variable<DateTime>(
        fechaSincronizacion.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasCompanion(')
          ..write('id: $id, ')
          ..write('idBackend: $idBackend, ')
          ..write('consecutivo: $consecutivo, ')
          ..write('clienteId: $clienteId, ')
          ..write('vendedorId: $vendedorId, ')
          ..write('rutaId: $rutaId, ')
          ..write('fecha: $fecha, ')
          ..write('total: $total, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('fechaSincronizacion: $fechaSincronizacion')
          ..write(')'))
        .toString();
  }
}

class $VentasDetalleTable extends VentasDetalle
    with TableInfo<$VentasDetalleTable, VentaDetalle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasDetalleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  @override
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ventas (id)',
    ),
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id)',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _porcentajeIvaMeta = const VerificationMeta(
    'porcentajeIva',
  );
  @override
  late final GeneratedColumn<int> porcentajeIva = GeneratedColumn<int>(
    'porcentaje_iva',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _promocionIdMeta = const VerificationMeta(
    'promocionId',
  );
  @override
  late final GeneratedColumn<int> promocionId = GeneratedColumn<int>(
    'promocion_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES promociones (idpromocion)',
    ),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ventaId,
    productoId,
    cantidad,
    precioUnitario,
    porcentajeIva,
    promocionId,
    subtotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas_detalle';
  @override
  VerificationContext validateIntegrity(
    Insertable<VentaDetalle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('porcentaje_iva')) {
      context.handle(
        _porcentajeIvaMeta,
        porcentajeIva.isAcceptableOrUnknown(
          data['porcentaje_iva']!,
          _porcentajeIvaMeta,
        ),
      );
    }
    if (data.containsKey('promocion_id')) {
      context.handle(
        _promocionIdMeta,
        promocionId.isAcceptableOrUnknown(
          data['promocion_id']!,
          _promocionIdMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VentaDetalle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VentaDetalle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      porcentajeIva: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}porcentaje_iva'],
      )!,
      promocionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}promocion_id'],
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
    );
  }

  @override
  $VentasDetalleTable createAlias(String alias) {
    return $VentasDetalleTable(attachedDatabase, alias);
  }
}

class VentaDetalle extends DataClass implements Insertable<VentaDetalle> {
  final int id;
  final int ventaId;
  final int productoId;
  final int cantidad;
  final double precioUnitario;
  final int porcentajeIva;
  final int? promocionId;
  final double subtotal;
  const VentaDetalle({
    required this.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.porcentajeIva,
    this.promocionId,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['venta_id'] = Variable<int>(ventaId);
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['porcentaje_iva'] = Variable<int>(porcentajeIva);
    if (!nullToAbsent || promocionId != null) {
      map['promocion_id'] = Variable<int>(promocionId);
    }
    map['subtotal'] = Variable<double>(subtotal);
    return map;
  }

  VentasDetalleCompanion toCompanion(bool nullToAbsent) {
    return VentasDetalleCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      productoId: Value(productoId),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
      porcentajeIva: Value(porcentajeIva),
      promocionId: promocionId == null && nullToAbsent
          ? const Value.absent()
          : Value(promocionId),
      subtotal: Value(subtotal),
    );
  }

  factory VentaDetalle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VentaDetalle(
      id: serializer.fromJson<int>(json['id']),
      ventaId: serializer.fromJson<int>(json['ventaId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      porcentajeIva: serializer.fromJson<int>(json['porcentajeIva']),
      promocionId: serializer.fromJson<int?>(json['promocionId']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ventaId': serializer.toJson<int>(ventaId),
      'productoId': serializer.toJson<int>(productoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'porcentajeIva': serializer.toJson<int>(porcentajeIva),
      'promocionId': serializer.toJson<int?>(promocionId),
      'subtotal': serializer.toJson<double>(subtotal),
    };
  }

  VentaDetalle copyWith({
    int? id,
    int? ventaId,
    int? productoId,
    int? cantidad,
    double? precioUnitario,
    int? porcentajeIva,
    Value<int?> promocionId = const Value.absent(),
    double? subtotal,
  }) => VentaDetalle(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    productoId: productoId ?? this.productoId,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    porcentajeIva: porcentajeIva ?? this.porcentajeIva,
    promocionId: promocionId.present ? promocionId.value : this.promocionId,
    subtotal: subtotal ?? this.subtotal,
  );
  VentaDetalle copyWithCompanion(VentasDetalleCompanion data) {
    return VentaDetalle(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      porcentajeIva: data.porcentajeIva.present
          ? data.porcentajeIva.value
          : this.porcentajeIva,
      promocionId: data.promocionId.present
          ? data.promocionId.value
          : this.promocionId,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VentaDetalle(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('porcentajeIva: $porcentajeIva, ')
          ..write('promocionId: $promocionId, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ventaId,
    productoId,
    cantidad,
    precioUnitario,
    porcentajeIva,
    promocionId,
    subtotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VentaDetalle &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.productoId == this.productoId &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.porcentajeIva == this.porcentajeIva &&
          other.promocionId == this.promocionId &&
          other.subtotal == this.subtotal);
}

class VentasDetalleCompanion extends UpdateCompanion<VentaDetalle> {
  final Value<int> id;
  final Value<int> ventaId;
  final Value<int> productoId;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<int> porcentajeIva;
  final Value<int?> promocionId;
  final Value<double> subtotal;
  const VentasDetalleCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.porcentajeIva = const Value.absent(),
    this.promocionId = const Value.absent(),
    this.subtotal = const Value.absent(),
  });
  VentasDetalleCompanion.insert({
    this.id = const Value.absent(),
    required int ventaId,
    required int productoId,
    required int cantidad,
    required double precioUnitario,
    this.porcentajeIva = const Value.absent(),
    this.promocionId = const Value.absent(),
    required double subtotal,
  }) : ventaId = Value(ventaId),
       productoId = Value(productoId),
       cantidad = Value(cantidad),
       precioUnitario = Value(precioUnitario),
       subtotal = Value(subtotal);
  static Insertable<VentaDetalle> custom({
    Expression<int>? id,
    Expression<int>? ventaId,
    Expression<int>? productoId,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
    Expression<int>? porcentajeIva,
    Expression<int>? promocionId,
    Expression<double>? subtotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (productoId != null) 'producto_id': productoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (porcentajeIva != null) 'porcentaje_iva': porcentajeIva,
      if (promocionId != null) 'promocion_id': promocionId,
      if (subtotal != null) 'subtotal': subtotal,
    });
  }

  VentasDetalleCompanion copyWith({
    Value<int>? id,
    Value<int>? ventaId,
    Value<int>? productoId,
    Value<int>? cantidad,
    Value<double>? precioUnitario,
    Value<int>? porcentajeIva,
    Value<int?>? promocionId,
    Value<double>? subtotal,
  }) {
    return VentasDetalleCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      porcentajeIva: porcentajeIva ?? this.porcentajeIva,
      promocionId: promocionId ?? this.promocionId,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (porcentajeIva.present) {
      map['porcentaje_iva'] = Variable<int>(porcentajeIva.value);
    }
    if (promocionId.present) {
      map['promocion_id'] = Variable<int>(promocionId.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasDetalleCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('porcentajeIva: $porcentajeIva, ')
          ..write('promocionId: $promocionId, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }
}

class $VentasFormasPagoTable extends VentasFormasPago
    with TableInfo<$VentasFormasPagoTable, VentaFormaPago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasFormasPagoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  @override
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ventas (id)',
    ),
  );
  static const VerificationMeta _formaPagoIdMeta = const VerificationMeta(
    'formaPagoId',
  );
  @override
  late final GeneratedColumn<int> formaPagoId = GeneratedColumn<int>(
    'forma_pago_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES forma_pago (idformapago)',
    ),
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, ventaId, formaPagoId, monto];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas_formas_pago';
  @override
  VerificationContext validateIntegrity(
    Insertable<VentaFormaPago> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('forma_pago_id')) {
      context.handle(
        _formaPagoIdMeta,
        formaPagoId.isAcceptableOrUnknown(
          data['forma_pago_id']!,
          _formaPagoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_formaPagoIdMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VentaFormaPago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VentaFormaPago(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      )!,
      formaPagoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}forma_pago_id'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
    );
  }

  @override
  $VentasFormasPagoTable createAlias(String alias) {
    return $VentasFormasPagoTable(attachedDatabase, alias);
  }
}

class VentaFormaPago extends DataClass implements Insertable<VentaFormaPago> {
  final int id;
  final int ventaId;
  final int formaPagoId;
  final double monto;
  const VentaFormaPago({
    required this.id,
    required this.ventaId,
    required this.formaPagoId,
    required this.monto,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['venta_id'] = Variable<int>(ventaId);
    map['forma_pago_id'] = Variable<int>(formaPagoId);
    map['monto'] = Variable<double>(monto);
    return map;
  }

  VentasFormasPagoCompanion toCompanion(bool nullToAbsent) {
    return VentasFormasPagoCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      formaPagoId: Value(formaPagoId),
      monto: Value(monto),
    );
  }

  factory VentaFormaPago.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VentaFormaPago(
      id: serializer.fromJson<int>(json['id']),
      ventaId: serializer.fromJson<int>(json['ventaId']),
      formaPagoId: serializer.fromJson<int>(json['formaPagoId']),
      monto: serializer.fromJson<double>(json['monto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ventaId': serializer.toJson<int>(ventaId),
      'formaPagoId': serializer.toJson<int>(formaPagoId),
      'monto': serializer.toJson<double>(monto),
    };
  }

  VentaFormaPago copyWith({
    int? id,
    int? ventaId,
    int? formaPagoId,
    double? monto,
  }) => VentaFormaPago(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    formaPagoId: formaPagoId ?? this.formaPagoId,
    monto: monto ?? this.monto,
  );
  VentaFormaPago copyWithCompanion(VentasFormasPagoCompanion data) {
    return VentaFormaPago(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      formaPagoId: data.formaPagoId.present
          ? data.formaPagoId.value
          : this.formaPagoId,
      monto: data.monto.present ? data.monto.value : this.monto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VentaFormaPago(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('formaPagoId: $formaPagoId, ')
          ..write('monto: $monto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ventaId, formaPagoId, monto);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VentaFormaPago &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.formaPagoId == this.formaPagoId &&
          other.monto == this.monto);
}

class VentasFormasPagoCompanion extends UpdateCompanion<VentaFormaPago> {
  final Value<int> id;
  final Value<int> ventaId;
  final Value<int> formaPagoId;
  final Value<double> monto;
  const VentasFormasPagoCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.formaPagoId = const Value.absent(),
    this.monto = const Value.absent(),
  });
  VentasFormasPagoCompanion.insert({
    this.id = const Value.absent(),
    required int ventaId,
    required int formaPagoId,
    required double monto,
  }) : ventaId = Value(ventaId),
       formaPagoId = Value(formaPagoId),
       monto = Value(monto);
  static Insertable<VentaFormaPago> custom({
    Expression<int>? id,
    Expression<int>? ventaId,
    Expression<int>? formaPagoId,
    Expression<double>? monto,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (formaPagoId != null) 'forma_pago_id': formaPagoId,
      if (monto != null) 'monto': monto,
    });
  }

  VentasFormasPagoCompanion copyWith({
    Value<int>? id,
    Value<int>? ventaId,
    Value<int>? formaPagoId,
    Value<double>? monto,
  }) {
    return VentasFormasPagoCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      formaPagoId: formaPagoId ?? this.formaPagoId,
      monto: monto ?? this.monto,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (formaPagoId.present) {
      map['forma_pago_id'] = Variable<int>(formaPagoId.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasFormasPagoCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('formaPagoId: $formaPagoId, ')
          ..write('monto: $monto')
          ..write(')'))
        .toString();
  }
}

class $SyncInventarioTable extends SyncInventario
    with TableInfo<$SyncInventarioTable, SyncInventarioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncInventarioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sincronizadoMeta = const VerificationMeta(
    'sincronizado',
  );
  @override
  late final GeneratedColumn<bool> sincronizado = GeneratedColumn<bool>(
    'sincronizado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sincronizado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, sincronizado];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'syncInventario';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncInventarioData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sincronizado')) {
      context.handle(
        _sincronizadoMeta,
        sincronizado.isAcceptableOrUnknown(
          data['sincronizado']!,
          _sincronizadoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncInventarioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncInventarioData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sincronizado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sincronizado'],
      )!,
    );
  }

  @override
  $SyncInventarioTable createAlias(String alias) {
    return $SyncInventarioTable(attachedDatabase, alias);
  }
}

class SyncInventarioData extends DataClass
    implements Insertable<SyncInventarioData> {
  final int id;
  final bool sincronizado;
  const SyncInventarioData({required this.id, required this.sincronizado});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sincronizado'] = Variable<bool>(sincronizado);
    return map;
  }

  SyncInventarioCompanion toCompanion(bool nullToAbsent) {
    return SyncInventarioCompanion(
      id: Value(id),
      sincronizado: Value(sincronizado),
    );
  }

  factory SyncInventarioData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncInventarioData(
      id: serializer.fromJson<int>(json['id']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sincronizado': serializer.toJson<bool>(sincronizado),
    };
  }

  SyncInventarioData copyWith({int? id, bool? sincronizado}) =>
      SyncInventarioData(
        id: id ?? this.id,
        sincronizado: sincronizado ?? this.sincronizado,
      );
  SyncInventarioData copyWithCompanion(SyncInventarioCompanion data) {
    return SyncInventarioData(
      id: data.id.present ? data.id.value : this.id,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncInventarioData(')
          ..write('id: $id, ')
          ..write('sincronizado: $sincronizado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sincronizado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncInventarioData &&
          other.id == this.id &&
          other.sincronizado == this.sincronizado);
}

class SyncInventarioCompanion extends UpdateCompanion<SyncInventarioData> {
  final Value<int> id;
  final Value<bool> sincronizado;
  const SyncInventarioCompanion({
    this.id = const Value.absent(),
    this.sincronizado = const Value.absent(),
  });
  SyncInventarioCompanion.insert({
    this.id = const Value.absent(),
    this.sincronizado = const Value.absent(),
  });
  static Insertable<SyncInventarioData> custom({
    Expression<int>? id,
    Expression<bool>? sincronizado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sincronizado != null) 'sincronizado': sincronizado,
    });
  }

  SyncInventarioCompanion copyWith({
    Value<int>? id,
    Value<bool>? sincronizado,
  }) {
    return SyncInventarioCompanion(
      id: id ?? this.id,
      sincronizado: sincronizado ?? this.sincronizado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sincronizado.present) {
      map['sincronizado'] = Variable<bool>(sincronizado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncInventarioCompanion(')
          ..write('id: $id, ')
          ..write('sincronizado: $sincronizado')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $CategoriasClienteTable categoriasCliente =
      $CategoriasClienteTable(this);
  late final $TiposDocumentoTable tiposDocumento = $TiposDocumentoTable(this);
  late final $FormasPagoTable formasPago = $FormasPagoTable(this);
  late final $RutasTable rutas = $RutasTable(this);
  late final $CiudadesTable ciudades = $CiudadesTable(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $PreciosTable precios = $PreciosTable(this);
  late final $PromocionesTable promociones = $PromocionesTable(this);
  late final $PromocionesClientesTable promocionesClientes =
      $PromocionesClientesTable(this);
  late final $VentasTable ventas = $VentasTable(this);
  late final $VentasDetalleTable ventasDetalle = $VentasDetalleTable(this);
  late final $VentasFormasPagoTable ventasFormasPago = $VentasFormasPagoTable(
    this,
  );
  late final $SyncInventarioTable syncInventario = $SyncInventarioTable(this);
  late final CatalogosDao catalogosDao = CatalogosDao(this as AppDatabase);
  late final ClientesDao clientesDao = ClientesDao(this as AppDatabase);
  late final PreciosDao preciosDao = PreciosDao(this as AppDatabase);
  late final PromocionesDao promocionesDao = PromocionesDao(
    this as AppDatabase,
  );
  late final VentasDao ventasDao = VentasDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productos,
    categoriasCliente,
    tiposDocumento,
    formasPago,
    rutas,
    ciudades,
    clientes,
    precios,
    promociones,
    promocionesClientes,
    ventas,
    ventasDetalle,
    ventasFormasPago,
    syncInventario,
  ];
}

typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      required String nombre,
      required int cantidad,
      required int porcentajeiva,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<int> cantidad,
      Value<int> porcentajeiva,
    });

final class $$ProductosTableReferences
    extends BaseReferences<_$AppDatabase, $ProductosTable, Producto> {
  $$ProductosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PreciosTable, List<Precio>> _preciosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.precios,
    aliasName: 'productos__id__precios__producto_id',
  );

  $$PreciosTableProcessedTableManager get preciosRefs {
    final manager = $$PreciosTableTableManager(
      $_db,
      $_db.precios,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_preciosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PromocionesTable, List<Promocion>>
  _promocionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.promociones,
    aliasName: 'productos__id__promociones__producto_id',
  );

  $$PromocionesTableProcessedTableManager get promocionesRefs {
    final manager = $$PromocionesTableTableManager(
      $_db,
      $_db.promociones,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_promocionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VentasDetalleTable, List<VentaDetalle>>
  _ventasDetalleRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ventasDetalle,
    aliasName: 'productos__id__ventas_detalle__producto_id',
  );

  $$VentasDetalleTableProcessedTableManager get ventasDetalleRefs {
    final manager = $$VentasDetalleTableTableManager(
      $_db,
      $_db.ventasDetalle,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventasDetalleRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get porcentajeiva => $composableBuilder(
    column: $table.porcentajeiva,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> preciosRefs(
    Expression<bool> Function($$PreciosTableFilterComposer f) f,
  ) {
    final $$PreciosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.precios,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreciosTableFilterComposer(
            $db: $db,
            $table: $db.precios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> promocionesRefs(
    Expression<bool> Function($$PromocionesTableFilterComposer f) f,
  ) {
    final $$PromocionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableFilterComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventasDetalleRefs(
    Expression<bool> Function($$VentasDetalleTableFilterComposer f) f,
  ) {
    final $$VentasDetalleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableFilterComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get porcentajeiva => $composableBuilder(
    column: $table.porcentajeiva,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<int> get porcentajeiva => $composableBuilder(
    column: $table.porcentajeiva,
    builder: (column) => column,
  );

  Expression<T> preciosRefs<T extends Object>(
    Expression<T> Function($$PreciosTableAnnotationComposer a) f,
  ) {
    final $$PreciosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.precios,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreciosTableAnnotationComposer(
            $db: $db,
            $table: $db.precios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> promocionesRefs<T extends Object>(
    Expression<T> Function($$PromocionesTableAnnotationComposer a) f,
  ) {
    final $$PromocionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableAnnotationComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ventasDetalleRefs<T extends Object>(
    Expression<T> Function($$VentasDetalleTableAnnotationComposer a) f,
  ) {
    final $$VentasDetalleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTable,
          Producto,
          $$ProductosTableFilterComposer,
          $$ProductosTableOrderingComposer,
          $$ProductosTableAnnotationComposer,
          $$ProductosTableCreateCompanionBuilder,
          $$ProductosTableUpdateCompanionBuilder,
          (Producto, $$ProductosTableReferences),
          Producto,
          PrefetchHooks Function({
            bool preciosRefs,
            bool promocionesRefs,
            bool ventasDetalleRefs,
          })
        > {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<int> porcentajeiva = const Value.absent(),
              }) => ProductosCompanion(
                id: id,
                nombre: nombre,
                cantidad: cantidad,
                porcentajeiva: porcentajeiva,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required int cantidad,
                required int porcentajeiva,
              }) => ProductosCompanion.insert(
                id: id,
                nombre: nombre,
                cantidad: cantidad,
                porcentajeiva: porcentajeiva,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                preciosRefs = false,
                promocionesRefs = false,
                ventasDetalleRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (preciosRefs) db.precios,
                    if (promocionesRefs) db.promociones,
                    if (ventasDetalleRefs) db.ventasDetalle,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (preciosRefs)
                        await $_getPrefetchedData<
                          Producto,
                          $ProductosTable,
                          Precio
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._preciosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).preciosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (promocionesRefs)
                        await $_getPrefetchedData<
                          Producto,
                          $ProductosTable,
                          Promocion
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._promocionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).promocionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ventasDetalleRefs)
                        await $_getPrefetchedData<
                          Producto,
                          $ProductosTable,
                          VentaDetalle
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._ventasDetalleRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasDetalleRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTable,
      Producto,
      $$ProductosTableFilterComposer,
      $$ProductosTableOrderingComposer,
      $$ProductosTableAnnotationComposer,
      $$ProductosTableCreateCompanionBuilder,
      $$ProductosTableUpdateCompanionBuilder,
      (Producto, $$ProductosTableReferences),
      Producto,
      PrefetchHooks Function({
        bool preciosRefs,
        bool promocionesRefs,
        bool ventasDetalleRefs,
      })
    >;
typedef $$CategoriasClienteTableCreateCompanionBuilder =
    CategoriasClienteCompanion Function({
      Value<int> id,
      required String nombre,
    });
typedef $$CategoriasClienteTableUpdateCompanionBuilder =
    CategoriasClienteCompanion Function({Value<int> id, Value<String> nombre});

final class $$CategoriasClienteTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoriasClienteTable,
          CategoriaCliente
        > {
  $$CategoriasClienteTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ClientesTable, List<Cliente>> _clientesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.clientes,
    aliasName: 'categorias_cliente__id__clientes__categoria_cliente_id',
  );

  $$ClientesTableProcessedTableManager get clientesRefs {
    final manager = $$ClientesTableTableManager($_db, $_db.clientes).filter(
      (f) => f.categoriaClienteId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_clientesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PreciosTable, List<Precio>> _preciosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.precios,
    aliasName: 'categorias_cliente__id__precios__categoria_cliente_id',
  );

  $$PreciosTableProcessedTableManager get preciosRefs {
    final manager = $$PreciosTableTableManager($_db, $_db.precios).filter(
      (f) => f.categoriaClienteId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_preciosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PromocionesTable, List<Promocion>>
  _promocionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.promociones,
    aliasName: 'categorias_cliente__id__promociones__categoria_cliente_id',
  );

  $$PromocionesTableProcessedTableManager get promocionesRefs {
    final manager = $$PromocionesTableTableManager($_db, $_db.promociones)
        .filter(
          (f) => f.categoriaClienteId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_promocionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasClienteTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasClienteTable> {
  $$CategoriasClienteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> clientesRefs(
    Expression<bool> Function($$ClientesTableFilterComposer f) f,
  ) {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.categoriaClienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> preciosRefs(
    Expression<bool> Function($$PreciosTableFilterComposer f) f,
  ) {
    final $$PreciosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.precios,
      getReferencedColumn: (t) => t.categoriaClienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreciosTableFilterComposer(
            $db: $db,
            $table: $db.precios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> promocionesRefs(
    Expression<bool> Function($$PromocionesTableFilterComposer f) f,
  ) {
    final $$PromocionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.categoriaClienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableFilterComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasClienteTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasClienteTable> {
  $$CategoriasClienteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasClienteTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasClienteTable> {
  $$CategoriasClienteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  Expression<T> clientesRefs<T extends Object>(
    Expression<T> Function($$ClientesTableAnnotationComposer a) f,
  ) {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.categoriaClienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> preciosRefs<T extends Object>(
    Expression<T> Function($$PreciosTableAnnotationComposer a) f,
  ) {
    final $$PreciosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.precios,
      getReferencedColumn: (t) => t.categoriaClienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreciosTableAnnotationComposer(
            $db: $db,
            $table: $db.precios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> promocionesRefs<T extends Object>(
    Expression<T> Function($$PromocionesTableAnnotationComposer a) f,
  ) {
    final $$PromocionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.categoriaClienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableAnnotationComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasClienteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasClienteTable,
          CategoriaCliente,
          $$CategoriasClienteTableFilterComposer,
          $$CategoriasClienteTableOrderingComposer,
          $$CategoriasClienteTableAnnotationComposer,
          $$CategoriasClienteTableCreateCompanionBuilder,
          $$CategoriasClienteTableUpdateCompanionBuilder,
          (CategoriaCliente, $$CategoriasClienteTableReferences),
          CategoriaCliente,
          PrefetchHooks Function({
            bool clientesRefs,
            bool preciosRefs,
            bool promocionesRefs,
          })
        > {
  $$CategoriasClienteTableTableManager(
    _$AppDatabase db,
    $CategoriasClienteTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasClienteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasClienteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasClienteTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
              }) => CategoriasClienteCompanion(id: id, nombre: nombre),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
              }) => CategoriasClienteCompanion.insert(id: id, nombre: nombre),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriasClienteTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clientesRefs = false,
                preciosRefs = false,
                promocionesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (clientesRefs) db.clientes,
                    if (preciosRefs) db.precios,
                    if (promocionesRefs) db.promociones,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (clientesRefs)
                        await $_getPrefetchedData<
                          CategoriaCliente,
                          $CategoriasClienteTable,
                          Cliente
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasClienteTableReferences
                              ._clientesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasClienteTableReferences(
                                db,
                                table,
                                p0,
                              ).clientesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaClienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (preciosRefs)
                        await $_getPrefetchedData<
                          CategoriaCliente,
                          $CategoriasClienteTable,
                          Precio
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasClienteTableReferences
                              ._preciosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasClienteTableReferences(
                                db,
                                table,
                                p0,
                              ).preciosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaClienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (promocionesRefs)
                        await $_getPrefetchedData<
                          CategoriaCliente,
                          $CategoriasClienteTable,
                          Promocion
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasClienteTableReferences
                              ._promocionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasClienteTableReferences(
                                db,
                                table,
                                p0,
                              ).promocionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaClienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriasClienteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasClienteTable,
      CategoriaCliente,
      $$CategoriasClienteTableFilterComposer,
      $$CategoriasClienteTableOrderingComposer,
      $$CategoriasClienteTableAnnotationComposer,
      $$CategoriasClienteTableCreateCompanionBuilder,
      $$CategoriasClienteTableUpdateCompanionBuilder,
      (CategoriaCliente, $$CategoriasClienteTableReferences),
      CategoriaCliente,
      PrefetchHooks Function({
        bool clientesRefs,
        bool preciosRefs,
        bool promocionesRefs,
      })
    >;
typedef $$TiposDocumentoTableCreateCompanionBuilder =
    TiposDocumentoCompanion Function({Value<int> id, required String nombre});
typedef $$TiposDocumentoTableUpdateCompanionBuilder =
    TiposDocumentoCompanion Function({Value<int> id, Value<String> nombre});

final class $$TiposDocumentoTableReferences
    extends BaseReferences<_$AppDatabase, $TiposDocumentoTable, TipoDocumento> {
  $$TiposDocumentoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ClientesTable, List<Cliente>> _clientesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.clientes,
    aliasName: 'tipos_documento__id__clientes__tipo_documento_id',
  );

  $$ClientesTableProcessedTableManager get clientesRefs {
    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.tipoDocumentoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_clientesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TiposDocumentoTableFilterComposer
    extends Composer<_$AppDatabase, $TiposDocumentoTable> {
  $$TiposDocumentoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> clientesRefs(
    Expression<bool> Function($$ClientesTableFilterComposer f) f,
  ) {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.tipoDocumentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TiposDocumentoTableOrderingComposer
    extends Composer<_$AppDatabase, $TiposDocumentoTable> {
  $$TiposDocumentoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TiposDocumentoTableAnnotationComposer
    extends Composer<_$AppDatabase, $TiposDocumentoTable> {
  $$TiposDocumentoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  Expression<T> clientesRefs<T extends Object>(
    Expression<T> Function($$ClientesTableAnnotationComposer a) f,
  ) {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.tipoDocumentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TiposDocumentoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TiposDocumentoTable,
          TipoDocumento,
          $$TiposDocumentoTableFilterComposer,
          $$TiposDocumentoTableOrderingComposer,
          $$TiposDocumentoTableAnnotationComposer,
          $$TiposDocumentoTableCreateCompanionBuilder,
          $$TiposDocumentoTableUpdateCompanionBuilder,
          (TipoDocumento, $$TiposDocumentoTableReferences),
          TipoDocumento,
          PrefetchHooks Function({bool clientesRefs})
        > {
  $$TiposDocumentoTableTableManager(
    _$AppDatabase db,
    $TiposDocumentoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TiposDocumentoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TiposDocumentoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TiposDocumentoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
              }) => TiposDocumentoCompanion(id: id, nombre: nombre),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
              }) => TiposDocumentoCompanion.insert(id: id, nombre: nombre),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TiposDocumentoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (clientesRefs) db.clientes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (clientesRefs)
                    await $_getPrefetchedData<
                      TipoDocumento,
                      $TiposDocumentoTable,
                      Cliente
                    >(
                      currentTable: table,
                      referencedTable: $$TiposDocumentoTableReferences
                          ._clientesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TiposDocumentoTableReferences(
                            db,
                            table,
                            p0,
                          ).clientesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.tipoDocumentoId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TiposDocumentoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TiposDocumentoTable,
      TipoDocumento,
      $$TiposDocumentoTableFilterComposer,
      $$TiposDocumentoTableOrderingComposer,
      $$TiposDocumentoTableAnnotationComposer,
      $$TiposDocumentoTableCreateCompanionBuilder,
      $$TiposDocumentoTableUpdateCompanionBuilder,
      (TipoDocumento, $$TiposDocumentoTableReferences),
      TipoDocumento,
      PrefetchHooks Function({bool clientesRefs})
    >;
typedef $$FormasPagoTableCreateCompanionBuilder =
    FormasPagoCompanion Function({
      Value<int> idformapago,
      required String nombreformapago,
    });
typedef $$FormasPagoTableUpdateCompanionBuilder =
    FormasPagoCompanion Function({
      Value<int> idformapago,
      Value<String> nombreformapago,
    });

final class $$FormasPagoTableReferences
    extends BaseReferences<_$AppDatabase, $FormasPagoTable, FormaPago> {
  $$FormasPagoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VentasFormasPagoTable, List<VentaFormaPago>>
  _ventasFormasPagoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ventasFormasPago,
    aliasName: 'forma_pago__idformapago__ventas_formas_pago__forma_pago_id',
  );

  $$VentasFormasPagoTableProcessedTableManager get ventasFormasPagoRefs {
    final manager =
        $$VentasFormasPagoTableTableManager($_db, $_db.ventasFormasPago).filter(
          (f) => f.formaPagoId.idformapago.sqlEquals(
            $_itemColumn<int>('idformapago')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _ventasFormasPagoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FormasPagoTableFilterComposer
    extends Composer<_$AppDatabase, $FormasPagoTable> {
  $$FormasPagoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idformapago => $composableBuilder(
    column: $table.idformapago,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreformapago => $composableBuilder(
    column: $table.nombreformapago,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ventasFormasPagoRefs(
    Expression<bool> Function($$VentasFormasPagoTableFilterComposer f) f,
  ) {
    final $$VentasFormasPagoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idformapago,
      referencedTable: $db.ventasFormasPago,
      getReferencedColumn: (t) => t.formaPagoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasFormasPagoTableFilterComposer(
            $db: $db,
            $table: $db.ventasFormasPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FormasPagoTableOrderingComposer
    extends Composer<_$AppDatabase, $FormasPagoTable> {
  $$FormasPagoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idformapago => $composableBuilder(
    column: $table.idformapago,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreformapago => $composableBuilder(
    column: $table.nombreformapago,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FormasPagoTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormasPagoTable> {
  $$FormasPagoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idformapago => $composableBuilder(
    column: $table.idformapago,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreformapago => $composableBuilder(
    column: $table.nombreformapago,
    builder: (column) => column,
  );

  Expression<T> ventasFormasPagoRefs<T extends Object>(
    Expression<T> Function($$VentasFormasPagoTableAnnotationComposer a) f,
  ) {
    final $$VentasFormasPagoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idformapago,
      referencedTable: $db.ventasFormasPago,
      getReferencedColumn: (t) => t.formaPagoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasFormasPagoTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasFormasPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FormasPagoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FormasPagoTable,
          FormaPago,
          $$FormasPagoTableFilterComposer,
          $$FormasPagoTableOrderingComposer,
          $$FormasPagoTableAnnotationComposer,
          $$FormasPagoTableCreateCompanionBuilder,
          $$FormasPagoTableUpdateCompanionBuilder,
          (FormaPago, $$FormasPagoTableReferences),
          FormaPago,
          PrefetchHooks Function({bool ventasFormasPagoRefs})
        > {
  $$FormasPagoTableTableManager(_$AppDatabase db, $FormasPagoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormasPagoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormasPagoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormasPagoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idformapago = const Value.absent(),
                Value<String> nombreformapago = const Value.absent(),
              }) => FormasPagoCompanion(
                idformapago: idformapago,
                nombreformapago: nombreformapago,
              ),
          createCompanionCallback:
              ({
                Value<int> idformapago = const Value.absent(),
                required String nombreformapago,
              }) => FormasPagoCompanion.insert(
                idformapago: idformapago,
                nombreformapago: nombreformapago,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FormasPagoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ventasFormasPagoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ventasFormasPagoRefs) db.ventasFormasPago,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ventasFormasPagoRefs)
                    await $_getPrefetchedData<
                      FormaPago,
                      $FormasPagoTable,
                      VentaFormaPago
                    >(
                      currentTable: table,
                      referencedTable: $$FormasPagoTableReferences
                          ._ventasFormasPagoRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FormasPagoTableReferences(
                            db,
                            table,
                            p0,
                          ).ventasFormasPagoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.formaPagoId == item.idformapago,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FormasPagoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FormasPagoTable,
      FormaPago,
      $$FormasPagoTableFilterComposer,
      $$FormasPagoTableOrderingComposer,
      $$FormasPagoTableAnnotationComposer,
      $$FormasPagoTableCreateCompanionBuilder,
      $$FormasPagoTableUpdateCompanionBuilder,
      (FormaPago, $$FormasPagoTableReferences),
      FormaPago,
      PrefetchHooks Function({bool ventasFormasPagoRefs})
    >;
typedef $$RutasTableCreateCompanionBuilder =
    RutasCompanion Function({
      Value<int> idRuta,
      required String nombre,
      required int idZona,
      required String nombrezona,
      required bool estado,
      required String nombreEstado,
    });
typedef $$RutasTableUpdateCompanionBuilder =
    RutasCompanion Function({
      Value<int> idRuta,
      Value<String> nombre,
      Value<int> idZona,
      Value<String> nombrezona,
      Value<bool> estado,
      Value<String> nombreEstado,
    });

final class $$RutasTableReferences
    extends BaseReferences<_$AppDatabase, $RutasTable, Ruta> {
  $$RutasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VentasTable, List<Venta>> _ventasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ventas,
    aliasName: 'rutas__id_ruta__ventas__ruta_id',
  );

  $$VentasTableProcessedTableManager get ventasRefs {
    final manager = $$VentasTableTableManager(
      $_db,
      $_db.ventas,
    ).filter((f) => f.rutaId.idRuta.sqlEquals($_itemColumn<int>('id_ruta')!));

    final cache = $_typedResult.readTableOrNull(_ventasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RutasTableFilterComposer extends Composer<_$AppDatabase, $RutasTable> {
  $$RutasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idRuta => $composableBuilder(
    column: $table.idRuta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idZona => $composableBuilder(
    column: $table.idZona,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombrezona => $composableBuilder(
    column: $table.nombrezona,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreEstado => $composableBuilder(
    column: $table.nombreEstado,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ventasRefs(
    Expression<bool> Function($$VentasTableFilterComposer f) f,
  ) {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRuta,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.rutaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RutasTableOrderingComposer
    extends Composer<_$AppDatabase, $RutasTable> {
  $$RutasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idRuta => $composableBuilder(
    column: $table.idRuta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idZona => $composableBuilder(
    column: $table.idZona,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombrezona => $composableBuilder(
    column: $table.nombrezona,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreEstado => $composableBuilder(
    column: $table.nombreEstado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RutasTableAnnotationComposer
    extends Composer<_$AppDatabase, $RutasTable> {
  $$RutasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idRuta =>
      $composableBuilder(column: $table.idRuta, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get idZona =>
      $composableBuilder(column: $table.idZona, builder: (column) => column);

  GeneratedColumn<String> get nombrezona => $composableBuilder(
    column: $table.nombrezona,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get nombreEstado => $composableBuilder(
    column: $table.nombreEstado,
    builder: (column) => column,
  );

  Expression<T> ventasRefs<T extends Object>(
    Expression<T> Function($$VentasTableAnnotationComposer a) f,
  ) {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRuta,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.rutaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RutasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RutasTable,
          Ruta,
          $$RutasTableFilterComposer,
          $$RutasTableOrderingComposer,
          $$RutasTableAnnotationComposer,
          $$RutasTableCreateCompanionBuilder,
          $$RutasTableUpdateCompanionBuilder,
          (Ruta, $$RutasTableReferences),
          Ruta,
          PrefetchHooks Function({bool ventasRefs})
        > {
  $$RutasTableTableManager(_$AppDatabase db, $RutasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RutasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RutasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RutasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idRuta = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> idZona = const Value.absent(),
                Value<String> nombrezona = const Value.absent(),
                Value<bool> estado = const Value.absent(),
                Value<String> nombreEstado = const Value.absent(),
              }) => RutasCompanion(
                idRuta: idRuta,
                nombre: nombre,
                idZona: idZona,
                nombrezona: nombrezona,
                estado: estado,
                nombreEstado: nombreEstado,
              ),
          createCompanionCallback:
              ({
                Value<int> idRuta = const Value.absent(),
                required String nombre,
                required int idZona,
                required String nombrezona,
                required bool estado,
                required String nombreEstado,
              }) => RutasCompanion.insert(
                idRuta: idRuta,
                nombre: nombre,
                idZona: idZona,
                nombrezona: nombrezona,
                estado: estado,
                nombreEstado: nombreEstado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RutasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({ventasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ventasRefs) db.ventas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ventasRefs)
                    await $_getPrefetchedData<Ruta, $RutasTable, Venta>(
                      currentTable: table,
                      referencedTable: $$RutasTableReferences._ventasRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$RutasTableReferences(db, table, p0).ventasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.rutaId == item.idRuta),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RutasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RutasTable,
      Ruta,
      $$RutasTableFilterComposer,
      $$RutasTableOrderingComposer,
      $$RutasTableAnnotationComposer,
      $$RutasTableCreateCompanionBuilder,
      $$RutasTableUpdateCompanionBuilder,
      (Ruta, $$RutasTableReferences),
      Ruta,
      PrefetchHooks Function({bool ventasRefs})
    >;
typedef $$CiudadesTableCreateCompanionBuilder =
    CiudadesCompanion Function({Value<int> id, required String nombre});
typedef $$CiudadesTableUpdateCompanionBuilder =
    CiudadesCompanion Function({Value<int> id, Value<String> nombre});

final class $$CiudadesTableReferences
    extends BaseReferences<_$AppDatabase, $CiudadesTable, Ciudad> {
  $$CiudadesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ClientesTable, List<Cliente>> _clientesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.clientes,
    aliasName: 'ciudades__id__clientes__ciudad_id',
  );

  $$ClientesTableProcessedTableManager get clientesRefs {
    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.ciudadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_clientesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CiudadesTableFilterComposer
    extends Composer<_$AppDatabase, $CiudadesTable> {
  $$CiudadesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> clientesRefs(
    Expression<bool> Function($$ClientesTableFilterComposer f) f,
  ) {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.ciudadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CiudadesTableOrderingComposer
    extends Composer<_$AppDatabase, $CiudadesTable> {
  $$CiudadesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CiudadesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CiudadesTable> {
  $$CiudadesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  Expression<T> clientesRefs<T extends Object>(
    Expression<T> Function($$ClientesTableAnnotationComposer a) f,
  ) {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.ciudadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CiudadesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CiudadesTable,
          Ciudad,
          $$CiudadesTableFilterComposer,
          $$CiudadesTableOrderingComposer,
          $$CiudadesTableAnnotationComposer,
          $$CiudadesTableCreateCompanionBuilder,
          $$CiudadesTableUpdateCompanionBuilder,
          (Ciudad, $$CiudadesTableReferences),
          Ciudad,
          PrefetchHooks Function({bool clientesRefs})
        > {
  $$CiudadesTableTableManager(_$AppDatabase db, $CiudadesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CiudadesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CiudadesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CiudadesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
              }) => CiudadesCompanion(id: id, nombre: nombre),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
              }) => CiudadesCompanion.insert(id: id, nombre: nombre),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CiudadesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (clientesRefs) db.clientes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (clientesRefs)
                    await $_getPrefetchedData<Ciudad, $CiudadesTable, Cliente>(
                      currentTable: table,
                      referencedTable: $$CiudadesTableReferences
                          ._clientesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CiudadesTableReferences(db, table, p0).clientesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ciudadId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CiudadesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CiudadesTable,
      Ciudad,
      $$CiudadesTableFilterComposer,
      $$CiudadesTableOrderingComposer,
      $$CiudadesTableAnnotationComposer,
      $$CiudadesTableCreateCompanionBuilder,
      $$CiudadesTableUpdateCompanionBuilder,
      (Ciudad, $$CiudadesTableReferences),
      Ciudad,
      PrefetchHooks Function({bool clientesRefs})
    >;
typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> id,
      required int tipoDocumentoId,
      required String documento,
      required String nombreEstablecimiento,
      required String direccion,
      Value<String?> telefono,
      Value<String?> email,
      Value<String?> administrador,
      Value<String?> barrio,
      Value<double?> gpsLat,
      Value<double?> gpsLng,
      Value<int> consecutivoEntrega,
      Value<bool> ivaDiscrimina,
      Value<bool> pagoCredito,
      Value<double> cupo,
      Value<int?> plazo,
      Value<bool> activo,
      required int categoriaClienteId,
      required int rutaId,
      required int ciudadId,
      Value<String?> horarioDesde,
      Value<String?> horarioHasta,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> id,
      Value<int> tipoDocumentoId,
      Value<String> documento,
      Value<String> nombreEstablecimiento,
      Value<String> direccion,
      Value<String?> telefono,
      Value<String?> email,
      Value<String?> administrador,
      Value<String?> barrio,
      Value<double?> gpsLat,
      Value<double?> gpsLng,
      Value<int> consecutivoEntrega,
      Value<bool> ivaDiscrimina,
      Value<bool> pagoCredito,
      Value<double> cupo,
      Value<int?> plazo,
      Value<bool> activo,
      Value<int> categoriaClienteId,
      Value<int> rutaId,
      Value<int> ciudadId,
      Value<String?> horarioDesde,
      Value<String?> horarioHasta,
    });

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TiposDocumentoTable _tipoDocumentoIdTable(_$AppDatabase db) => db
      .tiposDocumento
      .createAlias('clientes__tipo_documento_id__tipos_documento__id');

  $$TiposDocumentoTableProcessedTableManager get tipoDocumentoId {
    final $_column = $_itemColumn<int>('tipo_documento_id')!;

    final manager = $$TiposDocumentoTableTableManager(
      $_db,
      $_db.tiposDocumento,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoDocumentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriasClienteTable _categoriaClienteIdTable(_$AppDatabase db) =>
      db.categoriasCliente.createAlias(
        'clientes__categoria_cliente_id__categorias_cliente__id',
      );

  $$CategoriasClienteTableProcessedTableManager get categoriaClienteId {
    final $_column = $_itemColumn<int>('categoria_cliente_id')!;

    final manager = $$CategoriasClienteTableTableManager(
      $_db,
      $_db.categoriasCliente,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaClienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CiudadesTable _ciudadIdTable(_$AppDatabase db) =>
      db.ciudades.createAlias('clientes__ciudad_id__ciudades__id');

  $$CiudadesTableProcessedTableManager get ciudadId {
    final $_column = $_itemColumn<int>('ciudad_id')!;

    final manager = $$CiudadesTableTableManager(
      $_db,
      $_db.ciudades,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ciudadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PromocionesClientesTable, List<PromocionCliente>>
  _promocionesClientesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.promocionesClientes,
        aliasName: 'clientes__id__promociones_clientes__cliente_id',
      );

  $$PromocionesClientesTableProcessedTableManager get promocionesClientesRefs {
    final manager = $$PromocionesClientesTableTableManager(
      $_db,
      $_db.promocionesClientes,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _promocionesClientesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VentasTable, List<Venta>> _ventasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ventas,
    aliasName: 'clientes__id__ventas__cliente_id',
  );

  $$VentasTableProcessedTableManager get ventasRefs {
    final manager = $$VentasTableTableManager(
      $_db,
      $_db.ventas,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documento => $composableBuilder(
    column: $table.documento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreEstablecimiento => $composableBuilder(
    column: $table.nombreEstablecimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get administrador => $composableBuilder(
    column: $table.administrador,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barrio => $composableBuilder(
    column: $table.barrio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gpsLat => $composableBuilder(
    column: $table.gpsLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gpsLng => $composableBuilder(
    column: $table.gpsLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutivoEntrega => $composableBuilder(
    column: $table.consecutivoEntrega,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ivaDiscrimina => $composableBuilder(
    column: $table.ivaDiscrimina,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pagoCredito => $composableBuilder(
    column: $table.pagoCredito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cupo => $composableBuilder(
    column: $table.cupo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plazo => $composableBuilder(
    column: $table.plazo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rutaId => $composableBuilder(
    column: $table.rutaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get horarioDesde => $composableBuilder(
    column: $table.horarioDesde,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get horarioHasta => $composableBuilder(
    column: $table.horarioHasta,
    builder: (column) => ColumnFilters(column),
  );

  $$TiposDocumentoTableFilterComposer get tipoDocumentoId {
    final $$TiposDocumentoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoDocumentoId,
      referencedTable: $db.tiposDocumento,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposDocumentoTableFilterComposer(
            $db: $db,
            $table: $db.tiposDocumento,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasClienteTableFilterComposer get categoriaClienteId {
    final $$CategoriasClienteTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaClienteId,
      referencedTable: $db.categoriasCliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasClienteTableFilterComposer(
            $db: $db,
            $table: $db.categoriasCliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CiudadesTableFilterComposer get ciudadId {
    final $$CiudadesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ciudadId,
      referencedTable: $db.ciudades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CiudadesTableFilterComposer(
            $db: $db,
            $table: $db.ciudades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> promocionesClientesRefs(
    Expression<bool> Function($$PromocionesClientesTableFilterComposer f) f,
  ) {
    final $$PromocionesClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.promocionesClientes,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesClientesTableFilterComposer(
            $db: $db,
            $table: $db.promocionesClientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventasRefs(
    Expression<bool> Function($$VentasTableFilterComposer f) f,
  ) {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documento => $composableBuilder(
    column: $table.documento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreEstablecimiento => $composableBuilder(
    column: $table.nombreEstablecimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get administrador => $composableBuilder(
    column: $table.administrador,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barrio => $composableBuilder(
    column: $table.barrio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gpsLat => $composableBuilder(
    column: $table.gpsLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gpsLng => $composableBuilder(
    column: $table.gpsLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutivoEntrega => $composableBuilder(
    column: $table.consecutivoEntrega,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ivaDiscrimina => $composableBuilder(
    column: $table.ivaDiscrimina,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pagoCredito => $composableBuilder(
    column: $table.pagoCredito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cupo => $composableBuilder(
    column: $table.cupo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plazo => $composableBuilder(
    column: $table.plazo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rutaId => $composableBuilder(
    column: $table.rutaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get horarioDesde => $composableBuilder(
    column: $table.horarioDesde,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get horarioHasta => $composableBuilder(
    column: $table.horarioHasta,
    builder: (column) => ColumnOrderings(column),
  );

  $$TiposDocumentoTableOrderingComposer get tipoDocumentoId {
    final $$TiposDocumentoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoDocumentoId,
      referencedTable: $db.tiposDocumento,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposDocumentoTableOrderingComposer(
            $db: $db,
            $table: $db.tiposDocumento,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasClienteTableOrderingComposer get categoriaClienteId {
    final $$CategoriasClienteTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaClienteId,
      referencedTable: $db.categoriasCliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasClienteTableOrderingComposer(
            $db: $db,
            $table: $db.categoriasCliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CiudadesTableOrderingComposer get ciudadId {
    final $$CiudadesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ciudadId,
      referencedTable: $db.ciudades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CiudadesTableOrderingComposer(
            $db: $db,
            $table: $db.ciudades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get documento =>
      $composableBuilder(column: $table.documento, builder: (column) => column);

  GeneratedColumn<String> get nombreEstablecimiento => $composableBuilder(
    column: $table.nombreEstablecimiento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get administrador => $composableBuilder(
    column: $table.administrador,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barrio =>
      $composableBuilder(column: $table.barrio, builder: (column) => column);

  GeneratedColumn<double> get gpsLat =>
      $composableBuilder(column: $table.gpsLat, builder: (column) => column);

  GeneratedColumn<double> get gpsLng =>
      $composableBuilder(column: $table.gpsLng, builder: (column) => column);

  GeneratedColumn<int> get consecutivoEntrega => $composableBuilder(
    column: $table.consecutivoEntrega,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ivaDiscrimina => $composableBuilder(
    column: $table.ivaDiscrimina,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pagoCredito => $composableBuilder(
    column: $table.pagoCredito,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cupo =>
      $composableBuilder(column: $table.cupo, builder: (column) => column);

  GeneratedColumn<int> get plazo =>
      $composableBuilder(column: $table.plazo, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<int> get rutaId =>
      $composableBuilder(column: $table.rutaId, builder: (column) => column);

  GeneratedColumn<String> get horarioDesde => $composableBuilder(
    column: $table.horarioDesde,
    builder: (column) => column,
  );

  GeneratedColumn<String> get horarioHasta => $composableBuilder(
    column: $table.horarioHasta,
    builder: (column) => column,
  );

  $$TiposDocumentoTableAnnotationComposer get tipoDocumentoId {
    final $$TiposDocumentoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoDocumentoId,
      referencedTable: $db.tiposDocumento,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposDocumentoTableAnnotationComposer(
            $db: $db,
            $table: $db.tiposDocumento,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasClienteTableAnnotationComposer get categoriaClienteId {
    final $$CategoriasClienteTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoriaClienteId,
          referencedTable: $db.categoriasCliente,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoriasClienteTableAnnotationComposer(
                $db: $db,
                $table: $db.categoriasCliente,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$CiudadesTableAnnotationComposer get ciudadId {
    final $$CiudadesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ciudadId,
      referencedTable: $db.ciudades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CiudadesTableAnnotationComposer(
            $db: $db,
            $table: $db.ciudades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> promocionesClientesRefs<T extends Object>(
    Expression<T> Function($$PromocionesClientesTableAnnotationComposer a) f,
  ) {
    final $$PromocionesClientesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.promocionesClientes,
          getReferencedColumn: (t) => t.clienteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PromocionesClientesTableAnnotationComposer(
                $db: $db,
                $table: $db.promocionesClientes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> ventasRefs<T extends Object>(
    Expression<T> Function($$VentasTableAnnotationComposer a) f,
  ) {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, $$ClientesTableReferences),
          Cliente,
          PrefetchHooks Function({
            bool tipoDocumentoId,
            bool categoriaClienteId,
            bool ciudadId,
            bool promocionesClientesRefs,
            bool ventasRefs,
          })
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tipoDocumentoId = const Value.absent(),
                Value<String> documento = const Value.absent(),
                Value<String> nombreEstablecimiento = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> administrador = const Value.absent(),
                Value<String?> barrio = const Value.absent(),
                Value<double?> gpsLat = const Value.absent(),
                Value<double?> gpsLng = const Value.absent(),
                Value<int> consecutivoEntrega = const Value.absent(),
                Value<bool> ivaDiscrimina = const Value.absent(),
                Value<bool> pagoCredito = const Value.absent(),
                Value<double> cupo = const Value.absent(),
                Value<int?> plazo = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> categoriaClienteId = const Value.absent(),
                Value<int> rutaId = const Value.absent(),
                Value<int> ciudadId = const Value.absent(),
                Value<String?> horarioDesde = const Value.absent(),
                Value<String?> horarioHasta = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                tipoDocumentoId: tipoDocumentoId,
                documento: documento,
                nombreEstablecimiento: nombreEstablecimiento,
                direccion: direccion,
                telefono: telefono,
                email: email,
                administrador: administrador,
                barrio: barrio,
                gpsLat: gpsLat,
                gpsLng: gpsLng,
                consecutivoEntrega: consecutivoEntrega,
                ivaDiscrimina: ivaDiscrimina,
                pagoCredito: pagoCredito,
                cupo: cupo,
                plazo: plazo,
                activo: activo,
                categoriaClienteId: categoriaClienteId,
                rutaId: rutaId,
                ciudadId: ciudadId,
                horarioDesde: horarioDesde,
                horarioHasta: horarioHasta,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tipoDocumentoId,
                required String documento,
                required String nombreEstablecimiento,
                required String direccion,
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> administrador = const Value.absent(),
                Value<String?> barrio = const Value.absent(),
                Value<double?> gpsLat = const Value.absent(),
                Value<double?> gpsLng = const Value.absent(),
                Value<int> consecutivoEntrega = const Value.absent(),
                Value<bool> ivaDiscrimina = const Value.absent(),
                Value<bool> pagoCredito = const Value.absent(),
                Value<double> cupo = const Value.absent(),
                Value<int?> plazo = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                required int categoriaClienteId,
                required int rutaId,
                required int ciudadId,
                Value<String?> horarioDesde = const Value.absent(),
                Value<String?> horarioHasta = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                tipoDocumentoId: tipoDocumentoId,
                documento: documento,
                nombreEstablecimiento: nombreEstablecimiento,
                direccion: direccion,
                telefono: telefono,
                email: email,
                administrador: administrador,
                barrio: barrio,
                gpsLat: gpsLat,
                gpsLng: gpsLng,
                consecutivoEntrega: consecutivoEntrega,
                ivaDiscrimina: ivaDiscrimina,
                pagoCredito: pagoCredito,
                cupo: cupo,
                plazo: plazo,
                activo: activo,
                categoriaClienteId: categoriaClienteId,
                rutaId: rutaId,
                ciudadId: ciudadId,
                horarioDesde: horarioDesde,
                horarioHasta: horarioHasta,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tipoDocumentoId = false,
                categoriaClienteId = false,
                ciudadId = false,
                promocionesClientesRefs = false,
                ventasRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (promocionesClientesRefs) db.promocionesClientes,
                    if (ventasRefs) db.ventas,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (tipoDocumentoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tipoDocumentoId,
                                    referencedTable: $$ClientesTableReferences
                                        ._tipoDocumentoIdTable(db),
                                    referencedColumn: $$ClientesTableReferences
                                        ._tipoDocumentoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (categoriaClienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaClienteId,
                                    referencedTable: $$ClientesTableReferences
                                        ._categoriaClienteIdTable(db),
                                    referencedColumn: $$ClientesTableReferences
                                        ._categoriaClienteIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (ciudadId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ciudadId,
                                    referencedTable: $$ClientesTableReferences
                                        ._ciudadIdTable(db),
                                    referencedColumn: $$ClientesTableReferences
                                        ._ciudadIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (promocionesClientesRefs)
                        await $_getPrefetchedData<
                          Cliente,
                          $ClientesTable,
                          PromocionCliente
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._promocionesClientesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).promocionesClientesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ventasRefs)
                        await $_getPrefetchedData<
                          Cliente,
                          $ClientesTable,
                          Venta
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._ventasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, $$ClientesTableReferences),
      Cliente,
      PrefetchHooks Function({
        bool tipoDocumentoId,
        bool categoriaClienteId,
        bool ciudadId,
        bool promocionesClientesRefs,
        bool ventasRefs,
      })
    >;
typedef $$PreciosTableCreateCompanionBuilder =
    PreciosCompanion Function({
      Value<int> id,
      required int productoId,
      required int categoriaClienteId,
      required double valor,
      required DateTime fecha,
    });
typedef $$PreciosTableUpdateCompanionBuilder =
    PreciosCompanion Function({
      Value<int> id,
      Value<int> productoId,
      Value<int> categoriaClienteId,
      Value<double> valor,
      Value<DateTime> fecha,
    });

final class $$PreciosTableReferences
    extends BaseReferences<_$AppDatabase, $PreciosTable, Precio> {
  $$PreciosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductosTable _productoIdTable(_$AppDatabase db) =>
      db.productos.createAlias('precios__producto_id__productos__id');

  $$ProductosTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriasClienteTable _categoriaClienteIdTable(_$AppDatabase db) =>
      db.categoriasCliente.createAlias(
        'precios__categoria_cliente_id__categorias_cliente__id',
      );

  $$CategoriasClienteTableProcessedTableManager get categoriaClienteId {
    final $_column = $_itemColumn<int>('categoria_cliente_id')!;

    final manager = $$CategoriasClienteTableTableManager(
      $_db,
      $_db.categoriasCliente,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaClienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PreciosTableFilterComposer
    extends Composer<_$AppDatabase, $PreciosTable> {
  $$PreciosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductosTableFilterComposer get productoId {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasClienteTableFilterComposer get categoriaClienteId {
    final $$CategoriasClienteTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaClienteId,
      referencedTable: $db.categoriasCliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasClienteTableFilterComposer(
            $db: $db,
            $table: $db.categoriasCliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreciosTableOrderingComposer
    extends Composer<_$AppDatabase, $PreciosTable> {
  $$PreciosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductosTableOrderingComposer get productoId {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasClienteTableOrderingComposer get categoriaClienteId {
    final $$CategoriasClienteTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaClienteId,
      referencedTable: $db.categoriasCliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasClienteTableOrderingComposer(
            $db: $db,
            $table: $db.categoriasCliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreciosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreciosTable> {
  $$PreciosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $$ProductosTableAnnotationComposer get productoId {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasClienteTableAnnotationComposer get categoriaClienteId {
    final $$CategoriasClienteTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoriaClienteId,
          referencedTable: $db.categoriasCliente,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoriasClienteTableAnnotationComposer(
                $db: $db,
                $table: $db.categoriasCliente,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PreciosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreciosTable,
          Precio,
          $$PreciosTableFilterComposer,
          $$PreciosTableOrderingComposer,
          $$PreciosTableAnnotationComposer,
          $$PreciosTableCreateCompanionBuilder,
          $$PreciosTableUpdateCompanionBuilder,
          (Precio, $$PreciosTableReferences),
          Precio,
          PrefetchHooks Function({bool productoId, bool categoriaClienteId})
        > {
  $$PreciosTableTableManager(_$AppDatabase db, $PreciosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreciosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreciosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreciosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<int> categoriaClienteId = const Value.absent(),
                Value<double> valor = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
              }) => PreciosCompanion(
                id: id,
                productoId: productoId,
                categoriaClienteId: categoriaClienteId,
                valor: valor,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productoId,
                required int categoriaClienteId,
                required double valor,
                required DateTime fecha,
              }) => PreciosCompanion.insert(
                id: id,
                productoId: productoId,
                categoriaClienteId: categoriaClienteId,
                valor: valor,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PreciosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productoId = false, categoriaClienteId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (productoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productoId,
                                    referencedTable: $$PreciosTableReferences
                                        ._productoIdTable(db),
                                    referencedColumn: $$PreciosTableReferences
                                        ._productoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (categoriaClienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaClienteId,
                                    referencedTable: $$PreciosTableReferences
                                        ._categoriaClienteIdTable(db),
                                    referencedColumn: $$PreciosTableReferences
                                        ._categoriaClienteIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PreciosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreciosTable,
      Precio,
      $$PreciosTableFilterComposer,
      $$PreciosTableOrderingComposer,
      $$PreciosTableAnnotationComposer,
      $$PreciosTableCreateCompanionBuilder,
      $$PreciosTableUpdateCompanionBuilder,
      (Precio, $$PreciosTableReferences),
      Precio,
      PrefetchHooks Function({bool productoId, bool categoriaClienteId})
    >;
typedef $$PromocionesTableCreateCompanionBuilder =
    PromocionesCompanion Function({
      Value<int> idpromocion,
      required String promocionpara,
      required String promocionde,
      Value<int> cantidadventa,
      Value<int?> cantidadsobreventa,
      Value<int?> porcentajesobreventa,
      required DateTime fechadesde,
      required DateTime fechahasta,
      Value<int?> rutaId,
      required int productoId,
      Value<int?> categoriaClienteId,
    });
typedef $$PromocionesTableUpdateCompanionBuilder =
    PromocionesCompanion Function({
      Value<int> idpromocion,
      Value<String> promocionpara,
      Value<String> promocionde,
      Value<int> cantidadventa,
      Value<int?> cantidadsobreventa,
      Value<int?> porcentajesobreventa,
      Value<DateTime> fechadesde,
      Value<DateTime> fechahasta,
      Value<int?> rutaId,
      Value<int> productoId,
      Value<int?> categoriaClienteId,
    });

final class $$PromocionesTableReferences
    extends BaseReferences<_$AppDatabase, $PromocionesTable, Promocion> {
  $$PromocionesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductosTable _productoIdTable(_$AppDatabase db) =>
      db.productos.createAlias('promociones__producto_id__productos__id');

  $$ProductosTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriasClienteTable _categoriaClienteIdTable(_$AppDatabase db) =>
      db.categoriasCliente.createAlias(
        'promociones__categoria_cliente_id__categorias_cliente__id',
      );

  $$CategoriasClienteTableProcessedTableManager? get categoriaClienteId {
    final $_column = $_itemColumn<int>('categoria_cliente_id');
    if ($_column == null) return null;
    final manager = $$CategoriasClienteTableTableManager(
      $_db,
      $_db.categoriasCliente,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaClienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PromocionesClientesTable, List<PromocionCliente>>
  _promocionesClientesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.promocionesClientes,
        aliasName:
            'promociones__idpromocion__promociones_clientes__promocion_id',
      );

  $$PromocionesClientesTableProcessedTableManager get promocionesClientesRefs {
    final manager =
        $$PromocionesClientesTableTableManager(
          $_db,
          $_db.promocionesClientes,
        ).filter(
          (f) => f.promocionId.idpromocion.sqlEquals(
            $_itemColumn<int>('idpromocion')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _promocionesClientesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VentasDetalleTable, List<VentaDetalle>>
  _ventasDetalleRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ventasDetalle,
    aliasName: 'promociones__idpromocion__ventas_detalle__promocion_id',
  );

  $$VentasDetalleTableProcessedTableManager get ventasDetalleRefs {
    final manager = $$VentasDetalleTableTableManager($_db, $_db.ventasDetalle)
        .filter(
          (f) => f.promocionId.idpromocion.sqlEquals(
            $_itemColumn<int>('idpromocion')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_ventasDetalleRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PromocionesTableFilterComposer
    extends Composer<_$AppDatabase, $PromocionesTable> {
  $$PromocionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idpromocion => $composableBuilder(
    column: $table.idpromocion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promocionpara => $composableBuilder(
    column: $table.promocionpara,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promocionde => $composableBuilder(
    column: $table.promocionde,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadventa => $composableBuilder(
    column: $table.cantidadventa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadsobreventa => $composableBuilder(
    column: $table.cantidadsobreventa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get porcentajesobreventa => $composableBuilder(
    column: $table.porcentajesobreventa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechadesde => $composableBuilder(
    column: $table.fechadesde,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechahasta => $composableBuilder(
    column: $table.fechahasta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rutaId => $composableBuilder(
    column: $table.rutaId,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductosTableFilterComposer get productoId {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasClienteTableFilterComposer get categoriaClienteId {
    final $$CategoriasClienteTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaClienteId,
      referencedTable: $db.categoriasCliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasClienteTableFilterComposer(
            $db: $db,
            $table: $db.categoriasCliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> promocionesClientesRefs(
    Expression<bool> Function($$PromocionesClientesTableFilterComposer f) f,
  ) {
    final $$PromocionesClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idpromocion,
      referencedTable: $db.promocionesClientes,
      getReferencedColumn: (t) => t.promocionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesClientesTableFilterComposer(
            $db: $db,
            $table: $db.promocionesClientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventasDetalleRefs(
    Expression<bool> Function($$VentasDetalleTableFilterComposer f) f,
  ) {
    final $$VentasDetalleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idpromocion,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.promocionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableFilterComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PromocionesTableOrderingComposer
    extends Composer<_$AppDatabase, $PromocionesTable> {
  $$PromocionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idpromocion => $composableBuilder(
    column: $table.idpromocion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promocionpara => $composableBuilder(
    column: $table.promocionpara,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promocionde => $composableBuilder(
    column: $table.promocionde,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadventa => $composableBuilder(
    column: $table.cantidadventa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadsobreventa => $composableBuilder(
    column: $table.cantidadsobreventa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get porcentajesobreventa => $composableBuilder(
    column: $table.porcentajesobreventa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechadesde => $composableBuilder(
    column: $table.fechadesde,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechahasta => $composableBuilder(
    column: $table.fechahasta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rutaId => $composableBuilder(
    column: $table.rutaId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductosTableOrderingComposer get productoId {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasClienteTableOrderingComposer get categoriaClienteId {
    final $$CategoriasClienteTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaClienteId,
      referencedTable: $db.categoriasCliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasClienteTableOrderingComposer(
            $db: $db,
            $table: $db.categoriasCliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PromocionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromocionesTable> {
  $$PromocionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idpromocion => $composableBuilder(
    column: $table.idpromocion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get promocionpara => $composableBuilder(
    column: $table.promocionpara,
    builder: (column) => column,
  );

  GeneratedColumn<String> get promocionde => $composableBuilder(
    column: $table.promocionde,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidadventa => $composableBuilder(
    column: $table.cantidadventa,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidadsobreventa => $composableBuilder(
    column: $table.cantidadsobreventa,
    builder: (column) => column,
  );

  GeneratedColumn<int> get porcentajesobreventa => $composableBuilder(
    column: $table.porcentajesobreventa,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechadesde => $composableBuilder(
    column: $table.fechadesde,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechahasta => $composableBuilder(
    column: $table.fechahasta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rutaId =>
      $composableBuilder(column: $table.rutaId, builder: (column) => column);

  $$ProductosTableAnnotationComposer get productoId {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasClienteTableAnnotationComposer get categoriaClienteId {
    final $$CategoriasClienteTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoriaClienteId,
          referencedTable: $db.categoriasCliente,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoriasClienteTableAnnotationComposer(
                $db: $db,
                $table: $db.categoriasCliente,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> promocionesClientesRefs<T extends Object>(
    Expression<T> Function($$PromocionesClientesTableAnnotationComposer a) f,
  ) {
    final $$PromocionesClientesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.idpromocion,
          referencedTable: $db.promocionesClientes,
          getReferencedColumn: (t) => t.promocionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PromocionesClientesTableAnnotationComposer(
                $db: $db,
                $table: $db.promocionesClientes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> ventasDetalleRefs<T extends Object>(
    Expression<T> Function($$VentasDetalleTableAnnotationComposer a) f,
  ) {
    final $$VentasDetalleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idpromocion,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.promocionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PromocionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromocionesTable,
          Promocion,
          $$PromocionesTableFilterComposer,
          $$PromocionesTableOrderingComposer,
          $$PromocionesTableAnnotationComposer,
          $$PromocionesTableCreateCompanionBuilder,
          $$PromocionesTableUpdateCompanionBuilder,
          (Promocion, $$PromocionesTableReferences),
          Promocion,
          PrefetchHooks Function({
            bool productoId,
            bool categoriaClienteId,
            bool promocionesClientesRefs,
            bool ventasDetalleRefs,
          })
        > {
  $$PromocionesTableTableManager(_$AppDatabase db, $PromocionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromocionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromocionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromocionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idpromocion = const Value.absent(),
                Value<String> promocionpara = const Value.absent(),
                Value<String> promocionde = const Value.absent(),
                Value<int> cantidadventa = const Value.absent(),
                Value<int?> cantidadsobreventa = const Value.absent(),
                Value<int?> porcentajesobreventa = const Value.absent(),
                Value<DateTime> fechadesde = const Value.absent(),
                Value<DateTime> fechahasta = const Value.absent(),
                Value<int?> rutaId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<int?> categoriaClienteId = const Value.absent(),
              }) => PromocionesCompanion(
                idpromocion: idpromocion,
                promocionpara: promocionpara,
                promocionde: promocionde,
                cantidadventa: cantidadventa,
                cantidadsobreventa: cantidadsobreventa,
                porcentajesobreventa: porcentajesobreventa,
                fechadesde: fechadesde,
                fechahasta: fechahasta,
                rutaId: rutaId,
                productoId: productoId,
                categoriaClienteId: categoriaClienteId,
              ),
          createCompanionCallback:
              ({
                Value<int> idpromocion = const Value.absent(),
                required String promocionpara,
                required String promocionde,
                Value<int> cantidadventa = const Value.absent(),
                Value<int?> cantidadsobreventa = const Value.absent(),
                Value<int?> porcentajesobreventa = const Value.absent(),
                required DateTime fechadesde,
                required DateTime fechahasta,
                Value<int?> rutaId = const Value.absent(),
                required int productoId,
                Value<int?> categoriaClienteId = const Value.absent(),
              }) => PromocionesCompanion.insert(
                idpromocion: idpromocion,
                promocionpara: promocionpara,
                promocionde: promocionde,
                cantidadventa: cantidadventa,
                cantidadsobreventa: cantidadsobreventa,
                porcentajesobreventa: porcentajesobreventa,
                fechadesde: fechadesde,
                fechahasta: fechahasta,
                rutaId: rutaId,
                productoId: productoId,
                categoriaClienteId: categoriaClienteId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PromocionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productoId = false,
                categoriaClienteId = false,
                promocionesClientesRefs = false,
                ventasDetalleRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (promocionesClientesRefs) db.promocionesClientes,
                    if (ventasDetalleRefs) db.ventasDetalle,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (productoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productoId,
                                    referencedTable:
                                        $$PromocionesTableReferences
                                            ._productoIdTable(db),
                                    referencedColumn:
                                        $$PromocionesTableReferences
                                            ._productoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoriaClienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaClienteId,
                                    referencedTable:
                                        $$PromocionesTableReferences
                                            ._categoriaClienteIdTable(db),
                                    referencedColumn:
                                        $$PromocionesTableReferences
                                            ._categoriaClienteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (promocionesClientesRefs)
                        await $_getPrefetchedData<
                          Promocion,
                          $PromocionesTable,
                          PromocionCliente
                        >(
                          currentTable: table,
                          referencedTable: $$PromocionesTableReferences
                              ._promocionesClientesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PromocionesTableReferences(
                                db,
                                table,
                                p0,
                              ).promocionesClientesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.promocionId == item.idpromocion,
                              ),
                          typedResults: items,
                        ),
                      if (ventasDetalleRefs)
                        await $_getPrefetchedData<
                          Promocion,
                          $PromocionesTable,
                          VentaDetalle
                        >(
                          currentTable: table,
                          referencedTable: $$PromocionesTableReferences
                              ._ventasDetalleRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PromocionesTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasDetalleRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.promocionId == item.idpromocion,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PromocionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromocionesTable,
      Promocion,
      $$PromocionesTableFilterComposer,
      $$PromocionesTableOrderingComposer,
      $$PromocionesTableAnnotationComposer,
      $$PromocionesTableCreateCompanionBuilder,
      $$PromocionesTableUpdateCompanionBuilder,
      (Promocion, $$PromocionesTableReferences),
      Promocion,
      PrefetchHooks Function({
        bool productoId,
        bool categoriaClienteId,
        bool promocionesClientesRefs,
        bool ventasDetalleRefs,
      })
    >;
typedef $$PromocionesClientesTableCreateCompanionBuilder =
    PromocionesClientesCompanion Function({
      Value<int> id,
      required int promocionId,
      required int clienteId,
    });
typedef $$PromocionesClientesTableUpdateCompanionBuilder =
    PromocionesClientesCompanion Function({
      Value<int> id,
      Value<int> promocionId,
      Value<int> clienteId,
    });

final class $$PromocionesClientesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PromocionesClientesTable,
          PromocionCliente
        > {
  $$PromocionesClientesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PromocionesTable _promocionIdTable(_$AppDatabase db) =>
      db.promociones.createAlias(
        'promociones_clientes__promocion_id__promociones__idpromocion',
      );

  $$PromocionesTableProcessedTableManager get promocionId {
    final $_column = $_itemColumn<int>('promocion_id')!;

    final manager = $$PromocionesTableTableManager(
      $_db,
      $_db.promociones,
    ).filter((f) => f.idpromocion.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_promocionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias('promociones_clientes__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PromocionesClientesTableFilterComposer
    extends Composer<_$AppDatabase, $PromocionesClientesTable> {
  $$PromocionesClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$PromocionesTableFilterComposer get promocionId {
    final $$PromocionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promocionId,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.idpromocion,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableFilterComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PromocionesClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $PromocionesClientesTable> {
  $$PromocionesClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$PromocionesTableOrderingComposer get promocionId {
    final $$PromocionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promocionId,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.idpromocion,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableOrderingComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PromocionesClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromocionesClientesTable> {
  $$PromocionesClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$PromocionesTableAnnotationComposer get promocionId {
    final $$PromocionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promocionId,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.idpromocion,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableAnnotationComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PromocionesClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromocionesClientesTable,
          PromocionCliente,
          $$PromocionesClientesTableFilterComposer,
          $$PromocionesClientesTableOrderingComposer,
          $$PromocionesClientesTableAnnotationComposer,
          $$PromocionesClientesTableCreateCompanionBuilder,
          $$PromocionesClientesTableUpdateCompanionBuilder,
          (PromocionCliente, $$PromocionesClientesTableReferences),
          PromocionCliente,
          PrefetchHooks Function({bool promocionId, bool clienteId})
        > {
  $$PromocionesClientesTableTableManager(
    _$AppDatabase db,
    $PromocionesClientesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromocionesClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromocionesClientesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PromocionesClientesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> promocionId = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
              }) => PromocionesClientesCompanion(
                id: id,
                promocionId: promocionId,
                clienteId: clienteId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int promocionId,
                required int clienteId,
              }) => PromocionesClientesCompanion.insert(
                id: id,
                promocionId: promocionId,
                clienteId: clienteId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PromocionesClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({promocionId = false, clienteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (promocionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.promocionId,
                                referencedTable:
                                    $$PromocionesClientesTableReferences
                                        ._promocionIdTable(db),
                                referencedColumn:
                                    $$PromocionesClientesTableReferences
                                        ._promocionIdTable(db)
                                        .idpromocion,
                              )
                              as T;
                    }
                    if (clienteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clienteId,
                                referencedTable:
                                    $$PromocionesClientesTableReferences
                                        ._clienteIdTable(db),
                                referencedColumn:
                                    $$PromocionesClientesTableReferences
                                        ._clienteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PromocionesClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromocionesClientesTable,
      PromocionCliente,
      $$PromocionesClientesTableFilterComposer,
      $$PromocionesClientesTableOrderingComposer,
      $$PromocionesClientesTableAnnotationComposer,
      $$PromocionesClientesTableCreateCompanionBuilder,
      $$PromocionesClientesTableUpdateCompanionBuilder,
      (PromocionCliente, $$PromocionesClientesTableReferences),
      PromocionCliente,
      PrefetchHooks Function({bool promocionId, bool clienteId})
    >;
typedef $$VentasTableCreateCompanionBuilder =
    VentasCompanion Function({
      Value<int> id,
      Value<int?> idBackend,
      required int consecutivo,
      required int clienteId,
      required int vendedorId,
      Value<int?> rutaId,
      Value<DateTime> fecha,
      required double total,
      Value<bool> sincronizado,
      Value<DateTime?> fechaSincronizacion,
    });
typedef $$VentasTableUpdateCompanionBuilder =
    VentasCompanion Function({
      Value<int> id,
      Value<int?> idBackend,
      Value<int> consecutivo,
      Value<int> clienteId,
      Value<int> vendedorId,
      Value<int?> rutaId,
      Value<DateTime> fecha,
      Value<double> total,
      Value<bool> sincronizado,
      Value<DateTime?> fechaSincronizacion,
    });

final class $$VentasTableReferences
    extends BaseReferences<_$AppDatabase, $VentasTable, Venta> {
  $$VentasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias('ventas__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RutasTable _rutaIdTable(_$AppDatabase db) =>
      db.rutas.createAlias('ventas__ruta_id__rutas__id_ruta');

  $$RutasTableProcessedTableManager? get rutaId {
    final $_column = $_itemColumn<int>('ruta_id');
    if ($_column == null) return null;
    final manager = $$RutasTableTableManager(
      $_db,
      $_db.rutas,
    ).filter((f) => f.idRuta.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rutaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VentasDetalleTable, List<VentaDetalle>>
  _ventasDetalleRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ventasDetalle,
    aliasName: 'ventas__id__ventas_detalle__venta_id',
  );

  $$VentasDetalleTableProcessedTableManager get ventasDetalleRefs {
    final manager = $$VentasDetalleTableTableManager(
      $_db,
      $_db.ventasDetalle,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventasDetalleRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VentasFormasPagoTable, List<VentaFormaPago>>
  _ventasFormasPagoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ventasFormasPago,
    aliasName: 'ventas__id__ventas_formas_pago__venta_id',
  );

  $$VentasFormasPagoTableProcessedTableManager get ventasFormasPagoRefs {
    final manager = $$VentasFormasPagoTableTableManager(
      $_db,
      $_db.ventasFormasPago,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ventasFormasPagoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VentasTableFilterComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idBackend => $composableBuilder(
    column: $table.idBackend,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutivo => $composableBuilder(
    column: $table.consecutivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaSincronizacion => $composableBuilder(
    column: $table.fechaSincronizacion,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RutasTableFilterComposer get rutaId {
    final $$RutasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rutaId,
      referencedTable: $db.rutas,
      getReferencedColumn: (t) => t.idRuta,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RutasTableFilterComposer(
            $db: $db,
            $table: $db.rutas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ventasDetalleRefs(
    Expression<bool> Function($$VentasDetalleTableFilterComposer f) f,
  ) {
    final $$VentasDetalleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableFilterComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventasFormasPagoRefs(
    Expression<bool> Function($$VentasFormasPagoTableFilterComposer f) f,
  ) {
    final $$VentasFormasPagoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasFormasPago,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasFormasPagoTableFilterComposer(
            $db: $db,
            $table: $db.ventasFormasPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idBackend => $composableBuilder(
    column: $table.idBackend,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutivo => $composableBuilder(
    column: $table.consecutivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaSincronizacion => $composableBuilder(
    column: $table.fechaSincronizacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RutasTableOrderingComposer get rutaId {
    final $$RutasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rutaId,
      referencedTable: $db.rutas,
      getReferencedColumn: (t) => t.idRuta,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RutasTableOrderingComposer(
            $db: $db,
            $table: $db.rutas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get idBackend =>
      $composableBuilder(column: $table.idBackend, builder: (column) => column);

  GeneratedColumn<int> get consecutivo => $composableBuilder(
    column: $table.consecutivo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vendedorId => $composableBuilder(
    column: $table.vendedorId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaSincronizacion => $composableBuilder(
    column: $table.fechaSincronizacion,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RutasTableAnnotationComposer get rutaId {
    final $$RutasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rutaId,
      referencedTable: $db.rutas,
      getReferencedColumn: (t) => t.idRuta,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RutasTableAnnotationComposer(
            $db: $db,
            $table: $db.rutas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ventasDetalleRefs<T extends Object>(
    Expression<T> Function($$VentasDetalleTableAnnotationComposer a) f,
  ) {
    final $$VentasDetalleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ventasFormasPagoRefs<T extends Object>(
    Expression<T> Function($$VentasFormasPagoTableAnnotationComposer a) f,
  ) {
    final $$VentasFormasPagoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasFormasPago,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasFormasPagoTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasFormasPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasTable,
          Venta,
          $$VentasTableFilterComposer,
          $$VentasTableOrderingComposer,
          $$VentasTableAnnotationComposer,
          $$VentasTableCreateCompanionBuilder,
          $$VentasTableUpdateCompanionBuilder,
          (Venta, $$VentasTableReferences),
          Venta,
          PrefetchHooks Function({
            bool clienteId,
            bool rutaId,
            bool ventasDetalleRefs,
            bool ventasFormasPagoRefs,
          })
        > {
  $$VentasTableTableManager(_$AppDatabase db, $VentasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> idBackend = const Value.absent(),
                Value<int> consecutivo = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<int> vendedorId = const Value.absent(),
                Value<int?> rutaId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<bool> sincronizado = const Value.absent(),
                Value<DateTime?> fechaSincronizacion = const Value.absent(),
              }) => VentasCompanion(
                id: id,
                idBackend: idBackend,
                consecutivo: consecutivo,
                clienteId: clienteId,
                vendedorId: vendedorId,
                rutaId: rutaId,
                fecha: fecha,
                total: total,
                sincronizado: sincronizado,
                fechaSincronizacion: fechaSincronizacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> idBackend = const Value.absent(),
                required int consecutivo,
                required int clienteId,
                required int vendedorId,
                Value<int?> rutaId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                required double total,
                Value<bool> sincronizado = const Value.absent(),
                Value<DateTime?> fechaSincronizacion = const Value.absent(),
              }) => VentasCompanion.insert(
                id: id,
                idBackend: idBackend,
                consecutivo: consecutivo,
                clienteId: clienteId,
                vendedorId: vendedorId,
                rutaId: rutaId,
                fecha: fecha,
                total: total,
                sincronizado: sincronizado,
                fechaSincronizacion: fechaSincronizacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$VentasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteId = false,
                rutaId = false,
                ventasDetalleRefs = false,
                ventasFormasPagoRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ventasDetalleRefs) db.ventasDetalle,
                    if (ventasFormasPagoRefs) db.ventasFormasPago,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (clienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clienteId,
                                    referencedTable: $$VentasTableReferences
                                        ._clienteIdTable(db),
                                    referencedColumn: $$VentasTableReferences
                                        ._clienteIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (rutaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.rutaId,
                                    referencedTable: $$VentasTableReferences
                                        ._rutaIdTable(db),
                                    referencedColumn: $$VentasTableReferences
                                        ._rutaIdTable(db)
                                        .idRuta,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ventasDetalleRefs)
                        await $_getPrefetchedData<
                          Venta,
                          $VentasTable,
                          VentaDetalle
                        >(
                          currentTable: table,
                          referencedTable: $$VentasTableReferences
                              ._ventasDetalleRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VentasTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasDetalleRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ventaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ventasFormasPagoRefs)
                        await $_getPrefetchedData<
                          Venta,
                          $VentasTable,
                          VentaFormaPago
                        >(
                          currentTable: table,
                          referencedTable: $$VentasTableReferences
                              ._ventasFormasPagoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VentasTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasFormasPagoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ventaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VentasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasTable,
      Venta,
      $$VentasTableFilterComposer,
      $$VentasTableOrderingComposer,
      $$VentasTableAnnotationComposer,
      $$VentasTableCreateCompanionBuilder,
      $$VentasTableUpdateCompanionBuilder,
      (Venta, $$VentasTableReferences),
      Venta,
      PrefetchHooks Function({
        bool clienteId,
        bool rutaId,
        bool ventasDetalleRefs,
        bool ventasFormasPagoRefs,
      })
    >;
typedef $$VentasDetalleTableCreateCompanionBuilder =
    VentasDetalleCompanion Function({
      Value<int> id,
      required int ventaId,
      required int productoId,
      required int cantidad,
      required double precioUnitario,
      Value<int> porcentajeIva,
      Value<int?> promocionId,
      required double subtotal,
    });
typedef $$VentasDetalleTableUpdateCompanionBuilder =
    VentasDetalleCompanion Function({
      Value<int> id,
      Value<int> ventaId,
      Value<int> productoId,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<int> porcentajeIva,
      Value<int?> promocionId,
      Value<double> subtotal,
    });

final class $$VentasDetalleTableReferences
    extends BaseReferences<_$AppDatabase, $VentasDetalleTable, VentaDetalle> {
  $$VentasDetalleTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VentasTable _ventaIdTable(_$AppDatabase db) =>
      db.ventas.createAlias('ventas_detalle__venta_id__ventas__id');

  $$VentasTableProcessedTableManager get ventaId {
    final $_column = $_itemColumn<int>('venta_id')!;

    final manager = $$VentasTableTableManager(
      $_db,
      $_db.ventas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductosTable _productoIdTable(_$AppDatabase db) =>
      db.productos.createAlias('ventas_detalle__producto_id__productos__id');

  $$ProductosTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PromocionesTable _promocionIdTable(_$AppDatabase db) => db.promociones
      .createAlias('ventas_detalle__promocion_id__promociones__idpromocion');

  $$PromocionesTableProcessedTableManager? get promocionId {
    final $_column = $_itemColumn<int>('promocion_id');
    if ($_column == null) return null;
    final manager = $$PromocionesTableTableManager(
      $_db,
      $_db.promociones,
    ).filter((f) => f.idpromocion.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_promocionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VentasDetalleTableFilterComposer
    extends Composer<_$AppDatabase, $VentasDetalleTable> {
  $$VentasDetalleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get porcentajeIva => $composableBuilder(
    column: $table.porcentajeIva,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  $$VentasTableFilterComposer get ventaId {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableFilterComposer get productoId {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PromocionesTableFilterComposer get promocionId {
    final $$PromocionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promocionId,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.idpromocion,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableFilterComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasDetalleTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasDetalleTable> {
  $$VentasDetalleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get porcentajeIva => $composableBuilder(
    column: $table.porcentajeIva,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  $$VentasTableOrderingComposer get ventaId {
    final $$VentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableOrderingComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableOrderingComposer get productoId {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PromocionesTableOrderingComposer get promocionId {
    final $$PromocionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promocionId,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.idpromocion,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableOrderingComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasDetalleTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasDetalleTable> {
  $$VentasDetalleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<int> get porcentajeIva => $composableBuilder(
    column: $table.porcentajeIva,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  $$VentasTableAnnotationComposer get ventaId {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableAnnotationComposer get productoId {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PromocionesTableAnnotationComposer get promocionId {
    final $$PromocionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promocionId,
      referencedTable: $db.promociones,
      getReferencedColumn: (t) => t.idpromocion,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PromocionesTableAnnotationComposer(
            $db: $db,
            $table: $db.promociones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasDetalleTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasDetalleTable,
          VentaDetalle,
          $$VentasDetalleTableFilterComposer,
          $$VentasDetalleTableOrderingComposer,
          $$VentasDetalleTableAnnotationComposer,
          $$VentasDetalleTableCreateCompanionBuilder,
          $$VentasDetalleTableUpdateCompanionBuilder,
          (VentaDetalle, $$VentasDetalleTableReferences),
          VentaDetalle,
          PrefetchHooks Function({
            bool ventaId,
            bool productoId,
            bool promocionId,
          })
        > {
  $$VentasDetalleTableTableManager(_$AppDatabase db, $VentasDetalleTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentasDetalleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentasDetalleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentasDetalleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ventaId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<int> porcentajeIva = const Value.absent(),
                Value<int?> promocionId = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
              }) => VentasDetalleCompanion(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                porcentajeIva: porcentajeIva,
                promocionId: promocionId,
                subtotal: subtotal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ventaId,
                required int productoId,
                required int cantidad,
                required double precioUnitario,
                Value<int> porcentajeIva = const Value.absent(),
                Value<int?> promocionId = const Value.absent(),
                required double subtotal,
              }) => VentasDetalleCompanion.insert(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                porcentajeIva: porcentajeIva,
                promocionId: promocionId,
                subtotal: subtotal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VentasDetalleTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({ventaId = false, productoId = false, promocionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (ventaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ventaId,
                                    referencedTable:
                                        $$VentasDetalleTableReferences
                                            ._ventaIdTable(db),
                                    referencedColumn:
                                        $$VentasDetalleTableReferences
                                            ._ventaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (productoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productoId,
                                    referencedTable:
                                        $$VentasDetalleTableReferences
                                            ._productoIdTable(db),
                                    referencedColumn:
                                        $$VentasDetalleTableReferences
                                            ._productoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (promocionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.promocionId,
                                    referencedTable:
                                        $$VentasDetalleTableReferences
                                            ._promocionIdTable(db),
                                    referencedColumn:
                                        $$VentasDetalleTableReferences
                                            ._promocionIdTable(db)
                                            .idpromocion,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$VentasDetalleTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasDetalleTable,
      VentaDetalle,
      $$VentasDetalleTableFilterComposer,
      $$VentasDetalleTableOrderingComposer,
      $$VentasDetalleTableAnnotationComposer,
      $$VentasDetalleTableCreateCompanionBuilder,
      $$VentasDetalleTableUpdateCompanionBuilder,
      (VentaDetalle, $$VentasDetalleTableReferences),
      VentaDetalle,
      PrefetchHooks Function({bool ventaId, bool productoId, bool promocionId})
    >;
typedef $$VentasFormasPagoTableCreateCompanionBuilder =
    VentasFormasPagoCompanion Function({
      Value<int> id,
      required int ventaId,
      required int formaPagoId,
      required double monto,
    });
typedef $$VentasFormasPagoTableUpdateCompanionBuilder =
    VentasFormasPagoCompanion Function({
      Value<int> id,
      Value<int> ventaId,
      Value<int> formaPagoId,
      Value<double> monto,
    });

final class $$VentasFormasPagoTableReferences
    extends
        BaseReferences<_$AppDatabase, $VentasFormasPagoTable, VentaFormaPago> {
  $$VentasFormasPagoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VentasTable _ventaIdTable(_$AppDatabase db) =>
      db.ventas.createAlias('ventas_formas_pago__venta_id__ventas__id');

  $$VentasTableProcessedTableManager get ventaId {
    final $_column = $_itemColumn<int>('venta_id')!;

    final manager = $$VentasTableTableManager(
      $_db,
      $_db.ventas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FormasPagoTable _formaPagoIdTable(_$AppDatabase db) =>
      db.formasPago.createAlias(
        'ventas_formas_pago__forma_pago_id__forma_pago__idformapago',
      );

  $$FormasPagoTableProcessedTableManager get formaPagoId {
    final $_column = $_itemColumn<int>('forma_pago_id')!;

    final manager = $$FormasPagoTableTableManager(
      $_db,
      $_db.formasPago,
    ).filter((f) => f.idformapago.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_formaPagoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VentasFormasPagoTableFilterComposer
    extends Composer<_$AppDatabase, $VentasFormasPagoTable> {
  $$VentasFormasPagoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  $$VentasTableFilterComposer get ventaId {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FormasPagoTableFilterComposer get formaPagoId {
    final $$FormasPagoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formaPagoId,
      referencedTable: $db.formasPago,
      getReferencedColumn: (t) => t.idformapago,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormasPagoTableFilterComposer(
            $db: $db,
            $table: $db.formasPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasFormasPagoTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasFormasPagoTable> {
  $$VentasFormasPagoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  $$VentasTableOrderingComposer get ventaId {
    final $$VentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableOrderingComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FormasPagoTableOrderingComposer get formaPagoId {
    final $$FormasPagoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formaPagoId,
      referencedTable: $db.formasPago,
      getReferencedColumn: (t) => t.idformapago,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormasPagoTableOrderingComposer(
            $db: $db,
            $table: $db.formasPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasFormasPagoTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasFormasPagoTable> {
  $$VentasFormasPagoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  $$VentasTableAnnotationComposer get ventaId {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FormasPagoTableAnnotationComposer get formaPagoId {
    final $$FormasPagoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formaPagoId,
      referencedTable: $db.formasPago,
      getReferencedColumn: (t) => t.idformapago,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormasPagoTableAnnotationComposer(
            $db: $db,
            $table: $db.formasPago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasFormasPagoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasFormasPagoTable,
          VentaFormaPago,
          $$VentasFormasPagoTableFilterComposer,
          $$VentasFormasPagoTableOrderingComposer,
          $$VentasFormasPagoTableAnnotationComposer,
          $$VentasFormasPagoTableCreateCompanionBuilder,
          $$VentasFormasPagoTableUpdateCompanionBuilder,
          (VentaFormaPago, $$VentasFormasPagoTableReferences),
          VentaFormaPago,
          PrefetchHooks Function({bool ventaId, bool formaPagoId})
        > {
  $$VentasFormasPagoTableTableManager(
    _$AppDatabase db,
    $VentasFormasPagoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentasFormasPagoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentasFormasPagoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentasFormasPagoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ventaId = const Value.absent(),
                Value<int> formaPagoId = const Value.absent(),
                Value<double> monto = const Value.absent(),
              }) => VentasFormasPagoCompanion(
                id: id,
                ventaId: ventaId,
                formaPagoId: formaPagoId,
                monto: monto,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ventaId,
                required int formaPagoId,
                required double monto,
              }) => VentasFormasPagoCompanion.insert(
                id: id,
                ventaId: ventaId,
                formaPagoId: formaPagoId,
                monto: monto,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VentasFormasPagoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ventaId = false, formaPagoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (ventaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ventaId,
                                referencedTable:
                                    $$VentasFormasPagoTableReferences
                                        ._ventaIdTable(db),
                                referencedColumn:
                                    $$VentasFormasPagoTableReferences
                                        ._ventaIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (formaPagoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.formaPagoId,
                                referencedTable:
                                    $$VentasFormasPagoTableReferences
                                        ._formaPagoIdTable(db),
                                referencedColumn:
                                    $$VentasFormasPagoTableReferences
                                        ._formaPagoIdTable(db)
                                        .idformapago,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VentasFormasPagoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasFormasPagoTable,
      VentaFormaPago,
      $$VentasFormasPagoTableFilterComposer,
      $$VentasFormasPagoTableOrderingComposer,
      $$VentasFormasPagoTableAnnotationComposer,
      $$VentasFormasPagoTableCreateCompanionBuilder,
      $$VentasFormasPagoTableUpdateCompanionBuilder,
      (VentaFormaPago, $$VentasFormasPagoTableReferences),
      VentaFormaPago,
      PrefetchHooks Function({bool ventaId, bool formaPagoId})
    >;
typedef $$SyncInventarioTableCreateCompanionBuilder =
    SyncInventarioCompanion Function({Value<int> id, Value<bool> sincronizado});
typedef $$SyncInventarioTableUpdateCompanionBuilder =
    SyncInventarioCompanion Function({Value<int> id, Value<bool> sincronizado});

class $$SyncInventarioTableFilterComposer
    extends Composer<_$AppDatabase, $SyncInventarioTable> {
  $$SyncInventarioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncInventarioTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncInventarioTable> {
  $$SyncInventarioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncInventarioTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncInventarioTable> {
  $$SyncInventarioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => column,
  );
}

class $$SyncInventarioTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncInventarioTable,
          SyncInventarioData,
          $$SyncInventarioTableFilterComposer,
          $$SyncInventarioTableOrderingComposer,
          $$SyncInventarioTableAnnotationComposer,
          $$SyncInventarioTableCreateCompanionBuilder,
          $$SyncInventarioTableUpdateCompanionBuilder,
          (
            SyncInventarioData,
            BaseReferences<
              _$AppDatabase,
              $SyncInventarioTable,
              SyncInventarioData
            >,
          ),
          SyncInventarioData,
          PrefetchHooks Function()
        > {
  $$SyncInventarioTableTableManager(
    _$AppDatabase db,
    $SyncInventarioTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncInventarioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncInventarioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncInventarioTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> sincronizado = const Value.absent(),
              }) => SyncInventarioCompanion(id: id, sincronizado: sincronizado),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> sincronizado = const Value.absent(),
              }) => SyncInventarioCompanion.insert(
                id: id,
                sincronizado: sincronizado,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncInventarioTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncInventarioTable,
      SyncInventarioData,
      $$SyncInventarioTableFilterComposer,
      $$SyncInventarioTableOrderingComposer,
      $$SyncInventarioTableAnnotationComposer,
      $$SyncInventarioTableCreateCompanionBuilder,
      $$SyncInventarioTableUpdateCompanionBuilder,
      (
        SyncInventarioData,
        BaseReferences<_$AppDatabase, $SyncInventarioTable, SyncInventarioData>,
      ),
      SyncInventarioData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
  $$CategoriasClienteTableTableManager get categoriasCliente =>
      $$CategoriasClienteTableTableManager(_db, _db.categoriasCliente);
  $$TiposDocumentoTableTableManager get tiposDocumento =>
      $$TiposDocumentoTableTableManager(_db, _db.tiposDocumento);
  $$FormasPagoTableTableManager get formasPago =>
      $$FormasPagoTableTableManager(_db, _db.formasPago);
  $$RutasTableTableManager get rutas =>
      $$RutasTableTableManager(_db, _db.rutas);
  $$CiudadesTableTableManager get ciudades =>
      $$CiudadesTableTableManager(_db, _db.ciudades);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$PreciosTableTableManager get precios =>
      $$PreciosTableTableManager(_db, _db.precios);
  $$PromocionesTableTableManager get promociones =>
      $$PromocionesTableTableManager(_db, _db.promociones);
  $$PromocionesClientesTableTableManager get promocionesClientes =>
      $$PromocionesClientesTableTableManager(_db, _db.promocionesClientes);
  $$VentasTableTableManager get ventas =>
      $$VentasTableTableManager(_db, _db.ventas);
  $$VentasDetalleTableTableManager get ventasDetalle =>
      $$VentasDetalleTableTableManager(_db, _db.ventasDetalle);
  $$VentasFormasPagoTableTableManager get ventasFormasPago =>
      $$VentasFormasPagoTableTableManager(_db, _db.ventasFormasPago);
  $$SyncInventarioTableTableManager get syncInventario =>
      $$SyncInventarioTableTableManager(_db, _db.syncInventario);
}
