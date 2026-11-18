// ============================================================================
// FILE: lib/main.dart
// VAI TRÒ: Điểm khởi động của ứng dụng ôn thi giấy phép lái xe
// (hạng A1, B, C1, C).
// Trước khi chạy giao diện phải đọc xong dữ liệu đã lưu (tiến độ học), nên
// main() là hàm async và gọi LuuTru.khoiTao() trước runApp().
// ============================================================================

import 'package:flutter/material.dart';

import 'screens/man_hinh_chinh.dart';
import 'services/luu_tru.dart';

Future<void> main() async {
  // Cần thiết khi dùng plugin (shared_preferences) trước runApp.
  WidgetsFlutterBinding.ensureInitialized();
  await LuuTru.instance.khoiTao();
  runApp(const OnThiA1());
}

class OnThiA1 extends StatelessWidget {
  const OnThiA1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ôn thi giấy phép lái xe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const ManHinhChinh(),
    );
  }
}
