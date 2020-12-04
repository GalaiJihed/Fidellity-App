import 'dart:async';
import 'dart:io' as io;

import 'package:app/models/Event.dart';
import 'package:app/models/Order.dart';
import 'package:app/models/Product.dart';
import 'package:app/models/Productsline.dart';
import 'package:app/models/Store.dart';
import 'package:app/models/User.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBClient {
  static Database _db;
  //DB NAME
  static const String DB_NAME = 'user.db';
  //USER COLUMNS AND TABLE NAME
  static const String TABLE = 'client';
  static const String ID = 'id';
  static const String FIRSTNAME = 'firstName';
  static const String LASTNAME = 'lastName';
  static const String EMAIL = 'email';
  static const String ADDRESS = 'address';
  static const String PHONENUMBER = 'phoneNumber';
  static const String COUNTRYCODE = 'countryCode';
  static const String COUNTRY = 'country';
  static const String POSTALCODE = 'postalCode';
  static const String CITY = 'city';
  static const String FIDELITYPOINTS = 'fidelityPoints';
  static const String BIRTHDATE = 'birthDate';
  static const String CREATEDAT = 'createdAt';
  static const String UPDATEDAT = 'updatedAt';
  static const String IMAGE = 'image';

  // STORE COLUMNS AND TABLE NAME
  static const String TABLE_STORE = 'store';
  static const String ID_STORE = 'id';
  static const String STORE_NAME = 'StoreName';
  static const String STORE_ADDRESS = 'StoreAdress';
  static const String STORE_TYPE = 'StoreType';
  static const String STORE_NOTES = 'StoreNotes';
  static const String STORE_IMAGE = 'Image';
  static const String STORE_POINTS_CLIENT = 'pointsInCurrentStore';
  //Event COLUMNS AND TABLE NAME
  static const String TABLE_EVENT = 'event';
  static const String ID_EVENT = 'id';
  static const String EVENT_NAME = 'eventName';
  static const String EVENT_TYPE = 'eventType';
  static const String EVENT_DATE = 'eventDate';
  static const String EVENT_CREATION_DATE = 'dateCreation';
  static const String EVENT_ACCEPTED_DATE = 'date';
  static const String EVENT_STORE = 'storeId';

  //Product COLUMNS AND TABLE NAME
  static const String TABLE_PRODUCT = 'product';
  static const String ID_PRODUCT = 'id';
  static const String PRODUCT_NAME = 'ProductName';
  static const String PRODUCT_REF = 'Reference';
  static const String PRODUCT_PRICE = 'Price';
  static const String PRODUCT_PROMO_PRICE = 'PromoPrice';
  static const String PRODUCT_IMAGE = 'Image';
  static const String PRODUCT_FP = 'FP';
  static const String PRODUCT_STORE = 'storeId';

  //ProductLine COLUMNS AND TABLE NAME
  static const String TABLE_PRODUCTLINE = 'productline';
  static const String ID_PRODUCTLINE = 'id';
  static const String PRODUCTLINE_QUANTITY = 'quantity';
  static const String PRODUCTLINE_DATE = 'date';
  static const String PRODUCTLINE_PRODUCT_ID = 'productId';
  static const String PRODUCTLINE_ORDER_ID = 'orderId';

  //Order COLUMNS AND TABLE NAME
  static const String TABLE_ORDER = 'myOrder';
  static const String ID_ORDER = 'id';
  static const String ORDER_DATE = 'date';
  static const String ORDER_TOTAL_PRICE = 'totalprice';
  static const String ORDER_TOTAL_NEW_PRICE = 'totalnewprice';
  static const String ORDER_FIDELITY_POINTS_GAINED = 'fpgained';
  static const String ORDER_FIDELITY_POINTS_USED = 'fpused';
  static const String ORDER_STORE_ID = 'storeid';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

//Create Database and Tables
  Future<void> ReCreate() async {
    //here we get the Database object by calling the openDatabase method
    //which receives the path and onCreate function and all the good stuff
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);

    //here we execute a query to drop the table if exists which is called "tableName"
    //and could be given as method's input parameter too
    /*await db.execute("DROP TABLE IF EXISTS client");
    print("Table Droped");*/

    _onCreate(db, 1);
    _onCreateStore(db, 1);
    _onCreateEvent(db, 1);
    _onCreateProduct(db, 1);
    _onCreateProductLine(db, 1);
    _onCreateOrder(db, 1);
    //print("Table Created.");
    //and finally here we recreate our beloved "tableName" again which needs
    //some columns initialization
    //await db.execute("CREATE TABLE tableName (id INTEGER, name TEXT)");
  }

//User
  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TABLE ($ID INTEGER PRIMARY KEY, "
        "$BIRTHDATE TIMESTAMP, $CREATEDAT TIMESTAMP, "
        "$UPDATEDAT TIMESTAMP, $FIRSTNAME TEXT,$LASTNAME TEXT,"
        "$EMAIL TEXT,$ADDRESS TEXT,$PHONENUMBER INTEGER,"
        "$COUNTRYCODE INTEGER,$COUNTRY TEXT,$POSTALCODE INTEGER,$IMAGE TEXT,"
        "$CITY TEXT,$FIDELITYPOINTS INTEGER)");
    print("Table user created ");
  }

  onDrop() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    await db.execute("DROP TABLE IF EXISTS client");
    print("Table Client Droped.");
  }

  Future<User> save(User user) async {
    var dbClient = await db;
    user.id = (await dbClient.insert(TABLE, user.toMap()));
    //  print("User Added.");
    return user;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  Future<List<User>> getClients() async {
    var dbClient = await db;
    // List<Map> maps = await dbClient.query(TABLE, columns: [ID, FIRSTNAME,LASTNAME,PHONENUMBER,ADDRESS,COUNTRY,COUNTRYCODE,CITY,FIDELITYPOINTS]);
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<User> clients = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        clients.add(User.fromMap(maps[i]));
      }
    }
    return clients;
  }

  Future<User> getCurrentUser() async {
    var dbClient = await db;
    // List<Map> maps = await dbClient.query(TABLE, columns: [ID, FIRSTNAME,LASTNAME,PHONENUMBER,ADDRESS,COUNTRY,COUNTRYCODE,CITY,FIDELITYPOINTS]);
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    return User.fromMap(maps[0]);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(User client) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, client.toMap(),
        where: '$ID = ?', whereArgs: [client.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  //Store
  _onCreateStore(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TABLE_STORE ($ID_STORE INTEGER PRIMARY KEY, "
        "$STORE_NAME TEXT,$STORE_ADDRESS TEXT,$STORE_TYPE TEXT,$STORE_NOTES INTEGER,$STORE_IMAGE TEXT, $STORE_POINTS_CLIENT INTEGER)");
    print("Table store created ");
  }

  onDropStore() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    await db.execute("DROP TABLE IF EXISTS store");
    print("Table Store Droped.");
  }

  Future<Store> saveStore(Store store) async {
    var dbClient = await db;
    store.id = (await dbClient.insert(TABLE_STORE, store.toMap()));
    //  print("Store Added.");
    return store;
  }

  Future<List<Store>> getStores() async {
    var dbStore = await db;
    List<Map> maps = await dbStore.rawQuery("SELECT * FROM $TABLE_STORE");
    List<Store> stores = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        stores.add(Store.fromMap(maps[i]));
      }
    }
    return stores;
  }

  Future<Store> getStoreById(int id) async {
    var dbStore = await db;
    var results =
        await dbStore.rawQuery('SELECT * FROM $TABLE_STORE WHERE id = $id');

    if (results.length > 0) {
      return new Store.fromMap(results.first);
    }

    return null;
  }

  Future<int> updateStore(Store store) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_STORE, store.toMap(),
        where: '$ID_STORE = ?', whereArgs: [store.id]);
  }

  //Event
  _onCreateEvent(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TABLE_EVENT($ID_EVENT INTEGER PRIMARY KEY, "
        "$EVENT_NAME TEXT,$EVENT_TYPE TEXT,"
        "$EVENT_DATE TIMESTAMP,$EVENT_CREATION_DATE TIMESTAMP, $EVENT_ACCEPTED_DATE TIMESTAMP,$EVENT_STORE INTEGER)");
    print("Table Event created ");
  }

  onDropEvent() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    await db.execute("DROP TABLE IF EXISTS $TABLE_EVENT");
    print("Table Event Droped.");
  }

  Future<Event> saveEvent(Event event) async {
    var dbClient = await db;
    event.id = (await dbClient.insert(TABLE_EVENT, event.toMap()));
    //print("Event Added.");
    return event;
  }

  Future<List<Event>> getEvents() async {
    var dbEvent = await db;
    List<Map> maps = await dbEvent.rawQuery("SELECT * FROM $TABLE_EVENT");
    List<Event> events = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        events.add(Event.fromMap(maps[i]));
      }
    }
    return events;
  }

  Future<int> updateEvent(Event event) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_EVENT, event.toMap(),
        where: '$ID_EVENT = ?', whereArgs: [event.id]);
  }

  //Product
  _onCreateProduct(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TABLE_PRODUCT($ID_PRODUCT INTEGER PRIMARY KEY, "
        "$PRODUCT_NAME TEXT,$PRODUCT_IMAGE TEXT,$PRODUCT_REF TEXT,$PRODUCT_PRICE REAL,$PRODUCT_PROMO_PRICE REAL,"
        "$PRODUCT_FP REAL,$PRODUCT_STORE INTEGER)");
    print("Table Product created ");
  }

  onDropProduct() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    await db.execute("DROP TABLE IF EXISTS $TABLE_PRODUCT");
    print("Table Product Droped.");
  }

  Future<Product> saveProduct(Product product, int storeId) async {
    var dbClient = await db;
    product.id = (await dbClient.insert(TABLE_PRODUCT, product.toMap(storeId)));
    int id = product.id;

    // print("Product $id Added. Store $storeId");
    return product;
  }

  Future<List<Product>> getProducts() async {
    var dbEvent = await db;
    List<Map> maps = await dbEvent.rawQuery("SELECT * FROM $TABLE_PRODUCT");
    List<Product> products = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        products.add(Product.fromMap(maps[i]));
      }
    }
    return products;
  }

  Future<List<Product>> getProductsByStoreId(int storeId) async {
    var dbEvent = await db;
    List<Map> maps = await dbEvent
        .rawQuery("SELECT * FROM $TABLE_PRODUCT WHERE storeId = $storeId");
    List<Product> products = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        products.add(Product.fromMap(maps[i]));
      }
    }
    return products;
  }

  Future<Product> getProductById(int id) async {
    var dbStore = await db;
    var results =
        await dbStore.rawQuery('SELECT * FROM $TABLE_PRODUCT WHERE id = $id');

    if (results.length > 0) {
      return new Product.fromMap(results.first);
    }

    return null;
  }

  Future<int> updateProduct(Product product, int StoreId) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_PRODUCT, product.toMap(StoreId),
        where: '$ID_PRODUCT = ?', whereArgs: [product.id]);
  }

  //ProductLine
  _onCreateProductLine(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TABLE_PRODUCTLINE($ID_PRODUCTLINE INTEGER PRIMARY KEY, "
        "$PRODUCTLINE_QUANTITY INTEGER,$PRODUCTLINE_DATE TIMESTAMP,$PRODUCTLINE_ORDER_ID INTEGER,$PRODUCTLINE_PRODUCT_ID INTEGER)");
    print("Table ProductLine created ");
  }

  onDropProductLine() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    await db.execute("DROP TABLE IF EXISTS $TABLE_PRODUCTLINE");
    print("Table ProductLine Droped.");
  }

  saveProductLine(Productsline productsline, int orderId) async {
    var dbClient = await db;
    await dbClient.insert(TABLE_PRODUCTLINE, productsline.toMap(orderId));
    //  print("ProductLine " + productsline.quantity.toString() + " Inserted.");
  }

  Future<List<Productsline>> getProductLinesByOrderId(int orderId) async {
    var dbEvent = await db;
    List<Map> maps = await dbEvent
        .rawQuery("SELECT * FROM $TABLE_PRODUCTLINE WHERE orderId = $orderId");
    List<Productsline> productsline = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Product p = await getProductById(maps[i]["productId"]);
        productsline.add(Productsline.fromMap(maps[i], p));
      }
    }
    return productsline;
  }

  Future<int> updateProductLine(Productsline productLine, int orderId) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_PRODUCTLINE, productLine.toMap(orderId),
        where: '$ID_PRODUCTLINE = ?', whereArgs: [productLine]);
  }

  //Order Service
  _onCreateOrder(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TABLE_ORDER($ID_ORDER INTEGER PRIMARY KEY, "
        "$ORDER_TOTAL_NEW_PRICE REAL, $ORDER_DATE TIMESTAMP, $ORDER_TOTAL_PRICE INTEGER, "
        "$ORDER_FIDELITY_POINTS_GAINED REAL, $ORDER_FIDELITY_POINTS_USED INTEGER, $ORDER_STORE_ID INTEGER)");
    print("Table Order created ");
  }

  onDropOrder() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    await db.execute("DROP TABLE IF EXISTS $TABLE_ORDER");
    print("Table Order Droped.");
  }

  saveOrder(Order order, int storeId) async {
    var dbClient = await db;
    await dbClient.insert(TABLE_ORDER, order.toMap(storeId));
    //  print("ProductLine " + productsline.quantity.toString() + " Inserted.");
  }

  Future<List<Order>> getAllOrders() async {
    var dbEvent = await db;
    List<Map> maps = await dbEvent.rawQuery("SELECT * FROM $TABLE_ORDER");
    List<Order> Orders = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        List<Productsline> productlines = [];
        productlines = await getProductLinesByOrderId(maps[i]["id"]);
        print("ProductLine length db : " + productlines.length.toString());
        Store store = await getStoreById(maps[i]["storeid"]);

        Orders.add(Order.fromMap(maps[i], productlines, store));
      }
    }
    return Orders;
  }

  Future<List<Order>> getOrdersByStoreId(Store store) async {
    int storeid = store.id;
    var dbEvent = await db;
    List<Map> maps = await dbEvent
        .rawQuery("SELECT * FROM $TABLE_ORDER WHERE storeid = $storeid");
    List<Order> Orders = [];
    if (maps.length > 0) {
      print(maps.length);
      for (int i = 0; i < maps.length; i++) {
        List<Productsline> productlines = [];
        productlines = await getProductLinesByOrderId(maps[i]["id"]);

        Orders.add(Order.fromMap(maps[i], productlines, store));
      }
    }
    Orders.forEach((f) => print(f));

    return Orders;
  }

  Future<int> updateOrder(Order order, int idStore) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_ORDER, order.toMap(idStore),
        where: '$ID_ORDER = ?', whereArgs: [order.id]);
  }
}
