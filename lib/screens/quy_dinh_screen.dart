// ============================================================================
// FILE: lib/screens/quy_dinh_screen.dart
// VAI TRÒ: Màn hình "Quy định" của một hạng bằng (mở từ Trang chủ).
//   - Thông tin hạng: loại xe được lái, tuổi tối thiểu, thời hạn bằng.
//   - Cấu trúc đề lý thuyết: đang áp dụng và từ 01/3/2027.
//   - Quy trình sát hạch hiện hành.
//   - Các quy định chung cần nhớ (cồn, điểm bằng lái, tốc độ...).
//   - Danh sách văn bản làm căn cứ.
// Toàn bộ nội dung lấy từ data/quy_dinh.dart và models/hang_bang.dart.
// ============================================================================

import 'package:flutter/material.dart';

import '../data/quy_dinh.dart';
import '../models/hang_bang.dart';

class QuyDinhScreen extends StatelessWidget {
  const QuyDinhScreen({super.key, required this.hang});

  final HangBang hang;

  @override
  Widget build(BuildContext context) {
    final quyTrinh = hang.laOTo ? quyTrinhOTo : quyTrinhMoTo;
    // Đang áp dụng cấu trúc nào tính đến hôm nay.
    final daSangCauTrucMoi = !DateTime.now().isBefore(ngayTangSoCau);

    return Scaffold(
      appBar: AppBar(title: Text('Quy định hạng ${hang.ma}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _The(
            tieuDe: 'Hạng ${hang.ma} (${hang.tenNgan})',
            children: [
              _Dong(nhan: 'Loại xe được lái', giaTri: hang.loaiXe),
              _Dong(nhan: 'Tuổi tối thiểu', giaTri: 'Đủ ${hang.tuoi} tuổi'),
              _Dong(nhan: 'Thời hạn giấy phép', giaTri: hang.thoiHan),
            ],
          ),
          _The(
            tieuDe: 'Cấu trúc đề thi lý thuyết',
            children: [
              _DongCauTruc(
                nhan: 'Trước 01/3/2027',
                ct: hang.hienTai,
                dangDung: !daSangCauTrucMoi,
              ),
              const SizedBox(height: 8),
              _DongCauTruc(
                nhan: 'Từ 01/3/2027',
                ct: hang.tuNam2027,
                dangDung: daSangCauTrucMoi,
              ),
              const SizedBox(height: 8),
              const Text(
                  'Ứng dụng tự dùng cấu trúc đang có hiệu lực theo ngày trên máy.'),
            ],
          ),
          _The(
            tieuDe: quyTrinh.tieuDe,
            children: [for (final y in quyTrinh.noiDung) _Y(y)],
          ),
          for (final m in quyDinhChung)
            _The(
              tieuDe: m.tieuDe,
              children: [for (final y in m.noiDung) _Y(y)],
            ),
          _The(
            tieuDe: 'Văn bản căn cứ',
            children: [
              for (final v in vanBanCanCu) _Y(v),
              const SizedBox(height: 8),
              Text(
                'Nội dung được tổng hợp ngày 17/11/2026 để phục vụ học tập. '
                'Quy định có thể thay đổi, hãy đối chiếu văn bản chính thức.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Một thẻ có tiêu đề và nội dung bên dưới.
class _The extends StatelessWidget {
  const _The({required this.tieuDe, required this.children});

  final String tieuDe;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tieuDe, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Một dòng "nhãn: giá trị".
class _Dong extends StatelessWidget {
  const _Dong({required this.nhan, required this.giaTri});

  final String nhan;
  final String giaTri;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nhan, style: Theme.of(context).textTheme.labelMedium),
          Text(giaTri),
        ],
      ),
    );
  }
}

/// Một dòng mô tả cấu trúc đề; [dangDung] = true thì tô nổi bật.
class _DongCauTruc extends StatelessWidget {
  const _DongCauTruc(
      {required this.nhan, required this.ct, required this.dangDung});

  final String nhan;
  final CauTruc ct;
  final bool dangDung;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dangDung ? cs.primaryContainer : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dangDung ? '$nhan (đang áp dụng)' : nhan,
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text('${ct.soCau} câu  ·  ${ct.phut} phút  ·  đạt từ ${ct.diemDat}/${ct.soCau} câu'),
        ],
      ),
    );
  }
}

/// Một ý gạch đầu dòng.
class _Y extends StatelessWidget {
  const _Y(this.noiDung);

  final String noiDung;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(child: Text(noiDung)),
        ],
      ),
    );
  }
}
