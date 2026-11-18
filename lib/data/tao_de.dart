// ============================================================================
// FILE: lib/data/tao_de.dart
// VAI TRÒ: Các hàm lọc và tạo danh sách câu hỏi cho từng HẠNG và từng chế độ.
// Mỗi hạng chỉ dùng các câu có phạm vi phù hợp (xem HangBang.apDung).
// ============================================================================

import 'dart:math';

import '../models/cau_hoi.dart';
import '../models/hang_bang.dart';
import 'ngan_hang.dart';

/// Tất cả câu hỏi dùng cho hạng [h], theo thứ tự trong ngân hàng.
List<CauHoi> cauCuaHang(HangBang h) =>
    nganHang.where((c) => h.apDung(c.phamVi)).toList();

/// Tạo một đề thi thử cho hạng [h] theo cấu trúc [ct]: đủ số câu, trong đó
/// có ĐÚNG 1 câu điểm liệt (giống đề thi thật), thứ tự được xáo trộn.
/// Nếu ngân hàng không đủ câu thì lấy hết số câu đang có.
List<CauHoi> taoDeThi(HangBang h, CauTruc ct, {Random? rd}) {
  final r = rd ?? Random();
  final tatCa = cauCuaHang(h);
  final liet = tatCa.where((c) => c.diemLiet).toList()..shuffle(r);
  final thuong = tatCa.where((c) => !c.diemLiet).toList()..shuffle(r);
  final de = <CauHoi>[
    if (liet.isNotEmpty) liet.first,
    ...thuong.take(ct.soCau - (liet.isNotEmpty ? 1 : 0)),
  ]..shuffle(r);
  return de;
}

/// Lấy [n] câu ngẫu nhiên của hạng [h].
List<CauHoi> cauNgauNhien(HangBang h, int n) {
  final ds = cauCuaHang(h)..shuffle(Random());
  return ds.take(n).toList();
}

/// Các câu của hạng [h] thuộc chương [c].
List<CauHoi> cauTheoChuong(HangBang h, Chuong c) =>
    cauCuaHang(h).where((x) => x.chuong == c).toList();

/// Các câu của hạng [h] đang ở trạng thái "làm sai" (theo mã trong [saiIds]).
List<CauHoi> cauSai(HangBang h, Set<int> saiIds) =>
    cauCuaHang(h).where((x) => saiIds.contains(x.id)).toList();
