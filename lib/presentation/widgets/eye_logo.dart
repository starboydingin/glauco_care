import 'package:flutter/material.dart';

/// GlaucoCare stylised eye logo — matches the swooping-wing brand mark.
/// [eyeColor] — the main fill colour (almond shape + iris ring).
/// [bgColor]  — colour used to cut out sclera and pupil (must match the
///              surface behind the logo for the "cut-out" effect).
class GlaucoEyeLogo extends StatelessWidget {
  final double width;
  final double height;
  final Color eyeColor;
  final Color bgColor;

  const GlaucoEyeLogo({
    super.key,
    required this.width,
    required this.height,
    required this.eyeColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _EyePainter(eyeColor: eyeColor, bgColor: bgColor),
    );
  }
}

class _EyePainter extends CustomPainter {
  final Color eyeColor;
  final Color bgColor;

  const _EyePainter({required this.eyeColor, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Vertical centre sits slightly below mid to leave room for upper wing
    final cy = h * 0.58;

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = eyeColor;

    // ── 1. Main almond / wing silhouette ───────────────────────────────────
    // Matches reference: dramatic swept-up upper lid, lower tail curl on right
    final body = Path();
    body.moveTo(w * 0.02, cy);                        // sharp left tip

    // Upper-left wing — sweeps HIGH above the centre line
    body.cubicTo(
      w * 0.12, h * 0.02,
      w * 0.38, h * -0.04,
      w * 0.50, h * 0.22,
    );
    // Upper-right curve — descends gently to right side
    body.cubicTo(
      w * 0.62, h * 0.38,
      w * 0.82, h * 0.42,
      w * 0.98, cy,
    );
    // Lower-right tail — curls slightly upward (the distinctive tail)
    body.cubicTo(
      w * 0.90, h * 0.98,
      w * 0.70, h * 1.06,
      w * 0.54, h * 0.92,
    );
    // Lower-left return — gentle arc back to left tip
    body.cubicTo(
      w * 0.38, h * 0.80,
      w * 0.14, h * 0.84,
      w * 0.02, cy,
    );
    body.close();
    canvas.drawPath(body, fill);

    // ── 2. Sclera (cut-out circle) ─────────────────────────────────────────
    fill.color = bgColor;
    // Positioned slightly right-of-centre, like the reference
    final eyeCx = w * 0.54;
    final eyeCy = cy * 0.96;
    final r = h * 0.34;
    canvas.drawCircle(Offset(eyeCx, eyeCy), r, fill);

    // ── 3. Iris ring ───────────────────────────────────────────────────────
    fill.color = eyeColor;
    canvas.drawCircle(Offset(eyeCx, eyeCy), r * 0.66, fill);

    // ── 4. Pupil (cut-out centre) ──────────────────────────────────────────
    fill.color = bgColor;
    canvas.drawCircle(Offset(eyeCx, eyeCy), r * 0.33, fill);
  }

  @override
  bool shouldRepaint(_EyePainter old) =>
      old.eyeColor != eyeColor || old.bgColor != bgColor;
}
