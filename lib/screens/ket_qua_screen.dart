// ============================================================================
// FILE: lib/screens/ket_qua_screen.dart
// VAI TRÒ: Màn hình KẾT QUẢ sau khi nộp bài thi thử.
//   - Hiện ĐẠT / TRƯỢT, điểm, thời gian làm bài, lý do (nếu sai câu điểm liệt).
//   - Liệt kê các câu làm sai kèm đáp án đúng và giải thích.
//   - Nút "Thi lại" (tạo đề mới) và "Về trang chủ".
// ============================================================================

import 'package:flutter/material.dart';

import '../data/tao_de.dart';
import '../models/cau_hoi.dart';
import '../models/ket_qua_thi.dart';
import '../utils/dinh_dang.dart';
import '../widgets/bien_bao_widget.dart';
import 'lam_bai_screen.dart';

class KetQuaScreen extends StatelessWidget {
  const KetQuaScreen({
    super.key,
    required this.ketQua,
    required this.cauHoi,
    required this.chon,
  });

  final KetQuaThi ketQua;

  /// Các câu của đề vừa thi, theo đúng thứ tự.
  final List<CauHoi> cauHoi;

  /// Đáp án người dùng đã chọn (null = bỏ trống), cùng thứ tự với [cauHoi].
  final List<int?> chon;

  @override
  Widget build(BuildContext context) {
    final dat = ketQua.dat;
    final mau = dat ? Colors.green : Colors.red;

    // Chỉ số các câu làm sai (bỏ trống cũng tính là sai).
    final sai = [
      for (var j = 0; j < cauHoi.length; j++)
        if (chon[j] != cauHoi[j].dung) j
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Kết quả thi thử hạng ${ketQua.hang.ma}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: mau.withValues(alpha: 0.12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(dat ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                      size: 56, color: mau),
                  const SizedBox(height: 8),
                  Text(
                    dat ? 'ĐẠT' : 'KHÔNG ĐẠT',
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold, color: mau),
                  ),
                  const SizedBox(height: 4),
                  Text('${ketQua.diem}/${ketQua.tong} câu đúng',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('Thời gian làm bài: ${mmss(ketQua.giay)}'),
                  if (ketQua.saiDiemLiet)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Bạn đã làm sai câu điểm liệt nên không đạt.',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (ketQua.diem < ketQua.diemDat)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Cần tối thiểu ${ketQua.diemDat}/${ketQua.tong} câu đúng để đạt.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.replay),
                  label: const Text('Thi lại'),
                  // pushReplacement: thay màn hình kết quả bằng đề mới.
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        // Thi lại đúng hạng vừa thi, theo cấu trúc đang hiệu lực.
                        final h = ketQua.hang;
                        final ct = h.cauTruc();
                        return LamBaiScreen(
                          tieuDe: 'Thi thử hạng ${h.ma}',
                          cauHoi: taoDeThi(h, ct),
                          cheDo: CheDo.thiThu,
                          hang: h,
                          cauTruc: ct,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.home),
                  label: const Text('Trang chủ'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            sai.isEmpty ? 'Bạn làm đúng tất cả các câu!' : 'Các câu làm sai (${sai.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final j in sai) _CauSai(so: j + 1, cau: cauHoi[j], chon: chon[j]),
        ],
      ),
    );
  }
}

/// Thẻ xem lại một câu sai: bấm để mở rộng xem đáp án đúng và giải thích.
class _CauSai extends StatelessWidget {
  const _CauSai({required this.so, required this.cau, required this.chon});

  final int so;
  final CauHoi cau;
  final int? chon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text('Câu $so: ${cau.noiDung}',
            maxLines: 2, overflow: TextOverflow.ellipsis),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cau.bienBao != null)
            Center(child: BienBaoWidget(ma: cau.bienBao!, size: 90)),
          const SizedBox(height: 8),
          Text(
            chon == null ? 'Bạn chưa trả lời câu này.' : 'Bạn chọn: ${cau.dapAn[chon!]}',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 4),
          Text('Đáp án đúng: ${cau.dapAn[cau.dung]}',
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.w600)),
          if (cau.diemLiet)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('Đây là câu điểm liệt.',
                  style: TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 8),
          Text('Giải thích: ${cau.giaiThich}'),
        ],
      ),
    );
  }
}
