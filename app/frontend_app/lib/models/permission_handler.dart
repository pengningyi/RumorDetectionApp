// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PermissionHandler {
//   static Future<bool> requestStoragePermission(BuildContext context) async {
//     PermissionStatus status = await Permission.storage.request();
//     if (status.isGranted) {
//       return true;
//     } else if (status.isDenied) {
//       await _showPermissionRequestDialog(context);
//       // 用户拒绝了权限，显示权限请求弹窗
//     } else if (status.isPermanentlyDenied) {
//       // 用户永久拒绝了权限，通常需要引导用户手动去设置中开启权限
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Storage permission is permanently denied. Please grant permission from device settings.'),
//       ));
//     }
//     return false;
//   }

//   // 请求存储权限的弹窗
//   static Future<void> _showPermissionRequestDialog(context) async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Permission Required'),
//           content: Text('Storage permission is required to use this app.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
