// ============================================================================
// FILE: lib/widgets/bien_bao_widget.dart
// VAI TRÒ: Vẽ hình biển báo bằng widget/CustomPaint (không dùng ảnh ngoài).
// Hình vẽ mang tính MINH HOẠ, hãy đối chiếu biển thật trong sách/đề thi.
// Cách dùng: BienBaoWidget(ma: 'P.102', size: 96)
// ============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';

const _xanh = Color(0xFF1565C0); // nền biển hiệu lệnh, chỉ dẫn
const _do = Color(0xFFD32F2F); // viền biển cấm, nền biển dừng lại

class BienBaoWidget extends StatelessWidget {
  const BienBaoWidget({super.key, required this.ma, this.size = 96});

  /// Mã biển, vd 'P.102'.
  final String ma;

  /// Kích thước (rộng và cao) của hình, đơn vị pixel logic.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size, child: Center(child: _ve()));
  }

  /// Chọn cách vẽ theo mã biển.
  Widget _ve() {
    switch (ma) {
      case 'P.102': // Cấm đi ngược chiều: nền đỏ, vạch ngang trắng
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: _do),
          alignment: Alignment.center,
          child: Container(width: size * 0.62, height: size * 0.14, color: Colors.white),
        );
      case 'P.124': // Dừng lại: hình bát giác đỏ
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _BatGiacPainter(),
            child: Center(
              child: Text(
                'DỪNG LẠI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.13,
                ),
              ),
            ),
          ),
        );
      case 'P.123a': // Cấm rẽ trái
        return _tronCam(Icons.turn_left, gachCheo: 1);
      case 'P.123b': // Cấm rẽ phải
        return _tronCam(Icons.turn_right, gachCheo: 1);
      case 'P.104': // Cấm xe mô tô
        return _tronCam(Icons.two_wheeler, gachCheo: 1);
      case 'P.127': // Tốc độ tối đa 50 km/h
        return _tronCam(null, chu: '50');
      case 'P.103a': // Cấm xe ô tô
        return _tronCam(Icons.directions_car, gachCheo: 1);
      case 'P.106a': // Cấm xe ô tô tải
        return _tronCam(Icons.local_shipping, gachCheo: 1);
      case 'P.128': // Cấm sử dụng còi
        return _tronCam(Icons.campaign, gachCheo: 1);
      case 'P.115': // Hạn chế tải trọng toàn bộ xe
        return _tronCam(null, chu: '10t', coChu: 0.3);
      case 'P.117': // Hạn chế chiều cao
        return _tronCam(null, chu: '3,5m', coChu: 0.24);
      case 'P.125': // Cấm vượt: xe đỏ (xe vượt) bên trái, xe đen bên phải
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: _do, width: size * 0.12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car, color: _do, size: size * 0.3),
              Icon(Icons.directions_car, color: Colors.black, size: size * 0.3),
            ],
          ),
        );
      case 'R.303': // Vòng xuyến: nền xanh, mũi tên vòng trắng
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: _xanh),
          child: Icon(Icons.sync, color: Colors.white, size: size * 0.66),
        );
      case 'W.208': // Giao nhau với đường ưu tiên: tam giác đỉnh quay xuống
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _TamGiacPainter(nguoc: true)),
        );
      case 'I.401': // Bắt đầu đường ưu tiên: hình vuông vàng viền trắng, xoay 45 độ
        return Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: size * 0.62,
            height: size * 0.62,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC107),
              border: Border.all(color: Colors.white, width: size * 0.06),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
            ),
          ),
        );
      case 'P.131a': // Cấm đỗ xe: nền xanh, viền đỏ, một vạch chéo
        return _tronXanhVienDo(soVach: 1);
      case 'P.130': // Cấm dừng và đỗ: nền xanh, viền đỏ, hai vạch chéo
        return _tronXanhVienDo(soVach: 2);
      case 'W.224': // Người đi bộ cắt ngang
        return _tamGiac(Icons.directions_walk);
      case 'W.225': // Trẻ em
        return _tamGiac(Icons.child_care);
      case 'R.301': // Hướng đi phải theo: nền xanh, mũi tên trắng
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: _xanh),
          child: Icon(Icons.arrow_upward, color: Colors.white, size: size * 0.62),
        );
      case 'I.407a': // Đường một chiều: chữ nhật xanh, mũi tên trắng
        return Container(
          width: size,
          height: size * 0.7,
          decoration: BoxDecoration(
            color: _xanh,
            borderRadius: BorderRadius.circular(size * 0.06),
          ),
          child: Icon(Icons.arrow_upward, color: Colors.white, size: size * 0.5),
        );
      case 'I.408': // Nơi đỗ xe: vuông xanh, chữ P trắng
        return Container(
          width: size * 0.85,
          height: size * 0.85,
          decoration: BoxDecoration(
            color: _xanh,
            borderRadius: BorderRadius.circular(size * 0.06),
          ),
          alignment: Alignment.center,
          child: Text(
            'P',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.6,
            ),
          ),
        );
      default:
        // Mã lạ: hiện khung xám có dấu hỏi để không bị lỗi.
        return Container(
          width: size,
          height: size,
          color: Colors.grey.shade300,
          child: const Icon(Icons.help_outline),
        );
    }
  }

  /// Biển cấm hình tròn: viền đỏ, nền trắng, hình đen ở giữa, có thể gạch chéo đỏ.
  Widget _tronCam(IconData? icon,
      {String? chu, int gachCheo = 0, double coChu = 0.42}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: _do, width: size * 0.12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (icon != null) Icon(icon, color: Colors.black, size: size * 0.52),
          if (chu != null)
            Text(
              chu,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size * coChu,
              ),
            ),
          if (gachCheo > 0) _vachCheo(),
        ],
      ),
    );
  }

  /// Biển cấm đỗ / cấm dừng và đỗ: nền xanh, viền đỏ, [soVach] vạch đỏ.
  Widget _tronXanhVienDo({required int soVach}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _xanh,
        border: Border.all(color: _do, width: size * 0.12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _vachCheo(),
          if (soVach == 2) _vachCheo(nguoc: true),
        ],
      ),
    );
  }

  /// Một vạch đỏ chéo 45 độ. [nguoc] true thì chéo ngược lại (tạo chữ X).
  Widget _vachCheo({bool nguoc = false}) {
    return Transform.rotate(
      angle: (nguoc ? 1 : -1) * math.pi / 4,
      child: Container(width: size * 0.74, height: size * 0.09, color: _do),
    );
  }

  /// Biển nguy hiểm: tam giác viền đỏ, nền vàng, hình đen bên trong.
  Widget _tamGiac(IconData icon) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TamGiacPainter(),
        child: Align(
          alignment: const Alignment(0, 0.38),
          child: Icon(icon, color: Colors.black, size: size * 0.4),
        ),
      ),
    );
  }
}

/// Vẽ hình bát giác đều màu đỏ, có đường viền trắng bên trong.
class _BatGiacPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    Path dinh(double ban) {
      final p = Path();
      for (var i = 0; i < 8; i++) {
        // 8 đỉnh, lệch 22,5 độ để có cạnh phẳng nằm ngang ở trên và dưới.
        final goc = math.pi / 8 + i * math.pi / 4;
        final x = c.dx + ban * math.cos(goc);
        final y = c.dy + ban * math.sin(goc);
        if (i == 0) {
          p.moveTo(x, y);
        } else {
          p.lineTo(x, y);
        }
      }
      return p..close();
    }

    canvas.drawPath(dinh(r), Paint()..color = _do);
    canvas.drawPath(
      dinh(r * 0.88),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.06,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Vẽ tam giác đều: nền vàng, viền đỏ.
class _TamGiacPainter extends CustomPainter {
  _TamGiacPainter({this.nguoc = false});

  /// true: đỉnh tam giác quay xuống dưới (biển W.208).
  final bool nguoc;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    if (nguoc) {
      path
        ..moveTo(w / 2, h * 0.95)
        ..lineTo(w * 0.97, h * 0.08)
        ..lineTo(w * 0.03, h * 0.08)
        ..close();
    } else {
      path
        ..moveTo(w / 2, h * 0.05)
        ..lineTo(w * 0.97, h * 0.92)
        ..lineTo(w * 0.03, h * 0.92)
        ..close();
    }
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawPath(
      path,
      Paint()
        ..color = _do
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.07
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
