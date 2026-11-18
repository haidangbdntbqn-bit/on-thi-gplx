// ============================================================================
// FILE: lib/models/hang_bang.dart
// VAI TRÒ: Mô tả các HẠNG giấy phép lái xe mà ứng dụng hỗ trợ (A1, B, C1, C)
// và CẤU TRÚC đề thi lý thuyết của từng hạng.
//
// CĂN CỨ (tra ngày 17/11/2026):
//   - Loại xe, độ tuổi, thời hạn: Điều 57, 59 Luật Trật tự, an toàn giao thông
//     đường bộ 2024 (số 36/2024/QH15, hiệu lực 01/01/2025).
//   - Cấu trúc đề đang áp dụng (25/30/35/40 câu): Thông tư 12/2025/TT-BCA.
//   - Cấu trúc đề từ 01/3/2027 (40/50/60/70 câu): Thông tư 108/2026/TT-BCA
//     (hiệu lực 01/7/2026, phần tăng số câu áp dụng từ 01/3/2027).
// Ứng dụng tự chuyển sang cấu trúc mới khi đến ngày 01/3/2027.
// ============================================================================

import '../data/quy_dinh.dart';
import 'cau_hoi.dart';

/// Cấu trúc một đề thi lý thuyết.
class CauTruc {
  const CauTruc(this.soCau, this.phut, this.diemDat);

  /// Số câu của đề.
  final int soCau;

  /// Thời gian làm bài (phút).
  final int phut;

  /// Số câu đúng tối thiểu để đạt (và không được sai câu điểm liệt).
  final int diemDat;
}

enum HangBang {
  a1(
    'A1',
    'Mô tô',
    'Xe mô tô hai bánh có dung tích xi-lanh đến 125 cm³ hoặc công suất động cơ điện đến 11 kW.',
    18,
    'Không thời hạn',
    CauTruc(25, 19, 21),
    CauTruc(40, 27, 36),
  ),
  b(
    'B',
    'Ô tô con',
    'Ô tô chở người đến 8 chỗ (không kể chỗ của người lái xe); ô tô tải và ô tô chuyên dùng có khối lượng toàn bộ theo thiết kế đến 3.500 kg; các xe này kéo rơ moóc đến 750 kg.',
    18,
    '10 năm kể từ ngày cấp',
    CauTruc(30, 20, 27),
    CauTruc(50, 33, 45),
  ),
  c1(
    'C1',
    'Xe tải vừa',
    'Ô tô tải và ô tô chuyên dùng có khối lượng toàn bộ theo thiết kế trên 3.500 kg đến 7.500 kg; các xe này kéo rơ moóc đến 750 kg; các loại xe của hạng B.',
    18,
    '10 năm kể từ ngày cấp',
    CauTruc(35, 22, 32),
    CauTruc(60, 40, 54),
  ),
  c(
    'C',
    'Xe tải nặng',
    'Ô tô tải và ô tô chuyên dùng có khối lượng toàn bộ theo thiết kế trên 7.500 kg; các xe này kéo rơ moóc đến 750 kg; các loại xe của hạng B và C1.',
    21,
    '5 năm kể từ ngày cấp',
    CauTruc(40, 24, 36),
    CauTruc(70, 47, 63),
  );

  const HangBang(
    this.ma,
    this.tenNgan,
    this.loaiXe,
    this.tuoi,
    this.thoiHan,
    this.hienTai,
    this.tuNam2027,
  );

  /// Mã hạng: 'A1', 'B', 'C1', 'C'. Cũng dùng để lưu vào máy.
  final String ma;

  /// Tên gọi ngắn để hiện trên nút chọn.
  final String tenNgan;

  /// Loại xe được phép điều khiển.
  final String loaiXe;

  /// Tuổi tối thiểu.
  final int tuoi;

  /// Thời hạn của giấy phép lái xe.
  final String thoiHan;

  /// Cấu trúc đề đang áp dụng (trước 01/3/2027).
  final CauTruc hienTai;

  /// Cấu trúc đề áp dụng từ 01/3/2027.
  final CauTruc tuNam2027;

  /// Hạng ô tô (true) hay mô tô (false).
  bool get laOTo => this != HangBang.a1;

  /// Cấu trúc đề có hiệu lực tại thời điểm [luc] (mặc định: bây giờ).
  CauTruc cauTruc([DateTime? luc]) =>
      (luc ?? DateTime.now()).isBefore(ngayTangSoCau) ? hienTai : tuNam2027;

  /// Câu hỏi thuộc phạm vi [p] có dùng cho hạng này không.
  bool apDung(PhamVi p) {
    switch (p) {
      case PhamVi.chung:
        return true;
      case PhamVi.xeMay:
        return this == HangBang.a1;
      case PhamVi.oTo:
        return laOTo;
      case PhamVi.xeTai:
        return this == HangBang.c1 || this == HangBang.c;
    }
  }

  /// Tìm hạng theo mã đã lưu; mã lạ thì trả về A1.
  static HangBang tuMa(String? ma) {
    for (final h in HangBang.values) {
      if (h.ma == ma) return h;
    }
    return HangBang.a1;
  }
}
