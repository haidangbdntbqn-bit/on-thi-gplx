// ============================================================================
// FILE: lib/utils/dinh_dang.dart
// VAI TRÒ: Các hàm định dạng chữ dùng chung (thời gian, ngày giờ).
// ============================================================================

/// Đổi số giây thành 'mm:ss'. Ví dụ 125 -> '02:05'. Số âm coi như 0.
String mmss(int giay) {
  final g = giay < 0 ? 0 : giay;
  final p = (g ~/ 60).toString().padLeft(2, '0');
  final s = (g % 60).toString().padLeft(2, '0');
  return '$p:$s';
}

/// Đổi DateTime thành 'dd/MM/yyyy HH:mm'.
String ngayGio(DateTime d) {
  String hai(int n) => n.toString().padLeft(2, '0');
  return '${hai(d.day)}/${hai(d.month)}/${d.year} ${hai(d.hour)}:${hai(d.minute)}';
}
