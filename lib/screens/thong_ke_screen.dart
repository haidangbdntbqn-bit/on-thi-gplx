// ============================================================================
// FILE: lib/screens/thong_ke_screen.dart
// VAI TRÒ: Tab "Thống kê":
//   - Số câu đúng / sai / chưa làm của HẠNG đang chọn.
//   - Lịch sử các lần thi thử của mọi hạng (hạng, ngày giờ, điểm, kết quả).
//   - Nút "Xoá toàn bộ tiến độ" (có hỏi xác nhận).
// ============================================================================

import 'package:flutter/material.dart';

import '../data/tao_de.dart';
import '../services/luu_tru.dart';
import '../utils/dinh_dang.dart';

class ThongKeScreen extends StatelessWidget {
  const ThongKeScreen({super.key});

  Future<void> _hoiXoa(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá tiến độ?'),
        content: const Text(
            'Toàn bộ câu đã làm và lịch sử thi thử sẽ bị xoá, không khôi phục được.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Xoá')),
        ],
      ),
    );
    if (ok == true) LuuTru.instance.xoaTatCa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thống kê')),
      body: ListenableBuilder(
        listenable: LuuTru.instance,
        builder: (context, _) {
          final luu = LuuTru.instance;
          final hang = luu.hang;
          final cau = cauCuaHang(hang);
          final tong = cau.length;
          final dung = cau.where((c) => luu.dung.contains(c.id)).length;
          final sai = cau.where((c) => luu.sai.contains(c.id)).length;
          final chua = tong - dung - sai; // câu chưa từng làm
          final ds = luu.lichSu;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Hạng ${hang.ma}: $tong câu hỏi',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  _O(so: dung, nhan: 'Đúng', mau: Colors.green),
                  _O(so: sai, nhan: 'Sai', mau: Colors.red),
                  _O(so: chua, nhan: 'Chưa làm', mau: Colors.grey),
                ],
              ),
              const SizedBox(height: 20),
              Text('Lịch sử thi thử',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (ds.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('Chưa có lần thi thử nào')),
                )
              else
                for (final k in ds)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        k.dat ? Icons.check_circle : Icons.cancel,
                        color: k.dat ? Colors.green : Colors.red,
                      ),
                      title: Text('Hạng ${k.hang.ma}: ${k.diem}/${k.tong} câu đúng'),
                      subtitle: Text(
                          '${ngayGio(k.ngay)}  ·  ${mmss(k.giay)}'
                          '${k.saiDiemLiet ? '  ·  sai điểm liệt' : ''}'),
                      trailing: Text(k.dat ? 'ĐẠT' : 'TRƯỢT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: k.dat ? Colors.green : Colors.red)),
                    ),
                  ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Xoá toàn bộ tiến độ'),
                onPressed: () => _hoiXoa(context),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Một ô số liệu (đúng / sai / chưa làm).
class _O extends StatelessWidget {
  const _O({required this.so, required this.nhan, required this.mau});

  final int so;
  final String nhan;
  final Color mau;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text('$so',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold, color: mau)),
              Text(nhan),
            ],
          ),
        ),
      ),
    );
  }
}
