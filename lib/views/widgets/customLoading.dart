import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';

class CustomActivityIndicator extends StatefulWidget {
  final double? radius;

  CustomActivityIndicator({this.radius});

  @override
  _CustomActivityIndicatorState createState() =>
      _CustomActivityIndicatorState();
}

class _CustomActivityIndicatorState extends State<CustomActivityIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1200))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return CustomPaint(
          painter: CirclePainter(
            progress: _animationController!.value,
            radius: widget.radius ?? 12,
          ),
        );
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;
  final double radius;

  CirclePainter({required this.progress, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);
    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 3 * progress,
      tileMode: TileMode.repeated,
      colors: [kPrimaryColor, kblackColor, kwhiteColor],
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;
    canvas.drawArc(rect, 0.0, 2 * pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
