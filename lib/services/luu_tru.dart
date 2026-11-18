// ============================================================================
// FILE: lib/services/luu_tru.dart
// VAI TRÒ: Lưu tiến độ học vào bộ nhớ máy (không mất khi tắt app) bằng
// thư viện shared_preferences.
//
// Lưu 4 thứ:
//   - hang     : hạng bằng đang chọn học (A1, B, C1, C)
//   - cau_dung : các câu hiện đang ở trạng thái "làm đúng"
//   - cau_sai  : các câu hiện đang ở trạng thái "làm sai" (để ôn lại)
//   - lich_su  : kết quả các lần thi thử (tối đa 30 lần gần nhất)
// Một câu chỉ nằm ở MỘT trong hai tập đúng/sai (lần làm gần nhất quyết định).
//
// Kế thừa ChangeNotifier: khi dữ liệu đổi gọi notifyListeners(), màn hình nào
// đang "lắng nghe" (ListenableBuilder) sẽ tự vẽ lại -> số liệu luôn mới.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hang_bang.dart';
import '../models/ket_qua_thi.dart';

class LuuTru extends ChangeNotifier {
  LuuTru._();

  /// Chỉ có MỘT đối tượng LuuTru dùng chung toàn app (singleton).
  static final LuuTru instance = LuuTru._();

  SharedPreferences? _p;
  HangBang _hang = HangBang.a1;
  final Set<int> _dung = {};
  final Set<int> _sai = {};
  final List<KetQuaThi> _lichSu = [];

  /// Hạng bằng đang chọn học.
  HangBang get hang => _hang;

  /// Đổi hạng đang học (lưu lại để lần sau mở app vẫn nhớ).
  void chonHang(HangBang h) {
    if (h == _hang) return;
    _hang = h;
    _p?.setString('hang', h.ma);
    notifyListeners();
  }

  /// Các câu đã làm đúng.
  Set<int> get dung => _dung;

  /// Các câu đã làm sai (cần ôn lại).
  Set<int> get sai => _sai;

  /// Lịch sử thi thử, lần mới nhất ở đầu.
  List<KetQuaThi> get lichSu => _lichSu;

  /// Đọc dữ liệu đã lưu. Gọi MỘT lần trong main() trước khi chạy app.
  Future<void> khoiTao() async {
    final p = await SharedPreferences.getInstance();
    _p = p;
    _hang = HangBang.tuMa(p.getString('hang'));
    _dung
      ..clear()
      ..addAll((p.getStringList('cau_dung') ?? []).map(int.parse));
    _sai
      ..clear()
      ..addAll((p.getStringList('cau_sai') ?? []).map(int.parse));
    _lichSu.clear();
    for (final s in p.getStringList('lich_su') ?? <String>[]) {
      try {
        _lichSu.add(KetQuaThi.fromJson(s));
      } catch (_) {
        // Bỏ qua dòng hỏng thay vì làm app lỗi.
      }
    }
  }

  /// Ghi nhận kết quả một câu: [dungKhong] true = đúng, false = sai.
  void ghiNhan(int id, bool dungKhong) => ghiNhanNhieu({id: dungKhong});

  /// Ghi nhận nhiều câu một lúc (chỉ lưu và báo cập nhật 1 lần cho nhanh).
  void ghiNhanNhieu(Map<int, bool> kq) {
    kq.forEach((id, d) {
      if (d) {
        _dung.add(id);
        _sai.remove(id);
      } else {
        _sai.add(id);
        _dung.remove(id);
      }
    });
    _luu();
    notifyListeners();
  }

  /// Thêm một lần thi thử vào lịch sử (giữ tối đa 30 lần gần nhất).
  void themLichSu(KetQuaThi k) {
    _lichSu.insert(0, k);
    if (_lichSu.length > 30) _lichSu.removeRange(30, _lichSu.length);
    _luu();
    notifyListeners();
  }

  /// Xoá toàn bộ tiến độ.
  void xoaTatCa() {
    _dung.clear();
    _sai.clear();
    _lichSu.clear();
    _luu();
    notifyListeners();
  }

  /// Ghi tất cả xuống bộ nhớ máy.
  void _luu() {
    final p = _p;
    if (p == null) return;
    p.setStringList('cau_dung', _dung.map((e) => e.toString()).toList());
    p.setStringList('cau_sai', _sai.map((e) => e.toString()).toList());
    p.setStringList('lich_su', _lichSu.map((e) => e.toJson()).toList());
  }
}
