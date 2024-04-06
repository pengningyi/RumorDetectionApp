import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/auth_service.dart';
import '../widgets/menu/menu.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _permissionRequested = false;

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
  }
  Future<void> _requestStoragePermission() async {
    // 检查是否已经请求过权限
    if (!_permissionRequested) {
      // 检查是否已经获取了存储权限
      PermissionStatus status = await Permission.storage.status;
      print(status);
      // 如果权限被拒绝，则请求权限
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // 标记权限请求完成
      setState(() {
        _permissionRequested = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    // final currentUser = authService.getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
        // title: const Text("Welcome to PerfectCV"),
        leading: const MyMenu(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.title,
            ),
            // Text('Welcome, ${currentUser!.email}'),
            ElevatedButton(
              onPressed: () => authService.signOut(),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape:
            const CircularNotchedRectangle(), // This is the key for having a floating action button hole
        notchMargin: 8.0, // Margin for the notch
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllPostsScreen()),
                );
              },
            ),
            const SizedBox(), // This is the hole
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LabelPostsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const EntryForm(),
          );
        },
        shape: const CircleBorder(), // 设置按钮形状为圆形
        elevation: 2.0,
        child: const Icon(Icons.add), // Adjust elevation as needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
