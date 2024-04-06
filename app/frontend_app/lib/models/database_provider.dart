import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './post.dart';

class DatabaseProvider with ChangeNotifier {
  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String value) {
    _searchText = value;
    notifyListeners(); // when the value of the search text changes it will notify the widgets.
  }

  // in-app memory for holding the Entry categories temporarily
  List<Post> _posts = [];

  List<Post> get posts {
    return _searchText != ''
        ? _posts
            .where((post) =>
                post.content.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
        : _posts;
  }

  Database? _database;
Future<Database> get database async {
  try {
    final dbDirectory = await getDatabasesPath();
    const dbName = 'RumorGuardian.db';
    final path = join(dbDirectory, dbName);

    // 打开数据库，如果不存在则创建
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  } catch (e) {
    // 捕获异常并打印错误信息
    print('Error opening database: $e');
    rethrow; // 重新抛出异常，以便上层调用者处理
  }
}

  // _createDb function
  static const postTable = 'postTable';


  Future<void> _createDb(Database db, int version) async {

    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE IF NOT EXISTS $postTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT,
        userDescription TEXT,
        time TEXT,
        area TEXT,
        commentsCount TEXT,
        repostCount TEXT,
        followerCount TEXT,
        content TEXT,
        isRumor TEXT,
        );''');
    });
  }

  Future<void> insertEntry(Post post) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(
        postTable,
        post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((generatedId) {
        final newPost = Post(
          id: generatedId,
          user: post.user,
          userDescription: post.userDescription,
          time: post.time,
          area: post.area,
          commentsCount: post.commentsCount,
          repostCount: post.repostCount,
          followerCount: post.followerCount,
          content: post.content,
          isRumor: post.isRumor,
        );
        _posts.add(newPost);
        notifyListeners();
      });
      // after we inserted the entry, we need to update the 'entries' and 'totalAmount' of the related 'category'
    });
  }

  Future<void> updateEntry(Post post) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update(postTable, post.toMap(),
          where: 'id == ?', whereArgs: [post.id]).then((_) {
        // Update in-app memory too
        int index = _posts.indexWhere((element) => element.id == post.id);
        if (index != -1) {
          _posts[index] = post;
          notifyListeners();
        }
      });
    });
  }



  Future<void> deleteEntry(int id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(postTable, where: 'id == ?', whereArgs: [id]).then((_) {
        // remove from in-app memory too
        _posts.removeWhere((element) => element.id == id);
        notifyListeners();
      });
    });
  }

  Future<List<Post>> fetchAllPosts() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(postTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Post> nList = List.generate(
            converted.length, (index) => Post.fromMap(converted[index]));
        _posts = nList;
        notifyListeners();
        return _posts;
      });
    });
  }

}
