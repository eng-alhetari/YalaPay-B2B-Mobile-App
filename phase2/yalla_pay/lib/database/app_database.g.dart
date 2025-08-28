// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PaymentModesDao? _paymentModesDaoInstance;

  ChequeReturnReasonsDao? _chequeReturnReasonsDaoInstance;

  ChequeStatusDao? _chequeStatusDaoInstance;

  DepositStatusDao? _depositStatusDaoInstance;

  InvoiceStatusDao? _invoiceStatusDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `paymentModes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `mode` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `chequeReturnReasons` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `reason` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `chequeStatus` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `status` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `depositStatus` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `status` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `invoiceStatus` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `status` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PaymentModesDao get paymentModesDao {
    return _paymentModesDaoInstance ??=
        _$PaymentModesDao(database, changeListener);
  }

  @override
  ChequeReturnReasonsDao get chequeReturnReasonsDao {
    return _chequeReturnReasonsDaoInstance ??=
        _$ChequeReturnReasonsDao(database, changeListener);
  }

  @override
  ChequeStatusDao get chequeStatusDao {
    return _chequeStatusDaoInstance ??=
        _$ChequeStatusDao(database, changeListener);
  }

  @override
  DepositStatusDao get depositStatusDao {
    return _depositStatusDaoInstance ??=
        _$DepositStatusDao(database, changeListener);
  }

  @override
  InvoiceStatusDao get invoiceStatusDao {
    return _invoiceStatusDaoInstance ??=
        _$InvoiceStatusDao(database, changeListener);
  }
}

class _$PaymentModesDao extends PaymentModesDao {
  _$PaymentModesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _paymentModesInsertionAdapter = InsertionAdapter(
            database,
            'paymentModes',
            (PaymentModes item) =>
                <String, Object?>{'id': item.id, 'mode': item.mode},
            changeListener),
        _paymentModesDeletionAdapter = DeletionAdapter(
            database,
            'paymentModes',
            ['id'],
            (PaymentModes item) =>
                <String, Object?>{'id': item.id, 'mode': item.mode},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PaymentModes> _paymentModesInsertionAdapter;

  final DeletionAdapter<PaymentModes> _paymentModesDeletionAdapter;

  @override
  Stream<List<PaymentModes>> observePaymentModes() {
    return _queryAdapter.queryListStream('SELECT * FROM paymentModes',
        mapper: (Map<String, Object?> row) =>
            PaymentModes(mode: row['mode'] as String),
        queryableName: 'paymentModes',
        isView: false);
  }

  @override
  Future<void> addPaymentModes(PaymentModes paymentModes) async {
    await _paymentModesInsertionAdapter.insert(
        paymentModes, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePaymentModes(PaymentModes paymentModes) async {
    await _paymentModesDeletionAdapter.delete(paymentModes);
  }
}

class _$ChequeReturnReasonsDao extends ChequeReturnReasonsDao {
  _$ChequeReturnReasonsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _chequeReturnReasonsInsertionAdapter = InsertionAdapter(
            database,
            'chequeReturnReasons',
            (ChequeReturnReasons item) =>
                <String, Object?>{'id': item.id, 'reason': item.reason},
            changeListener),
        _chequeReturnReasonsDeletionAdapter = DeletionAdapter(
            database,
            'chequeReturnReasons',
            ['id'],
            (ChequeReturnReasons item) =>
                <String, Object?>{'id': item.id, 'reason': item.reason},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ChequeReturnReasons>
      _chequeReturnReasonsInsertionAdapter;

  final DeletionAdapter<ChequeReturnReasons>
      _chequeReturnReasonsDeletionAdapter;

  @override
  Stream<List<ChequeReturnReasons>> observeChequeReturnReasons() {
    return _queryAdapter.queryListStream('SELECT * FROM chequeReturnReasons',
        mapper: (Map<String, Object?> row) =>
            ChequeReturnReasons(reason: row['reason'] as String),
        queryableName: 'chequeReturnReasons',
        isView: false);
  }

  @override
  Future<void> addChequeReturnReasons(
      ChequeReturnReasons chequeStatusReason) async {
    await _chequeReturnReasonsInsertionAdapter.insert(
        chequeStatusReason, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteChequeReturnReasons(
      ChequeReturnReasons chequeStatusReason) async {
    await _chequeReturnReasonsDeletionAdapter.delete(chequeStatusReason);
  }
}

class _$ChequeStatusDao extends ChequeStatusDao {
  _$ChequeStatusDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _chequeStatusInsertionAdapter = InsertionAdapter(
            database,
            'chequeStatus',
            (ChequeStatus item) =>
                <String, Object?>{'id': item.id, 'status': item.status},
            changeListener),
        _chequeStatusDeletionAdapter = DeletionAdapter(
            database,
            'chequeStatus',
            ['id'],
            (ChequeStatus item) =>
                <String, Object?>{'id': item.id, 'status': item.status},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ChequeStatus> _chequeStatusInsertionAdapter;

  final DeletionAdapter<ChequeStatus> _chequeStatusDeletionAdapter;

  @override
  Stream<List<ChequeStatus>> observeChequeStatus() {
    return _queryAdapter.queryListStream('SELECT * FROM chequeStatus',
        mapper: (Map<String, Object?> row) =>
            ChequeStatus(status: row['status'] as String),
        queryableName: 'chequeStatus',
        isView: false);
  }

  @override
  Future<void> addChequeStatus(ChequeStatus chequeStatus) async {
    await _chequeStatusInsertionAdapter.insert(
        chequeStatus, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteChequeStatus(ChequeStatus chequeStatus) async {
    await _chequeStatusDeletionAdapter.delete(chequeStatus);
  }
}

class _$DepositStatusDao extends DepositStatusDao {
  _$DepositStatusDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _depositStatusInsertionAdapter = InsertionAdapter(
            database,
            'depositStatus',
            (DepositStatus item) =>
                <String, Object?>{'id': item.id, 'status': item.status},
            changeListener),
        _depositStatusDeletionAdapter = DeletionAdapter(
            database,
            'depositStatus',
            ['id'],
            (DepositStatus item) =>
                <String, Object?>{'id': item.id, 'status': item.status},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DepositStatus> _depositStatusInsertionAdapter;

  final DeletionAdapter<DepositStatus> _depositStatusDeletionAdapter;

  @override
  Stream<List<DepositStatus>> observeDepositStatus() {
    return _queryAdapter.queryListStream('SELECT * FROM depositStatus',
        mapper: (Map<String, Object?> row) =>
            DepositStatus(status: row['status'] as String),
        queryableName: 'depositStatus',
        isView: false);
  }

  @override
  Future<void> addDepositStatus(DepositStatus depositStatus) async {
    await _depositStatusInsertionAdapter.insert(
        depositStatus, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDepositStatus(DepositStatus depositStatus) async {
    await _depositStatusDeletionAdapter.delete(depositStatus);
  }
}

class _$InvoiceStatusDao extends InvoiceStatusDao {
  _$InvoiceStatusDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _invoiceStatusInsertionAdapter = InsertionAdapter(
            database,
            'invoiceStatus',
            (InvoiceStatus item) =>
                <String, Object?>{'id': item.id, 'status': item.status},
            changeListener),
        _invoiceStatusDeletionAdapter = DeletionAdapter(
            database,
            'invoiceStatus',
            ['id'],
            (InvoiceStatus item) =>
                <String, Object?>{'id': item.id, 'status': item.status},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<InvoiceStatus> _invoiceStatusInsertionAdapter;

  final DeletionAdapter<InvoiceStatus> _invoiceStatusDeletionAdapter;

  @override
  Stream<List<InvoiceStatus>> observeInvoiceStatus() {
    return _queryAdapter.queryListStream('SELECT * FROM invoiceStatus',
        mapper: (Map<String, Object?> row) =>
            InvoiceStatus(status: row['status'] as String),
        queryableName: 'invoiceStatus',
        isView: false);
  }

  @override
  Future<void> addInvoiceStatus(InvoiceStatus invoiceStatus) async {
    await _invoiceStatusInsertionAdapter.insert(
        invoiceStatus, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteInvoiceStatus(InvoiceStatus invoiceStatus) async {
    await _invoiceStatusDeletionAdapter.delete(invoiceStatus);
  }
}
