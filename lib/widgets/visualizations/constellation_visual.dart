import 'package:flutter/material.dart';
import 'dart:math' as math;

class ConstellationVisual extends StatefulWidget {
  final int streak;

  const ConstellationVisual({Key? key, required this.streak}) : super(key: key);

  @override
  State<ConstellationVisual> createState() => _ConstellationVisualState();
}

class _ConstellationVisualState extends State<ConstellationVisual>
    with TickerProviderStateMixin {
  late AnimationController _twinkleController;
  late AnimationController _shootingStarController;
  late AnimationController _glowController;
  List<StarPosition> stars = [];

  @override
  void initState() {
    super.initState();
    
    _twinkleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _shootingStarController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _generateStars();
  }

  void _generateStars() {
    final random = math.Random(42); // Fixed seed for consistent positions
    stars.clear();
    
    final starCount = math.min(widget.streak, 50); // Max 50 stars
    
    for (int i = 0; i < starCount; i++) {
      stars.add(StarPosition(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.7 + 0.1, // Keep stars in upper portion
        size: random.nextDouble() * 2 + 1.5,
        twinkleOffset: random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  @override
  void didUpdateWidget(ConstellationVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streak != widget.streak) {
      _generateStars();
    }
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    _shootingStarController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _twinkleController,
        _shootingStarController,
        _glowController,
      ]),
      builder: (context, child) {
        return CustomPaint(
          painter: ConstellationPainter(
            streak: widget.streak,
            stars: stars,
            twinkleValue: _twinkleController.value,
            shootingStarValue: _shootingStarController.value,
            glowValue: _glowController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class StarPosition {
  final double x;
  final double y;
  final double size;
  final double twinkleOffset;

  StarPosition({
    required this.x,
    required this.y,
    required this.size,
    required this.twinkleOffset,
  });
}

class ConstellationPainter extends CustomPainter {
  final int streak;
  final List<StarPosition> stars;
  final double twinkleValue;
  final double shootingStarValue;
  final double glowValue;

  ConstellationPainter({
    required this.streak,
    required this.stars,
    required this.twinkleValue,
    required this.shootingStarValue,
    required this.glowValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw dark space background
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0A0E27),
          Color(0xFF1A1B3E),
          Color(0xFF2D2E5F),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw moon (appears after day 10)
    if (streak >= 10) {
      _drawMoon(canvas, size);
    }

    // Draw connection lines (appears after day 7)
    if (streak >= 7) {
      _drawConnections(canvas, size);
    }

    // Draw stars
    _drawStars(canvas, size);

    // Draw shooting stars (appears after day 15)
    if (streak >= 15) {
      _drawShootingStar(canvas, size);
    }

    // Draw glow effect (appears after day 30)
    if (streak >= 30) {
      _drawGlowEffect(canvas, size);
    }
  }

  void _drawMoon(Canvas canvas, Size size) {
    final moonX = size.width * 0.85;
    final moonY = size.height * 0.15;
    final moonRadius = size.width * 0.08;

    // Moon glow
    final glowPaint = Paint()
      ..color = Color(0xFFFFFFFF).withOpacity(0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(moonX, moonY), moonRadius + 10, glowPaint);

    // Moon body
    final moonPaint = Paint()
      ..color = Color(0xFFF0E68C)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(moonX, moonY), moonRadius, moonPaint);

    // Moon craters
    final craterPaint = Paint()
      ..color = Color(0xFFE6D68A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(moonX - moonRadius * 0.3, moonY - moonRadius * 0.2),
        moonRadius * 0.2,
        craterPaint);
    canvas.drawCircle(
        Offset(moonX + moonRadius * 0.2, moonY + moonRadius * 0.3),
        moonRadius * 0.15,
        craterPaint);
  }

  void _drawConnections(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Color(0xFF6B7FFF).withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Connect nearby stars
    for (int i = 0; i < stars.length; i++) {
      for (int j = i + 1; j < stars.length; j++) {
        final star1 = stars[i];
        final star2 = stars[j];

        final dx = (star1.x - star2.x) * size.width;
        final dy = (star1.y - star2.y) * size.height;
        final distance = math.sqrt(dx * dx + dy * dy);

        // Only connect stars that are close enough
        if (distance < size.width * 0.15) {
          canvas.drawLine(
            Offset(star1.x * size.width, star1.y * size.height),
            Offset(star2.x * size.width, star2.y * size.height),
            linePaint,
          );
        }
      }
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    for (int i = 0; i < stars.length; i++) {
      final star = stars[i];
      final x = star.x * size.width;
      final y = star.y * size.height;

      // Twinkling effect
      final twinkle = math.sin(twinkleValue * 2 * math.pi + star.twinkleOffset);
      final opacity = 0.6 + (twinkle * 0.4);
      final currentSize = star.size * (0.8 + twinkle * 0.2);

      // Star glow
      final glowPaint = Paint()
        ..color = Color(0xFFFFFFFF).withOpacity(opacity * 0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, currentSize * 2);
      canvas.drawCircle(Offset(x, y), currentSize * 2, glowPaint);

      // Star core
      final starPaint = Paint()
        ..color = Color(0xFFFFFFFF).withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), currentSize, starPaint);

      // Star sparkle (4-pointed star shape)
      _drawSparkle(canvas, x, y, currentSize * 1.5, opacity);
    }
  }

  void _drawSparkle(Canvas canvas, double x, double y, double size, double opacity) {
    final sparklePaint = Paint()
      ..color = Color(0xFFFFFFFF).withOpacity(opacity * 0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Horizontal line
    canvas.drawLine(
      Offset(x - size, y),
      Offset(x + size, y),
      sparklePaint,
    );

    // Vertical line
    canvas.drawLine(
      Offset(x, y - size),
      Offset(x, y + size),
      sparklePaint,
    );
  }

  void _drawShootingStar(Canvas canvas, Size size) {
    // Shooting star moves from top-right to bottom-left
    final progress = shootingStarValue;
    final startX = size.width * (0.7 + progress * 0.3);
    final startY = size.height * (0.1 + progress * 0.4);
    
    // Only draw when in visible range
    if (progress > 0.2 && progress < 0.8) {
      final opacity = (progress < 0.5) 
          ? (progress - 0.2) / 0.3 
          : 1.0 - (progress - 0.5) / 0.3;

      // Shooting star trail
      final trailPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Color(0xFFFFFFFF).withOpacity(opacity * 0.8),
            Color(0xFFFFFFFF).withOpacity(0),
          ],
        ).createShader(Rect.fromPoints(
          Offset(startX, startY),
          Offset(startX + 30, startY + 30),
        ))
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + 30, startY + 30),
        trailPaint,
      );

      // Shooting star head
      final starPaint = Paint()
        ..color = Color(0xFFFFFFFF).withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(startX, startY), 3, starPaint);
    }
  }

  void _drawGlowEffect(Canvas canvas, Size size) {
    // Pulsating glow around the entire constellation
    final glowOpacity = 0.05 + (glowValue * 0.05);
    
    final glowPaint = Paint()
      ..color = Color(0xFF6B7FFF).withOpacity(glowOpacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 50);

    // Draw glow circles around star clusters
    for (var star in stars) {
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        30,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ConstellationPainter oldDelegate) {
    return oldDelegate.twinkleValue != twinkleValue ||
        oldDelegate.shootingStarValue != shootingStarValue ||
        oldDelegate.glowValue != glowValue ||
        oldDelegate.streak != streak;
  }
}