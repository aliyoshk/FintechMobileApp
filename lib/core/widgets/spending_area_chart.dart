import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom-painted area chart matching the Figma's spending graph: smooth
/// curve, gradient fill, a dotted marker line at a highlighted point, and
/// a floating value tooltip. Built with CustomPainter rather than a chart
/// package since this is one visual used in two places — not worth an
/// extra dependency for.
class SpendingAreaChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final int highlightIndex;
  final String highlightValue;

  const SpendingAreaChart({
    super.key,
    required this.values,
    required this.labels,
    required this.highlightIndex,
    required this.highlightValue,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 180,
          width: constraints.maxWidth,
          child: CustomPaint(
            painter: _AreaChartPainter(values: values, highlightIndex: highlightIndex, highlightValue: highlightValue),
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: labels
                        .map((l) => Text(l, style: const TextStyle(color: Colors.white38, fontSize: 11)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  final List<double> values;
  final int highlightIndex;
  final String highlightValue;

  _AreaChartPainter({required this.values, required this.highlightIndex, required this.highlightValue});

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height - 24; // leave room for month labels
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal).abs() < 0.001 ? 1 : (maxVal - minVal);

    final dx = size.width / (values.length - 1);
    final points = <Offset>[
      for (int i = 0; i < values.length; i++)
        Offset(i * dx, chartHeight - ((values[i] - minVal) / range) * chartHeight * 0.85 - chartHeight * 0.1),
    ];

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      linePath.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    linePath.lineTo(points.last.dx, points.last.dy);

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, chartHeight)
      ..lineTo(points.first.dx, chartHeight)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primaryBlue.withValues(alpha: 0.55), AppColors.primaryBlue.withValues(alpha: 0.02)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Dotted vertical marker + highlighted dot at highlightIndex.
    if (highlightIndex >= 0 && highlightIndex < points.length) {
      final marker = points[highlightIndex];
      final dashPaint = Paint()
        ..color = Colors.white24
        ..strokeWidth = 1;
      double y = marker.dy;
      while (y < chartHeight) {
        canvas.drawLine(Offset(marker.dx, y), Offset(marker.dx, y + 4), dashPaint);
        y += 8;
      }

      canvas.drawCircle(marker, 5, Paint()..color = Colors.white);
      canvas.drawCircle(marker, 5, Paint()
        ..color = AppColors.primaryBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);

      final textPainter = TextPainter(
        text: TextSpan(
          text: highlightValue,
          style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final tooltipWidth = textPainter.width + 16;
      final tooltipX = (marker.dx - tooltipWidth / 2).clamp(0, size.width - tooltipWidth);
      final tooltipRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(tooltipX.toDouble(), marker.dy - 34, tooltipWidth, 24),
        const Radius.circular(6),
      );
      canvas.drawRRect(tooltipRect, Paint()..color = Colors.white);
      textPainter.paint(canvas, Offset(tooltipRect.left + 8, tooltipRect.top + 5));
    }
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.highlightIndex != highlightIndex ||
        oldDelegate.highlightValue != highlightValue;
  }
}
