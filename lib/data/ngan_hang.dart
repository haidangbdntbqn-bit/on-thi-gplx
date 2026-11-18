// ============================================================================
// FILE: lib/data/ngan_hang.dart
// VAI TRÒ: Ngân hàng câu hỏi (dữ liệu) của ứng dụng.
//
// LƯU Ý QUAN TRỌNG:
//   - Đây là bộ câu hỏi MẪU do nhóm tự soạn để luyện tập, KHÔNG phải ngân hàng
//     đề chính thức của Bộ GTVT. Khi dùng để thi thật, hãy đối chiếu bộ đề
//     chính thức và các văn bản luật hiện hành.
//   - Số liệu tốc độ theo Thông tư 38/2024/TT-BGTVT (hiệu lực từ 01/01/2025).
//   - Mỗi câu có "phạm vi" (pv): chung = mọi hạng, xeMay = chỉ hạng A1.
//     Câu dành cho ô tô (B, C1, C) nằm ở file ngan_hang_o_to.dart.
//   - Cờ "điểm liệt" ở đây là cách mô phỏng cấu trúc đề thi (mỗi đề có 1 câu
//     điểm liệt), chọn các câu về hành vi nghiêm cấm / biển báo quan trọng.
//
// CÁCH THÊM CÂU HỎI: thêm một dòng q(...) vào danh sách bên dưới. Mã số (id)
// tự tăng theo thứ tự; nên thêm vào CUỐI danh sách để không làm lệch tiến độ
// đã lưu của người dùng.
// ============================================================================

import '../models/cau_hoi.dart';
import 'ngan_hang_o_to.dart';

/// Toàn bộ câu hỏi, tạo một lần khi mở app.
final List<CauHoi> nganHang = _taoNganHang();

List<CauHoi> _taoNganHang() {
  var n = 0; // bộ đếm để tự đánh số id: 1, 2, 3...

  // Hàm rút gọn để mỗi câu hỏi chỉ tốn vài dòng.
  //   c   : chương
  //   hoi : nội dung câu hỏi
  //   da  : danh sách đáp án
  //   dung: vị trí đáp án đúng (từ 0)
  //   gt  : giải thích
  //   liet: có phải câu điểm liệt không
  //   bb  : mã biển báo kèm theo (nếu có)
  CauHoi q(Chuong c, String hoi, List<String> da, int dung, String gt,
          {bool liet = false, String? bb, PhamVi pv = PhamVi.chung}) =>
      CauHoi(
        id: ++n,
        chuong: c,
        noiDung: hoi,
        dapAn: da,
        dung: dung,
        giaiThich: gt,
        diemLiet: liet,
        bienBao: bb,
        phamVi: pv,
      );

  return [
    // ======================= CHƯƠNG 1: QUY TẮC GIAO THÔNG =======================
    q(
      Chuong.quyTac,
      'Người đăng ký thi bằng lái xe mô tô hạng A1 phải đủ bao nhiêu tuổi?',
      ['Đủ 16 tuổi trở lên', 'Đủ 18 tuổi trở lên', 'Đủ 20 tuổi trở lên'],
      1,
      'Hạng A1 cấp cho người đủ 18 tuổi trở lên (tính đến ngày dự sát hạch).',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.quyTac,
      'Bằng lái xe hạng A1 cho phép điều khiển loại xe nào?',
      [
        'Xe mô tô hai bánh có dung tích xi-lanh đến 125 cm³ hoặc công suất động cơ điện đến 11 kW',
        'Mọi loại xe mô tô hai bánh, không giới hạn dung tích',
        'Xe ô tô chở người đến 9 chỗ ngồi',
      ],
      0,
      'Hạng A1: mô tô hai bánh dung tích xi-lanh đến 125 cm³ hoặc công suất động cơ điện không quá 11 kW.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.quyTac,
      'Người điều khiển xe mô tô có được uống rượu, bia rồi lái xe không?',
      [
        'Được, nếu chỉ uống một ít',
        'Không được, cấm điều khiển xe khi trong máu hoặc hơi thở có nồng độ cồn',
        'Được, nếu đi với tốc độ chậm',
      ],
      1,
      'Luật Trật tự, an toàn giao thông đường bộ 2024 nghiêm cấm điều khiển phương tiện khi trong máu hoặc hơi thở có nồng độ cồn.',
      liet: true,
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.quyTac,
      'Khi gặp tín hiệu đèn đỏ, người điều khiển xe phải làm gì?',
      [
        'Dừng lại trước vạch dừng',
        'Tăng tốc đi qua nhanh nếu không có xe khác',
        'Giảm tốc độ và đi qua từ từ',
      ],
      0,
      'Tín hiệu đèn đỏ là lệnh dừng. Vượt đèn đỏ là hành vi vi phạm nghiêm trọng, dễ gây tai nạn.',
      liet: true,
    ),
    q(
      Chuong.quyTac,
      'Xe được rẽ phải khi đèn tín hiệu đỏ trong trường hợp nào?',
      [
        'Luôn được rẽ phải nếu không có xe khác',
        'Chỉ khi có biển báo hoặc biển phụ cho phép rẽ phải khi đèn đỏ',
        'Chỉ được rẽ phải vào ban đêm',
      ],
      1,
      'Chỉ được rẽ phải khi đèn đỏ ở nơi có biển báo cho phép, đồng thời vẫn phải nhường đường cho người đi bộ và xe khác.',
    ),
    q(
      Chuong.quyTac,
      'Tín hiệu đèn vàng nhấp nháy có ý nghĩa gì?',
      [
        'Cảnh báo nguy hiểm: được đi nhưng phải giảm tốc độ, quan sát và nhường đường theo quy định',
        'Phải dừng lại ngay',
        'Được phép đi nhanh để qua giao lộ',
      ],
      0,
      'Đèn vàng nhấp nháy là tín hiệu cảnh báo, người lái xe được đi nhưng phải chú ý quan sát và nhường đường.',
    ),
    q(
      Chuong.quyTac,
      'Xe mô tô được chở tối đa mấy người (không tính các trường hợp ngoại lệ)?',
      ['01 người', '02 người', '03 người'],
      1,
      'Xe mô tô chỉ được chở tối đa 02 người, trừ chở người bệnh đi cấp cứu, áp giải người phạm tội hoặc trẻ em dưới 14 tuổi.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.quyTac,
      'Người ngồi trên xe mô tô khi tham gia giao thông phải làm gì?',
      [
        'Đội mũ bảo hiểm đạt chuẩn và cài quai đúng quy cách',
        'Chỉ người lái xe cần đội mũ bảo hiểm',
        'Chỉ đội mũ bảo hiểm khi đi đường dài',
      ],
      0,
      'Cả người lái và người ngồi sau đều phải đội mũ bảo hiểm đạt chuẩn và cài quai đúng quy cách.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.quyTac,
      'Tại nơi giao nhau không có đèn tín hiệu và không có biển báo, xe nào phải nhường đường?',
      [
        'Nhường cho xe đi từ bên phải đến',
        'Nhường cho xe đi từ bên trái đến',
        'Xe nào đến trước đi trước, không cần nhường ai',
      ],
      0,
      'Khi đi vào giao lộ không có tín hiệu, biển báo, phải nhường đường cho xe đi từ bên phải đến.',
    ),
    q(
      Chuong.quyTac,
      'Khi có xe ưu tiên (cứu thương, cứu hoả, công an) phát tín hiệu ưu tiên, người lái xe phải làm gì?',
      [
        'Tiếp tục đi bình thường',
        'Nhanh chóng giảm tốc độ, nhường đường và không được cản trở',
        'Tăng tốc chạy trước xe ưu tiên',
      ],
      1,
      'Xe ưu tiên đang làm nhiệm vụ có tín hiệu thì các xe khác phải nhường đường.',
    ),
    q(
      Chuong.quyTac,
      'Vạch kẻ đường màu vàng liền (đơn hoặc đôi) ở giữa đường có ý nghĩa gì?',
      [
        'Phân chia hai chiều xe chạy, xe không được đè hoặc lấn qua vạch',
        'Cho phép vượt xe bất cứ lúc nào',
        'Chỉ là vạch trang trí',
      ],
      0,
      'Vạch vàng liền phân chia hai chiều xe chạy ngược nhau, cấm đè vạch và lấn sang làn đối diện.',
    ),
    q(
      Chuong.quyTac,
      'Vạch kẻ đường nét đứt (vạch phân làn) cho phép điều gì?',
      [
        'Cấm mọi trường hợp lấn làn',
        'Được phép chuyển làn hoặc vượt khi cần thiết nếu bảo đảm an toàn',
        'Chỉ dành cho xe ưu tiên',
      ],
      1,
      'Vạch nét đứt cho phép xe chuyển làn, vượt khi quan sát an toàn và có tín hiệu báo trước.',
    ),
    q(
      Chuong.quyTac,
      'Trường hợp nào sau đây CẤM vượt xe?',
      [
        'Tại nơi giao nhau, cầu hẹp, đường cong có tầm nhìn hạn chế',
        'Khi xe phía trước đi chậm và đường thông thoáng',
        'Khi trời nắng, đường khô',
      ],
      0,
      'Cấm vượt tại nơi đường giao nhau, cầu hẹp, đường cong tầm nhìn bị hạn chế và nơi có biển cấm vượt.',
    ),
    q(
      Chuong.quyTac,
      'Hành vi nào sau đây bị cấm khi đang điều khiển xe mô tô?',
      [
        'Bật đèn xin đường khi chuyển hướng',
        'Dùng tay cầm và sử dụng điện thoại di động',
        'Đội mũ bảo hiểm',
      ],
      1,
      'Cấm dùng điện thoại di động cầm tay khi lái xe vì làm mất tập trung, dễ gây tai nạn.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.quyTac,
      'Khi xảy ra tai nạn giao thông, người điều khiển phương tiện có liên quan phải làm gì?',
      [
        'Bỏ đi nhanh để tránh rắc rối',
        'Dừng xe, giữ nguyên hiện trường, cấp cứu người bị nạn và báo cơ quan chức năng',
        'Chỉ cần gọi người thân đến giải quyết',
      ],
      1,
      'Phải dừng ngay, bảo vệ hiện trường, giúp đỡ người bị nạn và báo công an hoặc cứu thương.',
    ),
    q(
      Chuong.quyTac,
      'Nơi nào sau đây CẤM dừng xe, đỗ xe?',
      [
        'Tại nơi đường bộ giao nhau cùng mức với đường sắt',
        'Bên phải đường, sát lề, nơi không có biển cấm',
        'Trong bãi đỗ xe được phép',
      ],
      0,
      'Cấm dừng, đỗ xe tại nơi đường bộ giao nhau cùng mức với đường sắt và trong phạm vi an toàn của đường sắt.',
    ),
    q(
      Chuong.quyTac,
      'Người điều khiển xe phải đi như thế nào về làn đường?',
      [
        'Đi đúng phần đường, làn đường quy định và giữ bên phải theo chiều đi của mình',
        'Đi giữa đường cho dễ quan sát',
        'Đi bên trái để vượt xe thuận tiện',
      ],
      0,
      'Quy tắc cơ bản: đi bên phải theo chiều đi, đúng phần đường và làn đường quy định.',
    ),
    q(
      Chuong.quyTac,
      'Hành vi nào sau đây bị nghiêm cấm?',
      [
        'Nhường đường cho người đi bộ',
        'Đua xe, cổ vũ đua xe, lạng lách, đánh võng trái phép',
        'Giảm tốc độ khi qua khu dân cư',
      ],
      1,
      'Đua xe, lạng lách, đánh võng trái phép gây nguy hiểm cho bản thân và người khác nên bị nghiêm cấm.',
      liet: true,
    ),

    // ======================= CHƯƠNG 2: TỐC ĐỘ VÀ KHOẢNG CÁCH =======================
    q(
      Chuong.tocDo,
      'Trong khu vực đông dân cư, trên đường hai chiều (không có dải phân cách giữa) hoặc đường một chiều có một làn xe cơ giới, xe mô tô được chạy tối đa bao nhiêu?',
      ['40 km/h', '50 km/h', '60 km/h'],
      1,
      'Theo Thông tư 38/2024/TT-BGTVT: khu đông dân cư, đường hai chiều hoặc một chiều một làn: tối đa 50 km/h.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.tocDo,
      'Trong khu vực đông dân cư, trên đường đôi (có dải phân cách giữa) hoặc đường một chiều từ hai làn xe cơ giới trở lên, xe mô tô được chạy tối đa bao nhiêu?',
      ['50 km/h', '60 km/h', '70 km/h'],
      1,
      'Theo Thông tư 38/2024/TT-BGTVT: khu đông dân cư, đường đôi hoặc một chiều từ hai làn trở lên: tối đa 60 km/h.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.tocDo,
      'Ngoài khu vực đông dân cư, trên đường đôi (có dải phân cách giữa) hoặc đường một chiều từ hai làn xe cơ giới trở lên, xe mô tô được chạy tối đa bao nhiêu?',
      ['60 km/h', '70 km/h', '80 km/h'],
      1,
      'Theo Thông tư 38/2024/TT-BGTVT: ngoài khu đông dân cư, đường đôi hoặc một chiều từ hai làn trở lên: tối đa 70 km/h.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.tocDo,
      'Ngoài khu vực đông dân cư, trên đường hai chiều (không có dải phân cách giữa) hoặc đường một chiều có một làn xe cơ giới, xe mô tô được chạy tối đa bao nhiêu?',
      ['50 km/h', '60 km/h', '70 km/h'],
      1,
      'Theo Thông tư 38/2024/TT-BGTVT: ngoài khu đông dân cư, đường hai chiều hoặc một chiều một làn: tối đa 60 km/h.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.tocDo,
      'Xe gắn máy (kể cả xe máy điện) được chạy tối đa bao nhiêu km/h trên đường bộ (trừ đường cao tốc)?',
      ['30 km/h', '40 km/h', '50 km/h'],
      1,
      'Theo Thông tư 38/2024/TT-BGTVT, xe gắn máy chạy tối đa 40 km/h trên đường bộ, trừ đường cao tốc.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.tocDo,
      'Khi trời mưa, đường trơn, người lái xe cần làm gì về tốc độ và khoảng cách?',
      [
        'Giữ nguyên tốc độ và khoảng cách',
        'Giảm tốc độ và tăng khoảng cách an toàn với xe phía trước',
        'Tăng tốc để nhanh về đến nơi',
      ],
      1,
      'Đường trơn làm quãng đường phanh dài hơn nên phải giảm tốc độ và giữ khoảng cách lớn hơn.',
    ),
    q(
      Chuong.tocDo,
      'Khi nào người lái xe phải giảm tốc độ?',
      [
        'Khi đến gần nơi giao nhau, đường cong, nơi tầm nhìn hạn chế hoặc có nhiều người đi bộ',
        'Chỉ khi thấy công an',
        'Không bao giờ phải giảm tốc độ nếu đang đi đúng làn',
      ],
      0,
      'Phải giảm tốc độ ở nơi có nguy cơ mất an toàn: giao lộ, đường cong, tầm nhìn hạn chế, đông người đi bộ.',
    ),
    q(
      Chuong.tocDo,
      'Tốc độ xe càng cao thì khoảng cách an toàn với xe phía trước phải như thế nào?',
      ['Càng nhỏ', 'Càng lớn', 'Không thay đổi'],
      1,
      'Tốc độ càng cao, quãng đường dừng xe càng dài nên khoảng cách an toàn phải càng lớn.',
    ),
    q(
      Chuong.tocDo,
      'Giữ khoảng cách an toàn với xe phía trước để làm gì?',
      [
        'Để có đủ thời gian và quãng đường xử lý, tránh va chạm khi xe phía trước phanh gấp',
        'Để xe đi trông đẹp hơn',
        'Để dễ bấm còi xin đường',
      ],
      0,
      'Khoảng cách an toàn giúp kịp phản ứng khi xe phía trước giảm tốc hoặc dừng đột ngột.',
    ),

    // ======================= CHƯƠNG 3: VĂN HOÁ VÀ ĐẠO ĐỨC =======================
    q(
      Chuong.vanHoa,
      'Khi thấy người già, trẻ em hoặc người khuyết tật qua đường, người lái xe nên làm gì?',
      [
        'Bấm còi thúc giục',
        'Giảm tốc độ, nhường đường và giúp đỡ khi cần thiết',
        'Tăng tốc đi qua trước',
      ],
      1,
      'Văn hoá giao thông là nhường đường, giúp đỡ người yếu thế.',
    ),
    q(
      Chuong.vanHoa,
      'Khi có người đi bộ đang qua đường tại vạch dành cho người đi bộ, người lái xe phải làm gì?',
      [
        'Giảm tốc độ, nhường đường cho người đi bộ',
        'Bấm còi để người đi bộ chạy nhanh',
        'Vượt qua nhanh trước người đi bộ',
      ],
      0,
      'Người điều khiển phương tiện phải giảm tốc độ và nhường đường cho người đi bộ qua đường.',
    ),
    q(
      Chuong.vanHoa,
      'Hành vi nào thể hiện văn hoá giao thông tốt?',
      [
        'Nhường đường, đi đúng làn, tôn trọng người cùng tham gia giao thông',
        'Chen lấn khi tắc đường',
        'Vượt đèn đỏ khi vắng người',
      ],
      0,
      'Tôn trọng luật, nhường nhịn và đi đúng làn giúp giao thông an toàn, văn minh.',
    ),
    q(
      Chuong.vanHoa,
      'Khi bị người khác bấm còi hoặc to tiếng trên đường, bạn nên xử lý thế nào?',
      [
        'Giữ bình tĩnh, không tranh cãi, tiếp tục đi an toàn',
        'Dừng xe cãi nhau với họ',
        'Đuổi theo để "dạy" họ một bài học',
      ],
      0,
      'Giữ bình tĩnh tránh xung đột và tai nạn đáng tiếc.',
    ),
    q(
      Chuong.vanHoa,
      'Người lái xe không được bấm còi ở đâu?',
      [
        'Trong khu vực có biển báo cấm sử dụng còi',
        'Mọi nơi, kể cả khi cần cảnh báo nguy hiểm',
        'Chỉ ở đường cao tốc',
      ],
      0,
      'Không sử dụng còi tại nơi có biển cấm; chỉ bấm còi khi cần thiết để cảnh báo, tránh gây ồn.',
    ),
    q(
      Chuong.vanHoa,
      'Khi cảm thấy mệt mỏi, buồn ngủ trong lúc lái xe, bạn nên làm gì?',
      [
        'Cố gắng chạy tiếp cho đến nơi',
        'Dừng xe ở nơi an toàn để nghỉ ngơi',
        'Uống rượu bia cho tỉnh táo',
      ],
      1,
      'Lái xe khi buồn ngủ rất nguy hiểm; hãy dừng nghỉ ở nơi an toàn.',
    ),
    q(
      Chuong.vanHoa,
      'Khi đi trong nhóm đông người, người lái xe cần tránh hành vi nào?',
      [
        'Đi dàn hàng ngang, chiếm lòng đường gây cản trở giao thông',
        'Đi hàng một, giữ khoảng cách',
        'Chấp hành tín hiệu đèn',
      ],
      0,
      'Đi dàn hàng ngang cản trở các xe khác và dễ gây tai nạn.',
    ),

    // ======================= CHƯƠNG 4: KỸ THUẬT LÁI XE VÀ CẤU TẠO =======================
    q(
      Chuong.kyThuat,
      'Khi đi qua đoạn đường trơn trượt, người lái xe cần làm gì?',
      [
        'Giảm tốc độ, tránh phanh gấp và đánh lái đột ngột',
        'Tăng ga để vượt nhanh',
        'Phanh gấp bằng phanh trước',
      ],
      0,
      'Đường trơn dễ trượt bánh; phanh gấp hoặc bẻ lái đột ngột dễ gây ngã xe.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.kyThuat,
      'Để phanh xe mô tô an toàn, nên làm như thế nào?',
      [
        'Chỉ dùng phanh trước',
        'Chỉ dùng phanh sau',
        'Giảm ga và sử dụng đồng thời cả phanh trước và phanh sau',
      ],
      2,
      'Dùng phối hợp cả hai phanh giúp xe dừng ổn định, giảm nguy cơ trượt bánh.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.kyThuat,
      'Khi vào đường cong, người lái xe mô tô nên làm gì?',
      [
        'Giảm tốc độ trước khi vào cua, không phanh gấp trong lúc đang cua',
        'Tăng tốc mạnh khi vào cua',
        'Phanh gấp ngay giữa khúc cua',
      ],
      0,
      'Giảm tốc trước khi vào cua giúp xe ổn định, tránh trượt bánh hoặc văng ra ngoài.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.kyThuat,
      'Khi xuống dốc dài, người lái xe nên làm gì?',
      [
        'Tắt máy để tiết kiệm xăng',
        'Về số thấp (dùng phanh động cơ) kết hợp phanh, không để xe lao tự do',
        'Đi số cao và thả trôi',
      ],
      1,
      'Dùng số thấp để động cơ hỗ trợ giữ tốc độ, kết hợp phanh khi cần; tuyệt đối không tắt máy hay thả trôi.',
    ),
    q(
      Chuong.kyThuat,
      'Trước khi khởi hành, người lái xe mô tô nên kiểm tra những bộ phận nào?',
      [
        'Phanh, đèn, lốp, còi và gương',
        'Chỉ cần kiểm tra xăng',
        'Không cần kiểm tra gì nếu xe mới',
      ],
      0,
      'Kiểm tra các bộ phận liên quan an toàn: phanh, đèn, lốp, còi, gương trước mỗi chuyến đi.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.kyThuat,
      'Ly hợp (côn) trên xe mô tô có tác dụng gì?',
      [
        'Truyền hoặc ngắt truyền động từ động cơ đến hộp số',
        'Làm mát động cơ',
        'Lọc không khí cho động cơ',
      ],
      0,
      'Ly hợp nối hoặc ngắt truyền động từ động cơ đến hộp số, giúp sang số và khởi hành êm.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.kyThuat,
      'Bugi trong động cơ xăng có tác dụng gì?',
      [
        'Bôi trơn động cơ',
        'Tạo tia lửa điện đốt cháy hỗn hợp xăng và không khí',
        'Lọc xăng',
      ],
      1,
      'Bugi phóng tia lửa điện để đốt cháy hỗn hợp nhiên liệu - không khí trong buồng đốt.',
    ),
    q(
      Chuong.kyThuat,
      'Lọc gió (lọc không khí) có tác dụng gì?',
      [
        'Lọc bụi bẩn trong không khí trước khi vào buồng đốt',
        'Lọc xăng trước khi vào bình',
        'Làm mát lốp xe',
      ],
      0,
      'Lọc gió giữ bụi bẩn, bảo vệ động cơ khỏi mài mòn và giúp cháy tốt hơn.',
    ),
    q(
      Chuong.kyThuat,
      'Dầu bôi trơn (nhớt) trong động cơ có tác dụng chính là gì?',
      [
        'Chỉ để tăng tốc nhanh hơn',
        'Bôi trơn, làm mát và giảm mài mòn các chi tiết động cơ',
        'Chỉ để làm sạch bình xăng',
      ],
      1,
      'Nhớt tạo lớp màng bôi trơn, giảm ma sát, hỗ trợ làm mát và làm sạch động cơ.',
    ),
    q(
      Chuong.kyThuat,
      'Lốp xe quá non hơi gây hậu quả gì?',
      [
        'Tốn nhiên liệu, mòn lốp nhanh và giảm ổn định khi lái',
        'Xe đi êm và tiết kiệm xăng hơn',
        'Không ảnh hưởng gì',
      ],
      0,
      'Lốp non hơi tăng ma sát, hao xăng, mòn không đều và xe dễ mất lái khi vào cua, phanh.',
    ),
    q(
      Chuong.kyThuat,
      'Khi đi ban đêm gặp xe đi ngược chiều, người lái xe cần làm gì?',
      [
        'Chuyển sang đèn chiếu gần (đèn cốt)',
        'Giữ nguyên đèn chiếu xa',
        'Tắt hết đèn',
      ],
      0,
      'Chuyển đèn cốt để không làm chói mắt người lái xe ngược chiều.',
    ),
    q(
      Chuong.kyThuat,
      'Tư thế ngồi lái xe mô tô đúng là gì?',
      [
        'Ngồi thẳng, hai tay giữ chắc ghi đông, mắt nhìn về phía trước',
        'Một tay cầm lái, một tay cầm điện thoại',
        'Ngồi lệch, nhìn xuống đồng hồ liên tục',
      ],
      0,
      'Tư thế đúng giúp kiểm soát xe tốt và quan sát tình huống phía trước.',
      pv: PhamVi.xeMay,
    ),
    q(
      Chuong.kyThuat,
      'Khi xe bị chết máy giữa đường đông xe, bạn nên làm gì?',
      [
        'Dừng ngay giữa đường để sửa',
        'Nhanh chóng đưa xe vào lề an toàn rồi mới kiểm tra',
        'Bỏ xe lại giữa đường',
      ],
      1,
      'Đưa xe ra khỏi làn đường để tránh cản trở và nguy cơ bị va chạm.',
    ),

    // ======================= CHƯƠNG 5: BIỂN BÁO VÀ VẠCH KẺ ĐƯỜNG =======================
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      [
        'Cấm đi ngược chiều',
        'Đường một chiều',
        'Cấm tất cả các loại xe',
      ],
      0,
      'Biển P.102: Cấm đi ngược chiều. Xe không được đi vào đường theo hướng đặt biển.',
      liet: true,
      bb: 'P.102',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      [
        'Giảm tốc độ',
        'Dừng lại, quan sát và nhường đường trước khi đi tiếp',
        'Cấm dừng xe',
      ],
      1,
      'Biển P.124: Dừng lại. Xe phải dừng trước vạch dừng, quan sát rồi mới được đi tiếp.',
      liet: true,
      bb: 'P.124',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      ['Cấm rẽ trái', 'Cấm rẽ phải', 'Chỉ được rẽ trái'],
      0,
      'Biển P.123a: Cấm rẽ trái.',
      bb: 'P.123a',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      ['Cấm rẽ trái', 'Cấm rẽ phải', 'Chỉ được rẽ phải'],
      1,
      'Biển P.123b: Cấm rẽ phải.',
      bb: 'P.123b',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      [
        'Tốc độ tối thiểu cho phép là 50 km/h',
        'Tốc độ tối đa cho phép là 50 km/h',
        'Hạn chế trọng tải 50 tấn',
      ],
      1,
      'Biển P.127: Tốc độ tối đa cho phép. Số trên biển là tốc độ tối đa (km/h).',
      bb: 'P.127',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      ['Cấm xe mô tô', 'Chỉ dành cho xe mô tô', 'Nơi đỗ xe mô tô'],
      0,
      'Biển P.104: Cấm xe mô tô.',
      bb: 'P.104',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      ['Cấm đỗ xe', 'Cấm dừng và đỗ xe', 'Được phép đỗ xe'],
      0,
      'Biển P.131a: Cấm đỗ xe (một vạch chéo). Xe có thể dừng nhưng không được đỗ.',
      bb: 'P.131a',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      ['Cấm đỗ xe', 'Cấm dừng và đỗ xe', 'Hết cấm dừng xe'],
      1,
      'Biển P.130: Cấm dừng xe và đỗ xe (hai vạch chéo hình chữ X).',
      bb: 'P.130',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      [
        'Đường dành cho người đi bộ, cấm xe',
        'Báo hiệu nơi có người đi bộ cắt ngang đường',
        'Nơi dừng xe buýt',
      ],
      1,
      'Biển W.224: Người đi bộ cắt ngang. Người lái xe phải giảm tốc độ và chú ý nhường đường.',
      bb: 'W.224',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      [
        'Báo hiệu gần trường học, nơi thường có trẻ em qua đường',
        'Khu vui chơi giải trí',
        'Cấm trẻ em đi bộ',
      ],
      0,
      'Biển W.225: Trẻ em. Báo gần nơi thường có trẻ em, cần giảm tốc độ và chú ý quan sát.',
      bb: 'W.225',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      [
        'Cấm đi thẳng',
        'Hướng đi phải theo: các xe chỉ được đi thẳng',
        'Đường cụt',
      ],
      1,
      'Biển R.301: Hướng đi phải theo. Mũi tên hướng lên: xe chỉ được đi thẳng.',
      bb: 'R.301',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      ['Đường một chiều', 'Cấm đi ngược chiều', 'Đường hai chiều'],
      0,
      'Biển I.407a: Đường một chiều. Xe chỉ được đi theo hướng mũi tên.',
      bb: 'I.407a',
    ),
    q(
      Chuong.bienBao,
      'Biển báo này có ý nghĩa gì?',
      ['Cấm đỗ xe', 'Nơi đỗ xe', 'Bến xe buýt'],
      1,
      'Biển I.408: Nơi đỗ xe.',
      bb: 'I.408',
    ),
    q(
      Chuong.bienBao,
      'Biển báo hình tam giác đều, viền đỏ, nền vàng thuộc nhóm biển nào?',
      ['Biển báo cấm', 'Biển báo nguy hiểm và cảnh báo', 'Biển chỉ dẫn'],
      1,
      'Biển nguy hiểm có hình tam giác đều, viền đỏ, nền vàng, hình vẽ màu đen.',
    ),
    q(
      Chuong.bienBao,
      'Biển báo hình tròn, nền xanh, hình vẽ màu trắng thuộc nhóm biển nào?',
      ['Biển hiệu lệnh', 'Biển báo cấm', 'Biển phụ'],
      0,
      'Biển hiệu lệnh có hình tròn, nền xanh, hình vẽ trắng: người tham gia giao thông phải chấp hành.',
    ),
    q(
      Chuong.bienBao,
      'Biển báo hình tròn, viền đỏ, nền trắng thuộc nhóm biển nào?',
      ['Biển báo cấm', 'Biển báo nguy hiểm', 'Biển chỉ dẫn'],
      0,
      'Biển báo cấm thường có hình tròn, viền đỏ, nền trắng (một số biển nền đỏ hoặc xanh), báo điều cấm.',
    ),

    // ============ PHẦN Ô TÔ (hạng B, C1, C): xem file ngan_hang_o_to.dart ============
    // Dùng chung hàm q (chung bộ đếm) nên mã số nối tiếp sau 63 câu ở trên.
    ...cauHoiOTo(q),
  ];
}
