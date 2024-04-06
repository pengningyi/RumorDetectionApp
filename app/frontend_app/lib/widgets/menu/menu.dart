import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/auth_service.dart';
import './setting_page.dart';

class MyMenu extends StatelessWidget {
  const MyMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.getCurrentUser();

    return PopupMenuButton(
      itemBuilder: (BuildContext context) => [
        // 根据用户登录状态显示不同的菜单内容
        if (currentUser != null)
          const PopupMenuItem(
            value: "sign_out",
            child: Text("Sign Out"),
          )
        else
          const PopupMenuItem(
            value: "sign_in",
            child: Text("Sign In"),
          ),
        const PopupMenuItem(
          value: "account",
          child: Text("Account"),
        ),
        const PopupMenuItem(
          value: "help_feedback",
          child: Text("Help & Feedback"),
        ),
        const PopupMenuItem(
          value: "settings",
          child: Text("Settings"),
        ),
        const PopupMenuItem(
          value: "about",
          child: Text("About"),
        ),
      ],
      onSelected: (value) {
        // 处理菜单项选择
        if (value == 'settings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        } else if (value == 'sign_in') {
          // 处理登录选项
          print('Sign In');
        } else if (value == 'sign_out') {
          // 处理登出选项
          print('Sign Out');
        } else if (value == 'account') {
          // 处理账户选项
          print('Account');
        } else if (value == 'help_feedback') {
          // 处理帮助与反馈选项
          print('Help & Feedback');
        }
        print('Selected: $value');
      },
    );
  }
}