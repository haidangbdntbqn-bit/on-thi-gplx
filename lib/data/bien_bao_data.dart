// ============================================================================
// FILE: lib/data/bien_bao_data.dart
// VAI TRÒ: Danh sách biển báo dùng cho màn hình "Biển báo" và để hiện hình
// trong câu hỏi. Hình biển được VẼ BẰNG CODE (widgets/bien_bao_widget.dart)
// nên không cần tải ảnh, chạy được cả khi không có mạng.
// Mã biển (ma) theo QCVN 41:2019/BGTVT, vd 'P.102'.
// ============================================================================

enum NhomBienBao {
  cam('Biển cấm'),
  nguyHiem('Biển nguy hiểm'),
  hieuLenh('Biển hiệu lệnh'),
  chiDan('Biển chỉ dẫn');

  const NhomBienBao(this.ten);
  final String ten;
}

class BienBao {
  const BienBao(this.ma, this.ten, this.nhom, this.yNghia);

  /// Mã biển, vd 'P.102'. Cũng là khoá để vẽ hình.
  final String ma;

  /// Tên biển.
  final String ten;

  /// Thuộc nhóm nào.
  final NhomBienBao nhom;

  /// Giải thích ý nghĩa và cách xử lý.
  final String yNghia;
}

const danhSachBienBao = <BienBao>[
  // ---- Biển cấm: hình tròn, viền đỏ ----
  BienBao('P.102', 'Cấm đi ngược chiều', NhomBienBao.cam,
      'Cấm tất cả các loại xe đi vào theo chiều đặt biển, trừ xe ưu tiên theo quy định.'),
  BienBao('P.124', 'Dừng lại', NhomBienBao.cam,
      'Xe phải dừng trước vạch dừng, quan sát an toàn rồi mới được đi tiếp.'),
  BienBao('P.123a', 'Cấm rẽ trái', NhomBienBao.cam,
      'Cấm các loại xe rẽ trái ở nơi đặt biển.'),
  BienBao('P.123b', 'Cấm rẽ phải', NhomBienBao.cam,
      'Cấm các loại xe rẽ phải ở nơi đặt biển.'),
  BienBao('P.127', 'Tốc độ tối đa cho phép', NhomBienBao.cam,
      'Cấm xe chạy quá tốc độ ghi trên biển (đơn vị km/h).'),
  BienBao('P.104', 'Cấm xe mô tô', NhomBienBao.cam,
      'Cấm xe mô tô đi vào đoạn đường đặt biển.'),
  BienBao('P.131a', 'Cấm đỗ xe', NhomBienBao.cam,
      'Cấm đỗ xe ở đoạn đường đặt biển (vẫn được dừng xe tạm thời).'),
  BienBao('P.130', 'Cấm dừng xe và đỗ xe', NhomBienBao.cam,
      'Cấm cả dừng xe và đỗ xe ở đoạn đường đặt biển.'),
  BienBao('P.103a', 'Cấm xe ô tô', NhomBienBao.cam,
      'Cấm các loại xe cơ giới kể cả mô tô ba bánh, trừ mô tô hai bánh, xe gắn máy và xe ưu tiên.'),
  BienBao('P.106a', 'Cấm xe ô tô tải', NhomBienBao.cam,
      'Cấm các loại xe ô tô tải đi vào, trừ xe ưu tiên theo quy định.'),
  BienBao('P.125', 'Cấm vượt', NhomBienBao.cam,
      'Cấm các loại xe cơ giới vượt nhau; vẫn được vượt xe máy hai bánh, xe gắn máy.'),
  BienBao('P.115', 'Hạn chế tải trọng toàn bộ xe', NhomBienBao.cam,
      'Cấm xe có khối lượng toàn bộ (cả xe và hàng) vượt quá trị số ghi trên biển (tấn).'),
  BienBao('P.117', 'Hạn chế chiều cao', NhomBienBao.cam,
      'Cấm xe có chiều cao (tính cả hàng hoá) vượt quá trị số ghi trên biển.'),
  BienBao('P.128', 'Cấm sử dụng còi', NhomBienBao.cam,
      'Cấm các loại xe sử dụng còi trong đoạn đường đặt biển.'),

  // ---- Biển nguy hiểm: tam giác, viền đỏ, nền vàng ----
  BienBao('W.224', 'Người đi bộ cắt ngang', NhomBienBao.nguyHiem,
      'Báo trước nơi có người đi bộ cắt ngang; giảm tốc độ, sẵn sàng nhường đường.'),
  BienBao('W.225', 'Trẻ em', NhomBienBao.nguyHiem,
      'Báo trước gần nơi thường có trẻ em qua đường (trường học, khu vui chơi).'),
  BienBao('W.208', 'Giao nhau với đường ưu tiên', NhomBienBao.nguyHiem,
      'Báo trước sắp đến nơi giao nhau với đường ưu tiên; phải nhường đường cho xe trên đường ưu tiên.'),

  // ---- Biển hiệu lệnh: hình tròn nền xanh ----
  BienBao('R.301', 'Hướng đi phải theo (đi thẳng)', NhomBienBao.hieuLenh,
      'Các xe chỉ được đi thẳng theo hướng mũi tên.'),
  BienBao('R.303', 'Nơi giao nhau chạy theo vòng xuyến', NhomBienBao.hieuLenh,
      'Các xe phải đi vòng theo chiều mũi tên quanh đảo an toàn; nhường xe đến từ bên trái.'),

  // ---- Biển chỉ dẫn: hình chữ nhật hoặc vuông nền xanh ----
  BienBao('I.407a', 'Đường một chiều', NhomBienBao.chiDan,
      'Xe chỉ được đi theo một chiều theo mũi tên.'),
  BienBao('I.408', 'Nơi đỗ xe', NhomBienBao.chiDan,
      'Chỉ dẫn nơi được phép đỗ xe.'),
  BienBao('I.401', 'Bắt đầu đường ưu tiên', NhomBienBao.chiDan,
      'Xe đi trên đường này được ưu tiên qua nơi giao nhau.'),
];

/// Tìm biển theo mã, trả null nếu không có.
BienBao? timBienBao(String ma) {
  for (final b in danhSachBienBao) {
    if (b.ma == ma) return b;
  }
  return null;
}
