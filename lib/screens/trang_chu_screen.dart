// ============================================================================
// FILE: lib/screens/trang_chu_screen.dart
// VAI TRÒ: Tab "Trang chủ".
//   - Chọn HẠNG bằng đang học (A1, B, C1, C). Đổi hạng thì toàn bộ app
//     (ôn tập, thi thử, thống kê) đổi theo.
//   - Thẻ tiến độ của hạng đang chọn.
//   - Nút "Thi thử" theo đúng cấu trúc đề của hạng (số câu, thời gian).
//   - Nút "Ôn câu sai", "10 câu ngẫu nhiên".
//   - Thẻ tóm tắt hạng + nút mở màn hình "Quy định".
// ============================================================================

import 'package:flutter/material.dart';

import '../data/tao_de.dart';
import '../models/hang_bang.dart';
import '../services/luu_tru.dart';
import 'lam_bai_screen.dart';
import 'quy_dinh_screen.dart';

class TrangChuScreen extends StatelessWidget {
  const TrangChuScreen({super.key});

  void _mo(BuildContext context, Widget m) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => m));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Ôn thi giấy phép lái xe')),
      // ListenableBuilder: LuuTru đổi dữ liệu (kể cả đổi hạng) thì tự vẽ lại.
      body: ListenableBuilder(
        listenable: LuuTru.instance,
        builder: (context, _) {
          final luu = LuuTru.instance;
          final hang = luu.hang;
          final ct = hang.cauTruc(); // cấu trúc đề đang có hiệu lực hôm nay
          final ds = cauCuaHang(hang);
          final tong = ds.length;
          final dung = ds.where((c) => luu.dung.contains(c.id)).length;
          final sai = ds.where((c) => luu.sai.contains(c.id)).length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---- Chọn hạng ----
              Text('Bạn đang ôn hạng nào?',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<HangBang>(
                  showSelectedIcon: false,
                  segments: [
                    for (final h in HangBang.values)
                      ButtonSegment(value: h, label: Text(h.ma)),
                  ],
                  selected: {hang},
                  onSelectionChanged: (s) => luu.chonHang(s.first),
                ),
              ),
              const SizedBox(height: 16),

              // ---- Thẻ tiến độ ----
              Card(
                color: cs.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tiến độ hạng ${hang.ma} (${hang.tenNgan})',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: tong == 0 ? 0 : dung / tong,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 8),
                      Text('Đã làm đúng $dung/$tong câu  ·  Cần ôn lại $sai câu'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ---- Nút thi thử ----
              FilledButton.icon(
                style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18)),
                icon: const Icon(Icons.timer),
                label: Text(
                    'Thi thử hạng ${hang.ma} (${ct.soCau} câu, ${ct.phut} phút)'),
                onPressed: () => _mo(
                  context,
                  LamBaiScreen(
                    tieuDe: 'Thi thử hạng ${hang.ma}',
                    cauHoi: taoDeThi(hang, ct),
                    cheDo: CheDo.thiThu,
                    hang: hang,
                    cauTruc: ct,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ---- Hai nút phụ ----
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.error_outline),
                      label: Text('Ôn câu sai ($sai)'),
                      // Không có câu sai thì khoá nút.
                      onPressed: sai == 0
                          ? null
                          : () => _mo(
                                context,
                                LamBaiScreen(
                                  tieuDe: 'Ôn câu sai',
                                  cauHoi: cauSai(hang, luu.sai),
                                  cheDo: CheDo.onTap,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.shuffle),
                      label: const Text('10 câu ngẫu nhiên'),
                      onPressed: () => _mo(
                        context,
                        LamBaiScreen(
                          tieuDe: 'Ngẫu nhiên',
                          cauHoi: cauNgauNhien(hang, 10),
                          cheDo: CheDo.onTap,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ---- Tóm tắt hạng + mở màn hình quy định ----
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đề thi lý thuyết hạng ${hang.ma}',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Text('• ${ct.soCau} câu trắc nghiệm, làm trong ${ct.phut} phút'),
                      Text('• Đạt khi đúng từ ${ct.diemDat}/${ct.soCau} câu trở lên'),
                      const Text('• Có 1 câu điểm liệt: sai là trượt dù đủ điểm'),
                      Text('• Tuổi tối thiểu: ${hang.tuoi}  ·  Thời hạn bằng: ${hang.thoiHan}'),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          icon: const Icon(Icons.menu_book),
                          label: Text('Xem quy định hạng ${hang.ma}'),
                          onPressed: () =>
                              _mo(context, QuyDinhScreen(hang: hang)),
                        ),
                      ),
                      Text(
                        'Lưu ý: bộ câu hỏi trong ứng dụng là bộ mẫu để luyện tập, '
                        'không phải ngân hàng đề chính thức. Hãy đối chiếu bộ đề '
                        'và quy định hiện hành trước khi đi thi.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
