// ============================================================================
// FILE: lib/screens/on_tap_screen.dart
// VAI TRÒ: Tab "Ôn tập": danh sách các chương của HẠNG đang chọn, mỗi chương
// có thanh tiến độ (số câu đã đúng / số câu của chương). Bấm để bắt đầu ôn.
// Chương nào hạng đó không có câu hỏi thì ẩn đi (vd A1 không có "Nghiệp vụ
// vận tải").
// ============================================================================

import 'package:flutter/material.dart';

import '../data/tao_de.dart';
import '../models/cau_hoi.dart';
import '../services/luu_tru.dart';
import 'lam_bai_screen.dart';

class OnTapScreen extends StatelessWidget {
  const OnTapScreen({super.key});

  /// Biểu tượng cho từng chương.
  IconData _icon(Chuong c) {
    switch (c) {
      case Chuong.quyTac:
        return Icons.gavel;
      case Chuong.tocDo:
        return Icons.speed;
      case Chuong.vanHoa:
        return Icons.handshake;
      case Chuong.kyThuat:
        return Icons.build;
      case Chuong.bienBao:
        return Icons.traffic;
      case Chuong.vanTai:
        return Icons.local_shipping;
    }
  }

  void _batDau(BuildContext context, String tieuDe, List<CauHoi> ds) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LamBaiScreen(tieuDe: tieuDe, cauHoi: ds, cheDo: CheDo.onTap),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tiêu đề cũng phải đổi theo hạng nên cần ListenableBuilder riêng.
        title: ListenableBuilder(
          listenable: LuuTru.instance,
          builder: (context, _) =>
              Text('Ôn tập hạng ${LuuTru.instance.hang.ma}'),
        ),
      ),
      body: ListenableBuilder(
        listenable: LuuTru.instance,
        builder: (context, _) {
          final hang = LuuTru.instance.hang;
          final dung = LuuTru.instance.dung;
          final tatCa = cauCuaHang(hang);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---- Tất cả câu hỏi ----
              _TheChuong(
                icon: Icons.library_books,
                ten: 'Tất cả câu hỏi',
                tong: tatCa.length,
                dung: tatCa.where((x) => dung.contains(x.id)).length,
                onTap: () => _batDau(context, 'Tất cả câu hỏi', tatCa),
              ),
              // ---- Từng chương (bỏ qua chương không có câu cho hạng này) ----
              for (final c in Chuong.values)
                Builder(builder: (context) {
                  final ds = cauTheoChuong(hang, c);
                  if (ds.isEmpty) return const SizedBox.shrink();
                  final soDung = ds.where((x) => dung.contains(x.id)).length;
                  return _TheChuong(
                    icon: _icon(c),
                    ten: c.ten,
                    tong: ds.length,
                    dung: soDung,
                    onTap: () => _batDau(context, c.ten, ds),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

/// Thẻ một chương: biểu tượng, tên, số câu và thanh tiến độ.
class _TheChuong extends StatelessWidget {
  const _TheChuong({
    required this.icon,
    required this.ten,
    required this.tong,
    required this.dung,
    required this.onTap,
  });

  final IconData icon;
  final String ten;
  final int tong;
  final int dung;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(child: Icon(icon)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ten, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text('Đúng $dung/$tong câu',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: tong == 0 ? 0 : dung / tong,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
