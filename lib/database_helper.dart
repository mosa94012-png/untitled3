import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gold_workshop_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // العملاء
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        balance REAL DEFAULT 0
      )
    ''');

    // الطلبات
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_name TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT,
        weight REAL,
        amount REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // المخزون
    await db.execute('''
      CREATE TABLE inventory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        weight REAL NOT NULL,
        karat INTEGER DEFAULT 21,
        labor_cost REAL DEFAULT 0
      )
    ''');

    // المصاريف
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        notes TEXT
      )
    ''');

    // العمال
    await db.execute('''
      CREATE TABLE workers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        salary REAL DEFAULT 0,
        specialty TEXT
      )
    ''');

    // سعر الذهب
    await db.execute('''
      CREATE TABLE gold_price (
        id INTEGER PRIMARY KEY,
        price_21 REAL DEFAULT 245
      )
    ''');

    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    await db.insert('customers', {'name': 'أحمد محمد', 'phone': '0501111111', 'balance': 1500});
    await db.insert('customers', {'name': 'خالد العلي', 'phone': '0502222222', 'balance': -500});

    await db.insert('orders', {
      'customer_name': 'أحمد محمد',
      'type': 'بيع',
      'description': 'خاتم + سلسلة',
      'weight': 15.5,
      'amount': 3500,
      'date': DateTime.now().toIso8601String(),
    });

    await db.insert('inventory', {'name': 'خاتم زواج', 'type': 'ذهب', 'weight': 12.5, 'karat': 21, 'labor_cost': 150});
    await db.insert('expenses', {'title': 'إيجار المحل', 'amount': 5000, 'date': DateTime.now().toIso8601String(), 'notes': 'شهر يناير'});
    await db.insert('workers', {'name': 'محمد الصائغ', 'phone': '0504444444', 'salary': 3000, 'specialty': 'صياغة'});
    await db.insert('gold_price', {'id': 1, 'price_21': 245});
  }

  // ... (نفس دوال CRUD السابقة)
  Future<List<Map<String, dynamic>>> getCustomers() async {
    final db = await database;
    return await db.query('customers', orderBy: 'name');
  }

  Future<void> addCustomer(String name, String phone) async {
    final db = await database;
    await db.insert('customers', {'name': name, 'phone': phone, 'balance': 0});
  }

  Future<void> deleteCustomer(int id) async {
    final db = await database;
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('orders', orderBy: 'date DESC');
  }

  Future<void> addOrder(String name, String type, String desc, double weight, double amount) async {
    final db = await database;
    await db.insert('orders', {
      'customer_name': name,
      'type': type,
      'description': desc,
      'weight': weight,
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteOrder(int id) async {
    final db = await database;
    await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getInventory() async {
    final db = await database;
    return await db.query('inventory', orderBy: 'name');
  }

  Future<void> addInventory(String name, String type, double weight, int karat, double labor) async {
    final db = await database;
    await db.insert('inventory', {
      'name': name,
      'type': type,
      'weight': weight,
      'karat': karat,
      'labor_cost': labor,
    });
  }

  Future<void> deleteInventory(int id) async {
    final db = await database;
    await db.delete('inventory', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;
    return await db.query('expenses', orderBy: 'date DESC');
  }

  Future<void> addExpense(String title, double amount, String notes) async {
    final db = await database;
    await db.insert('expenses', {
      'title': title,
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
      'notes': notes,
    });
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getWorkers() async {
    final db = await database;
    return await db.query('workers', orderBy: 'name');
  }

  Future<void> addWorker(String name, String phone, double salary, String specialty) async {
    final db = await database;
    await db.insert('workers', {
      'name': name,
      'phone': phone,
      'salary': salary,
      'specialty': specialty,
    });
  }

  Future<void> deleteWorker(int id) async {
    final db = await database;
    await db.delete('workers', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getReports() async {
    final db = await database;
    final sales = await db.rawQuery('SELECT SUM(amount) as total FROM orders WHERE type = "بيع"');
    final purchases = await db.rawQuery('SELECT SUM(amount) as total FROM orders WHERE type = "شراء"');
    final expenses = await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
    final goldWeight = await db.rawQuery('SELECT SUM(weight) as total FROM inventory WHERE type = "ذهب"');

    return {
      'sales': (sales.first['total'] as num?)?.toDouble() ?? 0.0,
      'purchases': (purchases.first['total'] as num?)?.toDouble() ?? 0.0,
      'expenses': (expenses.first['total'] as num?)?.toDouble() ?? 0.0,
      'profit': ((sales.first['total'] as num?)?.toDouble() ?? 0.0) -
          ((purchases.first['total'] as num?)?.toDouble() ?? 0.0) -
          ((expenses.first['total'] as num?)?.toDouble() ?? 0.0),
      'gold_weight': (goldWeight.first['total'] as num?)?.toDouble() ?? 0.0,
    };
  }

  Future<double> getGoldPrice() async {
    final db = await database;
    final result = await db.query('gold_price', where: 'id = 1');
    return result.isNotEmpty ? ((result.first['price_21'] as num?)?.toDouble() ?? 245) : 245;
  }

  Future<void> updateGoldPrice(double price) async {
    final db = await database;
    await db.update('gold_price', {'price_21': price}, where: 'id = 1');
  }
}