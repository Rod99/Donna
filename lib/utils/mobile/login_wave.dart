import 'package:flutter/material.dart';

class WaveLogin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _WaveLoginPainter(),
      ),
    );
  }
}

class _WaveLoginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = new Paint();

    //Propiedades
    lapiz.color = Color.fromARGB(255, 0, 176, 255);
    lapiz.style = PaintingStyle.fill;
    lapiz.strokeWidth = 10;

    final camino = new Path();

    // Dibujar con el path y el camino
    camino.moveTo(0, size.height);
    camino.lineTo(0, size.height * 0.92);
    camino.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.4, size.height * 0.90);
    camino.quadraticBezierTo(size.width * 0.75, size.height * 0.70, size.width, size.height * 0.75);
    camino.lineTo(size.width, size.height);

    canvas.drawPath(camino, lapiz);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}