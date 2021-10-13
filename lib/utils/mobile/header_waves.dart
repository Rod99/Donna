import 'package:flutter/material.dart';

class HeaderWaves extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderWavesPainter(),
      ),
    );
  }
}

class _HeaderWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint();

    // Propiedades
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2;

    final path = Path();

    // Dibujar
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.35,
        size.width * 0.5, size.height * 0.3,
    );
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.25,
        size.width, size.height * 0.3,
    );
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
