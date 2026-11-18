// ============================================================================
// FILE: lib/screens/man_hinh_chinh.dart
// VAI TRÒ: Khung chính của app: thanh điều hướng dưới cùng với 4 tab
//   0 Trang chủ  ·  1 Ôn tập  ·  2 Biển báo  ·  3 Thống kê
// Mỗi tab là một màn hình riêng (có AppBar riêng). IndexedStack giữ nguyên
// trạng thái từng tab khi chuyển qua lại (vd vị trí cuộn, tab biển báo).
// ============================================================================

import 'package:flutter/material.dart';

import 'bien_bao_screen.dart';
import 'on_tap_screen.dart';
import 'thong_ke_screen.dart';
import 'trang_chu_screen.dart';

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({super.key});

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  int tab = 0;

  static const _trang = <Widget>[
    TrangChuScreen(),
    OnTapScreen(),
    BienBaoScreen(),
    ThongKeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: tab, children: _trang),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Trang chủ'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Ôn tập'),
          NavigationDestination(icon: Icon(Icons.traffic), label: 'Biển báo'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Thống kê'),
        ],
      ),
    );
  }
}
