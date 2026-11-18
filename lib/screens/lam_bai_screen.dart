// ============================================================================
// FILE: lib/screens/lam_bai_screen.dart
// VAI TRÒ: Màn hình LÀM BÀI dùng chung cho mọi chế độ. Có 2 chế độ:
//
//   CheDo.onTap  (ôn tập): chọn đáp án là biết đúng/sai NGAY, có giải thích,
//                          mỗi câu chỉ được chọn 1 lần. Không tính giờ.
//   CheDo.thiThu (thi thử): giống thi thật. Có đồng hồ đếm ngược, không báo
//                          đúng/sai, được đổi đáp án, nhảy tới câu bất kỳ,
//                          hết giờ hoặc bấm "Nộp bài" thì chấm điểm.
//                          Thời gian và điểm đạt lấy theo cấu trúc đề của
//                          hạng bằng (tham số hang + cauTruc).
//
// Màn hình nhận vào danh sách câu hỏi [cauHoi] nên dùng lại cho: ôn theo
// chương, ôn câu sai, ngẫu nhiên, thi thử.
// ============================================================================

import 'dart:async';

import 'package:flutter/material.dart';

import '../models/cau_hoi.dart';
import '../models/hang_bang.dart';
import '../models/ket_qua_thi.dart';
import '../services/luu_tru.dart';
import '../utils/dinh_dang.dart';
import '../widgets/bien_bao_widget.dart';
import 'ket_qua_screen.dart';

enum CheDo { onTap, thiThu }

class LamBaiScreen extends StatefulWidget {
  const LamBaiScreen({
    super.key,
    required this.tieuDe,
    required this.cauHoi,
    required this.cheDo,
    this.hang,
    this.cauTruc,
  }) : assert(cheDo == CheDo.onTap || (hang != null && cauTruc != null),
            'Thi thử phải truyền hang và cauTruc');

  final String tieuDe;
  final List<CauHoi> cauHoi;
  final CheDo cheDo;

  /// Hạng bằng đang thi (bắt buộc với thi thử).
  final HangBang? hang;

  /// Cấu trúc đề: thời gian, điểm đạt (bắt buộc với thi thử).
  final CauTruc? cauTruc;

  @override
  State<LamBaiScreen> createState() => _LamBaiScreenState();
}

class _LamBaiScreenState extends State<LamBaiScreen> {
  /// Đáp án người dùng đã chọn cho từng câu (null = chưa trả lời).
  late final List<int?> chon = List<int?>.filled(widget.cauHoi.length, null);

  /// Chỉ số câu đang hiển thị (bắt đầu từ 0).
  int i = 0;

  /// Đồng hồ đếm ngược (chỉ dùng ở chế độ thi thử).
  Timer? _timer;
  late int conLai = (widget.cauTruc?.phut ?? 0) * 60;
  final DateTime _batDau = DateTime.now();
  bool _daNop = false;

  bool get thiThu => widget.cheDo == CheDo.thiThu;
  CauHoi get cau => widget.cauHoi[i];

  @override
  void initState() {
    super.initState();
    if (thiThu) {
      // Mỗi giây giảm 1 và vẽ lại; hết giờ thì tự nộp bài.
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => conLai--);
        if (conLai <= 0) _nop();
      });
    }
  }

  @override
  void dispose() {
    // Rất quan trọng: huỷ đồng hồ khi rời màn hình, nếu không nó vẫn chạy ngầm.
    _timer?.cancel();
    super.dispose();
  }

  /// Người dùng chọn đáp án thứ [k] của câu hiện tại.
  void _chon(int k) {
    if (!thiThu) {
      // Ôn tập: đã trả lời rồi thì khoá, không cho đổi.
      if (chon[i] != null) return;
      setState(() => chon[i] = k);
      // Ghi nhận ngay vào bộ nhớ: đúng -> bỏ khỏi "câu sai"; sai -> thêm vào.
      LuuTru.instance.ghiNhan(cau.id, k == cau.dung);
    } else {
      // Thi thử: được đổi đáp án thoải mái cho đến khi nộp.
      setState(() => chon[i] = k);
    }
  }

  /// Chấm điểm, lưu kết quả rồi chuyển sang màn hình kết quả.
  void _nop() {
    if (_daNop) return;
    _daNop = true;
    _timer?.cancel();

    var diem = 0;
    var liet = false;
    final kq = <int, bool>{};
    for (var j = 0; j < widget.cauHoi.length; j++) {
      final c = widget.cauHoi[j];
      final dungKhong = chon[j] == c.dung; // câu bỏ trống tính là sai
      kq[c.id] = dungKhong;
      if (dungKhong) {
        diem++;
      } else if (c.diemLiet) {
        liet = true; // sai câu điểm liệt
      }
    }
    LuuTru.instance.ghiNhanNhieu(kq);

    final ketQua = KetQuaThi(
      ngay: DateTime.now(),
      hang: widget.hang ?? LuuTru.instance.hang,
      diem: diem,
      tong: widget.cauHoi.length,
      diemDat: widget.cauTruc?.diemDat ?? widget.cauHoi.length,
      saiDiemLiet: liet,
      giay: DateTime.now().difference(_batDau).inSeconds,
    );
    LuuTru.instance.themLichSu(ketQua);

    // pushAndRemoveUntil: bỏ màn hình làm bài (và cả hộp thoại nếu đang mở),
    // chỉ giữ màn hình đầu tiên, rồi mở màn hình kết quả.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => KetQuaScreen(
          ketQua: ketQua,
          cauHoi: widget.cauHoi,
          chon: List<int?>.of(chon),
        ),
      ),
      (route) => route.isFirst,
    );
  }

  /// Hỏi xác nhận trước khi nộp bài.
  Future<void> _hoiNop() async {
    final chuaLam = chon.where((e) => e == null).length;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nộp bài?'),
        content: Text(chuaLam == 0
            ? 'Bạn đã trả lời tất cả các câu.'
            : 'Bạn còn $chuaLam câu chưa trả lời.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Làm tiếp'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Nộp bài'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) _nop();
  }

  /// Kết thúc lượt ôn tập: hiện tổng kết rồi thoát.
  Future<void> _xongOnTap() async {
    final dem = List.generate(widget.cauHoi.length, (j) => j)
        .where((j) => chon[j] == widget.cauHoi[j].dung)
        .length;
    final traLoi = chon.where((e) => e != null).length;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hoàn thành'),
        content: Text(
            'Bạn đã trả lời $traLoi/${widget.cauHoi.length} câu, đúng $dem câu.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  /// Bảng chọn nhanh câu (chỉ ở chế độ thi thử).
  void _moBang() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var j = 0; j < widget.cauHoi.length; j++)
                ActionChip(
                  label: Text('${j + 1}'),
                  // Câu đã trả lời tô màu để dễ nhận.
                  backgroundColor: chon[j] != null
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  side: j == i
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2)
                      : null,
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => i = j);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tong = widget.cauHoi.length;

    final scaffold = Scaffold(
      appBar: AppBar(
        title: Text(widget.tieuDe),
        actions: [
          if (thiThu) ...[
            // Đồng hồ: đỏ khi còn dưới 1 phút.
            Center(
              child: Text(
                mmss(conLai),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: conLai < 60 ? Colors.red : null,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Danh sách câu',
              icon: const Icon(Icons.grid_view),
              onPressed: _moBang,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Thanh tiến độ: đang ở câu thứ mấy.
          LinearProgressIndicator(value: (i + 1) / tong),
          // Phần câu hỏi: cuộn được để không bị tràn màn hình.
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Câu ${i + 1}/$tong',
                          style: Theme.of(context).textTheme.labelLarge),
                      Chip(
                        label: Text(cau.chuong.ten),
                        visualDensity: VisualDensity.compact,
                      ),
                      // Ôn tập thì báo trước câu điểm liệt; thi thử thì giấu.
                      if (!thiThu && cau.diemLiet)
                        Chip(
                          label: const Text('Điểm liệt'),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.red.shade100,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(cau.noiDung,
                      style: Theme.of(context).textTheme.titleMedium),
                  if (cau.bienBao != null) ...[
                    const SizedBox(height: 16),
                    Center(child: BienBaoWidget(ma: cau.bienBao!, size: 120)),
                  ],
                  const SizedBox(height: 16),
                  for (var k = 0; k < cau.dapAn.length; k++) _dapAn(k, cs),
                  // Giải thích: chỉ hiện ở ôn tập sau khi đã trả lời.
                  if (!thiThu && chon[i] != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Giải thích: ${cau.giaiThich}'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Thanh nút điều hướng ở đáy.
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: i > 0 ? () => setState(() => i--) : null,
                    child: const Text('Câu trước'),
                  ),
                  const Spacer(),
                  _nutSau(tong),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Thi thử: bấm nút Back thì hỏi lại, tránh mất bài do bấm nhầm.
    if (!thiThu) return scaffold;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final thoat = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Thoát bài thi?'),
            content: const Text('Kết quả bài làm này sẽ không được lưu.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Ở lại'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Thoát'),
              ),
            ],
          ),
        );
        if (thoat == true && context.mounted) {
          _timer?.cancel();
          Navigator.pop(context);
        }
      },
      child: scaffold,
    );
  }

  /// Nút bên phải đáy: "Câu sau", hoặc "Nộp bài" / "Hoàn thành" ở câu cuối.
  Widget _nutSau(int tong) {
    final cuoi = i == tong - 1;
    if (!cuoi) {
      return FilledButton(
        onPressed: () => setState(() => i++),
        child: const Text('Câu sau'),
      );
    }
    return FilledButton(
      onPressed: thiThu ? _hoiNop : _xongOnTap,
      child: Text(thiThu ? 'Nộp bài' : 'Hoàn thành'),
    );
  }

  /// Một dòng đáp án (A, B, C...), tô màu theo trạng thái.
  Widget _dapAn(int k, ColorScheme cs) {
    final daChon = chon[i];
    var nen = cs.surface;
    var vien = cs.outlineVariant;
    IconData? icon;

    if (!thiThu && daChon != null) {
      // Ôn tập đã trả lời: xanh = đáp án đúng, đỏ = bạn chọn sai.
      if (k == cau.dung) {
        nen = Colors.green.shade50;
        vien = Colors.green;
        icon = Icons.check_circle;
      } else if (k == daChon) {
        nen = Colors.red.shade50;
        vien = Colors.red;
        icon = Icons.cancel;
      }
    } else if (thiThu && daChon == k) {
      // Thi thử: chỉ tô đáp án đang chọn, không tiết lộ đúng sai.
      nen = cs.primaryContainer;
      vien = cs.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: nen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: vien, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _chon(k),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  child: Text(String.fromCharCode(65 + k)), // A, B, C...
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(cau.dapAn[k])),
                if (icon != null)
                  Icon(icon, color: k == cau.dung ? Colors.green : Colors.red),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
