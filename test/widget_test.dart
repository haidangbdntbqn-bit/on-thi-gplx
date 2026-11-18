// Kiểm tra tự động cho app ôn thi giấy phép lái xe.
//   1. Dữ liệu: mã câu không trùng, đáp án đúng nằm trong danh sách đáp án,
//      mã biển báo trong câu hỏi đều vẽ được, mỗi hạng đủ câu để ra đề.
//   2. Tạo đề: đúng số câu, đúng 1 câu điểm liệt, không lẫn câu của hạng khác.
//   3. Giao diện: app khởi động, đổi hạng thì nút thi thử đổi theo.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:on_thi_a1/data/bien_bao_data.dart';
import 'package:on_thi_a1/data/ngan_hang.dart';
import 'package:on_thi_a1/data/tao_de.dart';
import 'package:on_thi_a1/main.dart';
import 'package:on_thi_a1/models/cau_hoi.dart';
import 'package:on_thi_a1/models/hang_bang.dart';
import 'package:on_thi_a1/models/ket_qua_thi.dart';
import 'package:on_thi_a1/services/luu_tru.dart';

void main() {
  group('Ngân hàng câu hỏi', () {
    test('mã câu duy nhất và liên tục từ 1', () {
      final ids = nganHang.map((c) => c.id).toList();
      expect(ids.toSet().length, ids.length);
      expect(ids.first, 1);
      expect(ids.last, nganHang.length);
    });

    test('63 câu đầu giữ nguyên mã (không làm lệch tiến độ đã lưu)', () {
      expect(nganHang[62].id, 63);
      expect(nganHang[62].phamVi, PhamVi.chung);
      expect(nganHang[63].phamVi, PhamVi.oTo);
    });

    test('mỗi câu có 2-4 đáp án và đáp án đúng hợp lệ', () {
      for (final c in nganHang) {
        expect(c.dapAn.length, inInclusiveRange(2, 4), reason: 'câu ${c.id}');
        expect(c.dung, inInclusiveRange(0, c.dapAn.length - 1),
            reason: 'câu ${c.id}');
        expect(c.dapAn.toSet().length, c.dapAn.length, reason: 'câu ${c.id}');
        expect(c.giaiThich, isNotEmpty, reason: 'câu ${c.id}');
      }
    });

    test('mã biển báo trong câu hỏi đều có trong danh sách biển', () {
      for (final c in nganHang.where((c) => c.bienBao != null)) {
        expect(timBienBao(c.bienBao!), isNotNull, reason: 'câu ${c.id}');
      }
    });

    test('A1 không có câu ô tô; B không có câu xe tải và xe máy', () {
      expect(cauCuaHang(HangBang.a1).any((c) => c.phamVi == PhamVi.oTo), isFalse);
      expect(cauCuaHang(HangBang.a1).any((c) => c.phamVi == PhamVi.xeTai), isFalse);
      expect(cauCuaHang(HangBang.b).any((c) => c.phamVi == PhamVi.xeTai), isFalse);
      expect(cauCuaHang(HangBang.b).any((c) => c.phamVi == PhamVi.xeMay), isFalse);
      expect(cauCuaHang(HangBang.c).any((c) => c.phamVi == PhamVi.xeTai), isTrue);
    });
  });

  group('Cấu trúc đề theo hạng', () {
    test('trước và từ 01/3/2027', () {
      final truoc = DateTime(2026, 11, 17);
      final sau = DateTime(2027, 3, 1);
      expect(HangBang.a1.cauTruc(truoc).soCau, 25);
      expect(HangBang.b.cauTruc(truoc).soCau, 30);
      expect(HangBang.b.cauTruc(truoc).diemDat, 27);
      expect(HangBang.c1.cauTruc(truoc).soCau, 35);
      expect(HangBang.c.cauTruc(truoc).soCau, 40);
      expect(HangBang.a1.cauTruc(sau).soCau, 40);
      expect(HangBang.b.cauTruc(sau).soCau, 50);
      expect(HangBang.c1.cauTruc(sau).soCau, 60);
      expect(HangBang.c.cauTruc(sau).soCau, 70);
      expect(HangBang.c.cauTruc(sau).diemDat, 63);
    });

    test('tạo đề: đủ số câu, đúng 1 câu điểm liệt, đúng phạm vi hạng', () {
      for (final h in HangBang.values) {
        for (final ct in [h.hienTai, h.tuNam2027]) {
          final de = taoDeThi(h, ct);
          expect(de.length, ct.soCau, reason: 'hạng ${h.ma} ${ct.soCau} câu');
          expect(de.where((c) => c.diemLiet).length, 1, reason: 'hạng ${h.ma}');
          expect(de.map((c) => c.id).toSet().length, de.length);
          expect(de.every((c) => h.apDung(c.phamVi)), isTrue);
        }
      }
    });

    test('lịch sử cũ (chưa có hạng) vẫn đọc được, mặc định A1', () {
      final k = KetQuaThi.fromJson(
          '{"ngay":"2026-11-04T19:40:00.000","diem":22,"tong":25,"liet":false,"giay":300}');
      expect(k.hang, HangBang.a1);
      expect(k.diemDat, 21);
      expect(k.dat, isTrue);
      final k2 = KetQuaThi.fromJson(k.toJson());
      expect(k2.hang, HangBang.a1);
      expect(k2.diem, 22);
    });
  });

  testWidgets('App khởi động, đổi hạng thì nút thi thử đổi theo', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await LuuTru.instance.khoiTao();
    LuuTru.instance.chonHang(HangBang.a1);
    await tester.pumpWidget(const OnThiA1());
    expect(find.text('Ôn thi giấy phép lái xe'), findsWidgets);
    expect(find.textContaining('Thi thử hạng A1'), findsOneWidget);

    await tester.tap(find.text('C'));
    await tester.pumpAndSettle();
    expect(LuuTru.instance.hang, HangBang.c);
    expect(find.textContaining('Thi thử hạng C ('), findsOneWidget);
    expect(find.text('Ôn tập hạng C', skipOffstage: false), findsOneWidget);
  });

  testWidgets('Thi thử hạng B: làm bài, nộp, ra màn hình kết quả', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await LuuTru.instance.khoiTao();
    LuuTru.instance.chonHang(HangBang.b);
    await tester.pumpWidget(const OnThiA1());
    await tester.tap(find.textContaining('Thi thử hạng B ('));
    await tester.pumpAndSettle();
    expect(find.textContaining('Câu 1/'), findsOneWidget);

    // Mở bảng chọn câu rồi nhảy tới câu cuối để nộp bài.
    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pumpAndSettle();
    final soCau = HangBang.b.cauTruc().soCau;
    await tester.tap(find.widgetWithText(ActionChip, '$soCau'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Nộp bài'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Nộp bài').last);
    await tester.pumpAndSettle();

    expect(find.text('Kết quả thi thử hạng B'), findsOneWidget);
    expect(find.text('KHÔNG ĐẠT'), findsOneWidget);
    expect(LuuTru.instance.lichSu.first.hang, HangBang.b);
  });
}
