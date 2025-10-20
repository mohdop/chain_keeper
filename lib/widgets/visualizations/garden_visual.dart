import 'package:flutter/material.dart';
import 'dart:math' as math;

class GardenVisual extends StatefulWidget {
  final int streak;
  final double size;

  const GardenVisual({
    Key? key,
    required this.streak,
    this.size = 200,
  }) : super(key: key);

  @override
  State<GardenVisual> createState() => _GardenVisualState();
}

class _GardenVisualState extends State<GardenVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _growAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _growAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(GardenVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streak != widget.streak) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _growAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: GardenPainter(
            streak: widget.streak,
            animation: _growAnimation.value,
          ),
        );
      },
    );
  }
}

class GardenPainter extends CustomPainter {
  final int streak;
  final double animation;

  GardenPainter({
    required this.streak,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height;

    // Sol (herbe)
    _drawGround(canvas, size);

    // Calculer la hauteur de la tige basée sur le streak
    final stemHeight = _calculateStemHeight(streak, size.height);
    final animatedStemHeight = stemHeight * animation;

    // Dessiner la tige
    _drawStem(canvas, centerX, centerY, animatedStemHeight);

    // Dessiner les feuilles si streak >= 2
    if (streak >= 2 && animatedStemHeight > size.height * 0.2) {
      _drawLeaves(canvas, centerX, centerY, animatedStemHeight);
    }

    // Dessiner le bourgeon/fleur si streak >= 4
    if (streak >= 4) {
      _drawFlower(canvas, centerX, centerY - animatedStemHeight, streak);
    }

    // Ajouter des papillons si streak >= 30
    if (streak >= 30) {
      _drawButterflies(canvas, size, centerX, centerY - animatedStemHeight);
    }
  }

  void _drawGround(Canvas canvas, Size size) {
    final groundPaint = Paint()
      ..color = const Color(0xFF2D5016)
      ..style = PaintingStyle.fill;

    final groundRect = Rect.fromLTWH(
      0,
      size.height - 20,
      size.width,
      20,
    );

    canvas.drawRect(groundRect, groundPaint);

    // Petits brins d'herbe
    final grassPaint = Paint()
      ..color = const Color(0xFF3D6B1F)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i + 10;
      canvas.drawLine(
        Offset(x, size.height - 20),
        Offset(x, size.height - 30),
        grassPaint,
      );
    }
  }

  double _calculateStemHeight(int streak, double maxHeight) {
    if (streak <= 3) {
      return maxHeight * 0.3 * (streak / 3);
    } else if (streak <= 7) {
      return maxHeight * 0.3 + (maxHeight * 0.2) * ((streak - 3) / 4);
    } else {
      return math.min(maxHeight * 0.6, maxHeight * 0.5 + (streak - 7) * 5);
    }
  }

  void _drawStem(Canvas canvas, double x, double y, double height) {
    final stemPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Tige principale (légèrement courbée)
    final path = Path();
    path.moveTo(x, y - 20);

    final controlPointX = x + math.sin(height / 50) * 10;
    path.quadraticBezierTo(
      controlPointX,
      y - height / 2 - 20,
      x,
      y - height - 20,
    );

    canvas.drawPath(path, stemPaint);
  }

  void _drawLeaves(Canvas canvas, double x, double y, double stemHeight) {
    final leafPaint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..style = PaintingStyle.fill;

    // Feuille gauche
    final leftLeafPath = Path();
    final leftLeafY = y - stemHeight * 0.4 - 20;
    leftLeafPath.moveTo(x, leftLeafY);
    leftLeafPath.quadraticBezierTo(
      x - 20,
      leftLeafY - 10,
      x - 25,
      leftLeafY - 5,
    );
    leftLeafPath.quadraticBezierTo(
      x - 20,
      leftLeafY,
      x,
      leftLeafY,
    );
    canvas.drawPath(leftLeafPath, leafPaint);

    // Feuille droite
    final rightLeafPath = Path();
    final rightLeafY = y - stemHeight * 0.6 - 20;
    rightLeafPath.moveTo(x, rightLeafY);
    rightLeafPath.quadraticBezierTo(
      x + 20,
      rightLeafY - 10,
      x + 25,
      rightLeafY - 5,
    );
    rightLeafPath.quadraticBezierTo(
      x + 20,
      rightLeafY,
      x,
      rightLeafY,
    );
    canvas.drawPath(rightLeafPath, leafPaint);
  }

  void _drawFlower(Canvas canvas, double x, double y, int streak) {
    final flowerCenterY = y;

    // Nombre de pétales basé sur le streak
    final petalCount = math.min(8, 3 + (streak ~/ 2));
    final petalSize = math.min(20.0, 10.0 + streak * 0.5);

    // Couleur des pétales devient plus vibrante avec le streak
    final petalColor = Color.lerp(
      const Color(0xFFFF6B9D),
      const Color(0xFFFF1744),
      math.min(1.0, streak / 30),
    )!;

    final petalPaint = Paint()
      ..color = petalColor
      ..style = PaintingStyle.fill;

    // Dessiner les pétales
    for (int i = 0; i < petalCount; i++) {
      final angle = (2 * math.pi * i) / petalCount;
      final petalX = x + math.cos(angle) * 15;
      final petalY = flowerCenterY + math.sin(angle) * 15;

      canvas.drawCircle(
        Offset(petalX, petalY),
        petalSize * animation,
        petalPaint,
      );
    }

    // Centre de la fleur
    final centerPaint = Paint()
      ..color = const Color(0xFFFDD835)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(x, flowerCenterY),
      12 * animation,
      centerPaint,
    );

    // Détails du centre
    final centerDetailPaint = Paint()
      ..color = const Color(0xFFFBC02D)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(x, flowerCenterY),
      6 * animation,
      centerDetailPaint,
    );
  }

  void _drawButterflies(Canvas canvas, Size size, double flowerX, double flowerY) {
    final butterflyPaint = Paint()
      ..color = const Color(0xFFFF6B9D).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Papillon 1 (en haut à droite)
    final butterfly1X = flowerX + 30 + math.sin(DateTime.now().millisecondsSinceEpoch / 500) * 5;
    final butterfly1Y = flowerY - 30 + math.cos(DateTime.now().millisecondsSinceEpoch / 500) * 3;

    _drawSingleButterfly(canvas, butterfly1X, butterfly1Y, butterflyPaint);

    // Papillon 2 (en haut à gauche)
    final butterfly2X = flowerX - 30 + math.cos(DateTime.now().millisecondsSinceEpoch / 700) * 5;
    final butterfly2Y = flowerY - 40 + math.sin(DateTime.now().millisecondsSinceEpoch / 700) * 3;

    _drawSingleButterfly(canvas, butterfly2X, butterfly2Y, butterflyPaint);
  }

  void _drawSingleButterfly(Canvas canvas, double x, double y, Paint paint) {
    // Aile gauche
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x - 4, y), width: 8, height: 12),
      paint,
    );

    // Aile droite
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x + 4, y), width: 8, height: 12),
      paint,
    );

    // Corps
    final bodyPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(x, y - 6),
      Offset(x, y + 6),
      bodyPaint,
    );
  }

  @override
  bool shouldRepaint(GardenPainter oldDelegate) {
    return oldDelegate.streak != streak || oldDelegate.animation != animation;
  }
}