import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SimpleBarChart extends StatelessWidget {
  final List<double> values;
  final List<DateTime> labels;
  final Color barColor;

  const SimpleBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.barColor = const Color(0xFF6B8E8E), // Muted Teal consistent with App Seed
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final displayMax = maxValue == 0 ? 100.0 : maxValue * 1.2;

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(values.length, (index) {
                  final heightFactor = values[index] / displayMax;
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          values[index].toStringAsFixed(0),
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: heightFactor.clamp(0.01, 1.0),
                            widthFactor: 0.6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: barColor.withValues(alpha: 0.7),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: labels.map((date) {
                return Expanded(
                  child: Text(
                    DateFormat.MMM().format(date),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleLineChart extends StatelessWidget {
  final List<double> values;
  final List<DateTime> labels;
  final Color lineColor;

  const SimpleLineChart({
    super.key,
    required this.values,
    required this.labels,
    this.lineColor = const Color(0xFF6B8E8E),
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomPaint(
          painter: _LineChartPainter(values: values, lineColor: lineColor),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;

  _LineChartPainter({required this.values, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withValues(alpha: 0.3), lineColor.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final displayMax = maxValue == 0 ? 100.0 : maxValue * 1.2;

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / displayMax * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      
      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / displayMax * size.height);
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ComparisonBarChart extends StatelessWidget {
  final List<double> values1;
  final List<double> values2;
  final List<DateTime> labels;
  final String label1;
  final String label2;
  final Color color1;
  final Color color2;

  const ComparisonBarChart({
    super.key,
    required this.values1,
    required this.values2,
    required this.labels,
    required this.label1,
    required this.label2,
    this.color1 = const Color(0xFF2E7D32), // Income Green
    this.color2 = const Color(0xFF965F5F), // Expense Red
  });

  @override
  Widget build(BuildContext context) {
    if (values1.isEmpty || values2.isEmpty) return const SizedBox.shrink();

    double maxValue = 0;
    for (int i = 0; i < values1.length; i++) {
      if (values1[i] > maxValue) maxValue = values1[i];
      if (values2[i] > maxValue) maxValue = values2[i];
    }
    final displayMax = maxValue == 0 ? 100.0 : maxValue * 1.2;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(labels.length, (index) {
                      final height1 = (values1[index] / displayMax).clamp(0.01, 1.0);
                      final height2 = (values2[index] / displayMax).clamp(0.01, 1.0);

                      return Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: FractionallySizedBox(
                                heightFactor: height1,
                                widthFactor: 0.8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color1.withValues(alpha: 0.7),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: FractionallySizedBox(
                                heightFactor: height2,
                                widthFactor: 0.8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color2.withValues(alpha: 0.7),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: labels.map((date) {
                    return Expanded(
                      child: Text(
                        DateFormat.MMM().format(date),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(color: color1, label: label1),
            const SizedBox(width: 24),
            _LegendItem(color: color2, label: label2),
          ],
        ),
      ],
    );
  }
}

class StackedBarChart extends StatelessWidget {
  final List<double> values1; // Bottom layer (e.g. Planned)
  final List<double> values2; // Top layer (e.g. Unplanned)
  final List<DateTime> labels;
  final Color color1;
  final Color color2;
  final String? label1;
  final String? label2;

  const StackedBarChart({
    super.key,
    required this.values1,
    required this.values2,
    required this.labels,
    this.color1 = const Color(0xFFBDC9C9), // Muted light teal
    this.color2 = const Color(0xFF8A7A5F), // Muted taupe
    this.label1,
    this.label2,
  });

  @override
  Widget build(BuildContext context) {
    if (values1.isEmpty) return const SizedBox.shrink();

    final totals = List.generate(values1.length, (i) => values1[i] + values2[i]);
    final maxTotal = totals.reduce((a, b) => a > b ? a : b);
    final displayMax = maxTotal == 0 ? 100.0 : maxTotal * 1.2;

    return Column(
      children: [
        if (label1 != null && label2 != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(color: color1, label: label1!),
                const SizedBox(width: 16),
                _LegendItem(color: color2, label: label2!),
              ],
            ),
          ),
        AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values1.length, (index) {
                final h1 = values1[index] / displayMax;
                final h2 = values2[index] / displayMax;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (totals[index] > 0)
                        Text(
                          totals[index].toStringAsFixed(0),
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (h2 > 0)
                                Flexible(
                                  flex: (h2 * 1000).toInt().clamp(1, 1000),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color2.withValues(alpha: 0.8),
                                      borderRadius: h1 > 0 
                                        ? const BorderRadius.vertical(top: Radius.circular(3))
                                        : BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              if (h1 > 0)
                                Flexible(
                                  flex: (h1 * 1000).toInt().clamp(1, 1000),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color1.withValues(alpha: 0.8),
                                      borderRadius: h2 > 0
                                        ? const BorderRadius.vertical(bottom: Radius.circular(3))
                                        : BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Simplified labels for weeks (e.g. every 4th week or just first/last)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                DateFormat.MMMd().format(labels.first),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
            Text(
              DateFormat.MMMd().format(labels[labels.length ~/ 2]),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                DateFormat.MMMd().format(labels.last),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}
