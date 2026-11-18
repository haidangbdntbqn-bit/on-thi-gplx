// ============================================================================
// FILE: lib/data/quy_dinh.dart
// VAI TRÒ: Các mốc thời gian và nội dung quy định dùng chung (hiện ở màn hình
// "Quy định"). Số câu / thời gian / điểm đạt của từng hạng nằm trong
// models/hang_bang.dart. Khi quy định thay đổi chỉ cần sửa 2 file này.
// Nội dung tra ngày 17/11/2026, người dùng nên đối chiếu văn bản gốc.
// ============================================================================

/// Từ ngày này đề thi lý thuyết tăng số câu (Thông tư 108/2026/TT-BCA).
final ngayTangSoCau = DateTime(2027, 3, 1);

/// Một mục quy định: tiêu đề + các ý.
class MucQuyDinh {
  const MucQuyDinh(this.tieuDe, this.noiDung);
  final String tieuDe;
  final List<String> noiDung;
}

/// Quy trình sát hạch hiện hành (Thông tư 108/2026/TT-BCA, từ 01/7/2026).
const quyTrinhMoTo = MucQuyDinh('Quy trình sát hạch hạng A1', [
  'Thi theo thứ tự bắt buộc: lý thuyết rồi mới đến thực hành trong hình.',
  'Phải đạt phần trước mới được thi phần sau.',
  'Đề lý thuyết có 1 câu điểm liệt: trả lời sai là không đạt.',
  'Từ 01/01/2028 bổ sung bài thực hành thứ hai với 11 tình huống giả định.',
]);

const quyTrinhOTo = MucQuyDinh('Quy trình sát hạch ô tô (B, C1, C)', [
  'Thi theo thứ tự bắt buộc: lý thuyết, thực hành trong hình (sa hình), thực hành trên đường.',
  'Phải đạt phần trước mới được thi phần sau.',
  'Từ 01/7/2026 đã bỏ phần thi mô phỏng tình huống giao thông trên máy tính.',
  'Đề lý thuyết có 1 câu điểm liệt: trả lời sai là không đạt.',
  'Từ 01/3/2027 bài thi trên đường dài tối thiểu 5 km, gồm 12 bài sát hạch.',
]);

/// Các quy định chung người lái xe cần nhớ.
const quyDinhChung = <MucQuyDinh>[
  MucQuyDinh('Nồng độ cồn và ma tuý', [
    'Cấm điều khiển phương tiện khi trong máu hoặc hơi thở có nồng độ cồn.',
    'Cấm điều khiển phương tiện khi trong cơ thể có chất ma tuý.',
  ]),
  MucQuyDinh('Điểm của giấy phép lái xe', [
    'Mỗi giấy phép lái xe có 12 điểm, bị trừ khi vi phạm.',
    'Sau 12 tháng kể từ lần bị trừ gần nhất mà không bị trừ tiếp thì được phục hồi đủ 12 điểm.',
    'Bị trừ hết điểm thì không được lái xe theo giấy phép đó; sau ít nhất 6 tháng được dự kiểm tra kiến thức pháp luật để phục hồi điểm.',
  ]),
  MucQuyDinh('Tốc độ tối đa trong khu vực đông dân cư', [
    'Đường đôi, đường một chiều từ 2 làn xe cơ giới trở lên: 60 km/h.',
    'Đường hai chiều, đường một chiều có 1 làn xe cơ giới: 50 km/h.',
    'Xe gắn máy: tối đa 40 km/h.',
  ]),
  MucQuyDinh('Tốc độ tối đa ngoài khu vực đông dân cư (đường đôi / đường hai chiều)', [
    'Ô tô chở người đến 28 chỗ (trừ xe buýt), ô tô tải đến 3,5 tấn: 90 / 80 km/h.',
    'Ô tô chở người trên 28 chỗ (trừ xe buýt), ô tô tải trên 3,5 tấn (trừ xi téc): 80 / 70 km/h.',
    'Xe buýt, ô tô đầu kéo kéo sơ mi rơ moóc, xe mô tô, ô tô chuyên dùng: 70 / 60 km/h.',
    'Ô tô kéo rơ moóc, kéo xe khác, xe trộn bê tông, ô tô xi téc: 60 / 50 km/h.',
    'Đường cao tốc: tối đa 120 km/h, tối thiểu 60 km/h.',
  ]),
  MucQuyDinh('Khoảng cách an toàn tối thiểu (mặt đường khô ráo)', [
    'Tốc độ 60 km/h: 35 m.',
    'Trên 60 đến 80 km/h: 55 m.',
    'Trên 80 đến 100 km/h: 70 m.',
    'Trên 100 đến 120 km/h: 100 m.',
    'Trời mưa, sương mù, đường trơn: phải giữ khoảng cách lớn hơn.',
  ]),
  MucQuyDinh('Trẻ em trên xe ô tô (từ 01/7/2026)', [
    'Trẻ dưới 10 tuổi và cao dưới 1,35 m không được ngồi cùng hàng ghế với người lái xe, trừ xe chỉ có một hàng ghế.',
    'Người lái xe phải sử dụng hoặc hướng dẫn sử dụng thiết bị an toàn phù hợp cho trẻ.',
  ]),
  MucQuyDinh('Thời gian lái xe (từ 01/7/2026)', [
    'Người lái xe ô tô không lái xe liên tục quá 4 giờ, trừ trường hợp bất khả kháng hoặc trở ngại khách quan.',
    'Thời gian làm việc trong ngày, trong tuần theo Bộ luật Lao động (đã bỏ giới hạn riêng 10 giờ/ngày và 48 giờ/tuần).',
  ]),
];

/// Văn bản làm căn cứ.
const vanBanCanCu = <String>[
  'Luật Trật tự, an toàn giao thông đường bộ 2024 (số 36/2024/QH15), hiệu lực 01/01/2025.',
  'Luật số 118/2025/QH15 sửa đổi, bổ sung 10 luật về an ninh, trật tự, hiệu lực 01/7/2026.',
  'Thông tư 38/2024/TT-BGTVT về tốc độ và khoảng cách an toàn, hiệu lực 01/01/2025.',
  'Thông tư 12/2025/TT-BCA về sát hạch, cấp giấy phép lái xe (cấu trúc đề đang áp dụng).',
  'Thông tư 108/2026/TT-BCA thay thế Thông tư 12/2025/TT-BCA, hiệu lực 01/7/2026.',
];
