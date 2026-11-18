// ============================================================================
// FILE: lib/screens/bien_bao_screen.dart
// VAI TRÒ: Tab "Biển báo": tra cứu biển báo theo 4 nhóm (cấm, nguy hiểm,
// hiệu lệnh, chỉ dẫn). Mỗi dòng có hình vẽ, mã, tên và ý nghĩa.
// ============================================================================

import 'package:flutter/material.dart';

import '../data/bien_bao_data.dart';
import '../widgets/bien_bao_widget.dart';

class BienBaoScreen extends StatelessWidget {
  const BienBaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController + TabBar + TabBarView: các tab trượt qua lại.
    return DefaultTabController(
      length: NhomBienBao.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Biển báo'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [for (final n in NhomBienBao.values) Tab(text: n.ten)],
          ),
        ),
        body: TabBarView(
          children: [
            for (final n in NhomBienBao.values)
              ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final b in danhSachBienBao.where((x) => x.nhom == n))
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BienBaoWidget(ma: b.ma, size: 72),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${b.ma} - ${b.ten}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  const SizedBox(height: 4),
                                  Text(b.yNghia),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Hình vẽ mang tính minh hoạ, hãy đối chiếu biển thật trong tài liệu chính thức.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
