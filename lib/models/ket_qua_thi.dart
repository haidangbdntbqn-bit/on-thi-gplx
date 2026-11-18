// ============================================================================
// FILE: lib/models/ket_qua_thi.dart
// VAI TRÒ: Kết quả của MỘT lần thi thử, lưu vào lịch sử trong máy.
// Có toJson/fromJson để chuyển qua lại với chuỗi JSON (shared_preferences
// chỉ lưu được chuỗi, số, danh sách chuỗi).
// Lưu kèm hạng bằng và điểm đạt tại thời điểm thi, để lịch sử cũ vẫn đúng
// dù sau này quy định đổi số câu.
// ============================================================================

import 'dart:convert';

import 'hang_bang.dart';

class KetQuaThi {
  const KetQuaThi({
    required this.ngay,
    required this.hang,
    required this.diem,
    required this.tong,
    required this.diemDat,
    required this.saiDiemLiet,
    required this.giay,
  });

  /// Thời điểm nộp bài.
  final DateTime ngay;

  /// Thi hạng nào.
  final HangBang hang;

  /// Số câu trả lời đúng.
  final int diem;

  /// Tổng số câu của đề.
  final int tong;

  /// Số câu đúng tối thiểu để đạt của đề này.
  final int diemDat;

  /// Có làm sai câu điểm liệt hay không.
  final bool saiDiemLiet;

  /// Số giây đã làm bài.
  final int giay;

  /// ĐẠT khi đủ điểm tối thiểu VÀ không sai câu điểm liệt.
  bool get dat => diem >= diemDat && !saiDiemLiet;

  /// Đổi thành chuỗi JSON để lưu.
  String toJson() => jsonEncode({
        'ngay': ngay.toIso8601String(),
        'hang': hang.ma,
        'diem': diem,
        'tong': tong,
        'dat': diemDat,
        'liet': saiDiemLiet,
        'giay': giay,
      });

  /// Đọc lại từ chuỗi JSON đã lưu. Bản ghi cũ (trước khi có nhiều hạng)
  /// không có 'hang' và 'dat' nên mặc định là A1, đạt từ 21 câu.
  factory KetQuaThi.fromJson(String s) {
    final m = jsonDecode(s) as Map<String, dynamic>;
    return KetQuaThi(
      ngay: DateTime.parse(m['ngay'] as String),
      hang: HangBang.tuMa(m['hang'] as String?),
      diem: m['diem'] as int,
      tong: m['tong'] as int,
      diemDat: (m['dat'] as int?) ?? 21,
      saiDiemLiet: m['liet'] as bool,
      giay: m['giay'] as int,
    );
  }
}
