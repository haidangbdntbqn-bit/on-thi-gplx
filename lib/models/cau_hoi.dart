// ============================================================================
// FILE: lib/models/cau_hoi.dart
// VAI TRÒ: Kiểu dữ liệu của một câu hỏi trắc nghiệm, các chương ôn tập và
// phạm vi áp dụng của câu hỏi (câu nào dành cho hạng bằng nào).
// File này không có giao diện, chỉ mô tả dữ liệu.
// ============================================================================

/// Các chương ôn tập (dùng enum để không gõ sai tên chương).
enum Chuong {
  quyTac('Quy tắc giao thông'),
  tocDo('Tốc độ và khoảng cách'),
  vanHoa('Văn hoá và đạo đức người lái xe'),
  kyThuat('Kỹ thuật lái xe và cấu tạo xe'),
  bienBao('Biển báo và vạch kẻ đường'),
  vanTai('Nghiệp vụ vận tải');

  const Chuong(this.ten);

  /// Tên hiển thị trên màn hình.
  final String ten;
}

/// Câu hỏi áp dụng cho nhóm người học nào.
///   chung : mọi hạng (A1, B, C1, C)
///   xeMay : chỉ hạng A1 (mô tô)
///   oTo   : các hạng ô tô (B, C1, C)
///   xeTai : chỉ hạng xe tải (C1, C)
enum PhamVi { chung, xeMay, oTo, xeTai }

/// Một câu hỏi trắc nghiệm, chỉ có MỘT đáp án đúng.
class CauHoi {
  const CauHoi({
    required this.id,
    required this.chuong,
    required this.noiDung,
    required this.dapAn,
    required this.dung,
    required this.giaiThich,
    this.diemLiet = false,
    this.bienBao,
    this.phamVi = PhamVi.chung,
  });

  /// Mã số câu hỏi, duy nhất. Dùng để lưu "câu đã đúng / câu sai" vào máy.
  final int id;

  /// Câu hỏi thuộc chương nào.
  final Chuong chuong;

  /// Nội dung câu hỏi.
  final String noiDung;

  /// Danh sách đáp án (2 đến 4 đáp án).
  final List<String> dapAn;

  /// Vị trí (bắt đầu từ 0) của đáp án đúng trong [dapAn].
  final int dung;

  /// Giải thích vì sao đáp án đó đúng (hiện sau khi trả lời).
  final String giaiThich;

  /// Câu "điểm liệt": trả lời sai là trượt bài thi dù đủ điểm.
  final bool diemLiet;

  /// Mã biển báo cần hiện kèm câu hỏi (vd 'P.102'), null nếu không có hình.
  final String? bienBao;

  /// Câu này dành cho hạng nào (xem [PhamVi]).
  final PhamVi phamVi;
}

/// Kiểu của hàm tạo câu hỏi rút gọn dùng trong các file ngân hàng câu hỏi.
/// Nhờ dùng chung một hàm (một bộ đếm) nên mã số câu không bao giờ trùng.
typedef TaoCau = CauHoi Function(
  Chuong c,
  String hoi,
  List<String> da,
  int dung,
  String gt, {
  bool liet,
  String? bb,
  PhamVi pv,
});
