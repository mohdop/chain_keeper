import 'package:flutter/material.dart';
import 'dart:math' as math;

class BridgeVisual extends StatefulWidget {
  final int streak;
  final double size;

  const BridgeVisual({
    Key? key,
    required this.streak,
    this.size = 200,
  }) : super(key: key);

  @override
  State<BridgeVisual> createState() => _BridgeVisualState();
}

class _BridgeVisualState extends State<BridgeVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _buildAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _buildAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(BridgeVisual oldWidget) {
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
      animation: _buildAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: BridgePainter(
            streak: widget.streak,
            animation: _buildAnimation.value,
          ),
        );
      },
    );
  }
}

class BridgePainter extends CustomPainter {
  final int streak;
  final double animation;

  BridgePainter({
    required this.streak,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dessiner l'arrière-plan (ciel et paysage)
    _drawBackground(canvas, size);

    // Dessiner l'eau
    _drawWater(canvas, size);

    // Dessiner les montagnes au loin
    _drawMountains(canvas, size);

    // Points de départ et d'arrivée du pont
    final startX = size.width * 0.1;
    final endX = size.width * 0.9;
    final bridgeY = size.height * 0.6;

    // Dessiner les piliers de support (tous les 7 jours)
    _drawPillars(canvas, size, startX, endX, bridgeY);

    // Dessiner les planches du pont
    _drawPlanks(canvas, size, startX, endX, bridgeY);

    // Dessiner les plateformes de départ et d'arrivée
    _drawPlatforms(canvas, size, startX, endX, bridgeY);

    // Si streak >= 30, ajouter un arc décoratif
    if (streak >= 30) {
      _drawDecorativeArch(canvas, size, startX, endX, bridgeY);
    }

    // Ajouter des oiseaux si streak >= 20
    if (streak >= 20) {
      _drawBirds(canvas, size);
    }
  }

  void _drawBackground(Canvas canvas, Size size) {
    // Dégradé de ciel
    final skyRect = Rect.fromLTWH(0, 0, size.width, size.height * 0.7);
    final skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF4A90E2),
        const Color(0xFF87CEEB),
      ],
    );

    final skyPaint = Paint()..shader = skyGradient.createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);
  }

  void _drawWater(Canvas canvas, Size size) {
    final waterRect = Rect.fromLTWH(
      0,
      size.height * 0.65,
      size.width,
      size.height * 0.35,
    );

    final waterGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF2E86AB),
        const Color(0xFF1A5F7A),
      ],
    );

    final waterPaint = Paint()..shader = waterGradient.createShader(waterRect);
    canvas.drawRect(waterRect, waterPaint);

    // Vagues
    final wavePaint = Paint()
      ..color = const Color(0xFF3A96BA).withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final wavePath = Path();
      final waveY = size.height * 0.7 + i * 15;
      wavePath.moveTo(0, waveY);

      for (double x = 0; x < size.width; x += 20) {
        wavePath.quadraticBezierTo(
          x + 10,
          waveY - 3,
          x + 20,
          waveY,
        );
      }

      canvas.drawPath(wavePath, wavePaint);
    }
  }

  void _drawMountains(Canvas canvas, Size size) {
    final mountainPaint = Paint()
      ..color = const Color(0xFF5D4E6D).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Montagne gauche
    final leftMountain = Path();
    leftMountain.moveTo(0, size.height * 0.65);
    leftMountain.lineTo(size.width * 0.15, size.height * 0.4);
    leftMountain.lineTo(size.width * 0.3, size.height * 0.65);
    leftMountain.close();
    canvas.drawPath(leftMountain, mountainPaint);

    // Montagne droite
    final rightMountain = Path();
    rightMountain.moveTo(size.width * 0.7, size.height * 0.65);
    rightMountain.lineTo(size.width * 0.85, size.height * 0.35);
    rightMountain.lineTo(size.width, size.height * 0.65);
    rightMountain.close();
    canvas.drawPath(rightMountain, mountainPaint);
  }

  void _drawPlatforms(Canvas canvas, Size size, double startX, double endX, double bridgeY) {
    final platformPaint = Paint()
      ..color = const Color(0xFF6D4C41)
      ..style = PaintingStyle.fill;

    // Plateforme de départ (gauche)
    final leftPlatform = RRect.fromRectAndRadius(
      Rect.fromLTWH(startX - 25, bridgeY - 5, 30, size.height * 0.5),
      const Radius.circular(5),
    );
    canvas.drawRRect(leftPlatform, platformPaint);

    // Plateforme d'arrivée (droite)
    final rightPlatform = RRect.fromRectAndRadius(
      Rect.fromLTWH(endX - 5, bridgeY - 5, 30, size.height * 0.5),
      const Radius.circular(5),
    );
    canvas.drawRRect(rightPlatform, platformPaint);

    // Herbe sur les plateformes
    final grassPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(startX - 25, bridgeY - 10, 30, 5),
      grassPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(endX - 5, bridgeY - 10, 30, 5),
      grassPaint,
    );
  }

  void _drawPillars(Canvas canvas, Size size, double startX, double endX, double bridgeY) {
    if (streak < 7) return;

    final pillarPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..style = PaintingStyle.fill;

    final bridgeWidth = endX - startX;
    final numberOfPillars = (streak ~/ 7).clamp(0, 4);

    for (int i = 1; i <= numberOfPillars; i++) {
      final pillarX = startX + (bridgeWidth / 5) * i;
      
      // Pilier principal
      final pillar = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          pillarX - 8,
          bridgeY,
          16,
          size.height * 0.3,
        ),
        const Radius.circular(3),
      );
      canvas.drawRRect(pillar, pillarPaint);

      // Détails du pilier
      final detailPaint = Paint()
        ..color = const Color(0xFF6D4C41)
        ..strokeWidth = 2;

      canvas.drawLine(
        Offset(pillarX - 8, bridgeY + 10),
        Offset(pillarX + 8, bridgeY + 10),
        detailPaint,
      );
      canvas.drawLine(
        Offset(pillarX - 8, bridgeY + 20),
        Offset(pillarX + 8, bridgeY + 20),
        detailPaint,
      );
    }
  }

  void _drawPlanks(Canvas canvas, Size size, double startX, double endX, double bridgeY) {
    if (streak == 0) return;

    final bridgeWidth = endX - startX;
    final plankWidth = 8.0;
    final gap = 2.0;
    final totalPlankWidth = plankWidth + gap;

    // Nombre de planches basé sur le streak (avec animation)
    final maxPlanks = (bridgeWidth / totalPlankWidth).floor();
    final visiblePlanks = math.min(streak, maxPlanks);
    final animatedPlanks = (visiblePlanks * animation).floor();

    final plankPaint = Paint()
      ..color = const Color(0xFFD2691E)
      ..style = PaintingStyle.fill;

    final plankShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < animatedPlanks; i++) {
      final plankX = startX + (i * totalPlankWidth);

      // Ombre de la planche
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            plankX + 2,
            bridgeY + 2,
            plankWidth,
            12,
          ),
          const Radius.circular(2),
        ),
        plankShadowPaint,
      );

      // Planche
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            plankX,
            bridgeY,
            plankWidth,
            12,
          ),
          const Radius.circular(2),
        ),
        plankPaint,
      );

      // Détails du bois (lignes)
      final woodDetailPaint = Paint()
        ..color = const Color(0xFFA0522D)
        ..strokeWidth = 1;

      canvas.drawLine(
        Offset(plankX + 2, bridgeY + 3),
        Offset(plankX + 2, bridgeY + 9),
        woodDetailPaint,
      );
      canvas.drawLine(
        Offset(plankX + 6, bridgeY + 3),
        Offset(plankX + 6, bridgeY + 9),
        woodDetailPaint,
      );
    }

    // Garde-corps (rambardes)
    if (animatedPlanks > 5) {
      _drawRailing(canvas, startX, bridgeY, animatedPlanks, totalPlankWidth);
    }
  }

  void _drawRailing(Canvas canvas, double startX, double bridgeY, int planks, double plankWidth) {
    final railPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final railLength = planks * plankWidth;

    // Rambarde supérieure
    canvas.drawLine(
      Offset(startX, bridgeY - 15),
      Offset(startX + railLength, bridgeY - 15),
      railPaint,
    );

    // Poteaux verticaux
    final postPaint = Paint()
      ..color = const Color(0xFF6D4C41)
      ..strokeWidth = 2;

    for (int i = 0; i < planks; i += 5) {
      final postX = startX + (i * plankWidth);
      canvas.drawLine(
        Offset(postX, bridgeY),
        Offset(postX, bridgeY - 15),
        postPaint,
      );
    }
  }

  void _drawDecorativeArch(Canvas canvas, Size size, double startX, double endX, double bridgeY) {
    final archPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.8)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final centerX = (startX + endX) / 2;
    final archPath = Path();
    
    archPath.moveTo(startX, bridgeY - 5);
    archPath.quadraticBezierTo(
      centerX,
      bridgeY - 40,
      endX,
      bridgeY - 5,
    );

    canvas.drawPath(archPath, archPaint);

    // Étoiles décoratives sur l'arc
    final starPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final t = i / 4;
      final x = startX + (endX - startX) * t;
      final y = bridgeY - 5 - (4 * t * (1 - t) * 40);
      
      _drawStar(canvas, Offset(x, y), 4, starPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final x = center.dx + size * math.cos(angle);
      final y = center.dy + size * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBirds(Canvas canvas, Size size) {
    final birdPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Oiseau 1
    _drawSingleBird(canvas, Offset(size.width * 0.3, size.height * 0.2), birdPaint);
    
    // Oiseau 2
    _drawSingleBird(canvas, Offset(size.width * 0.6, size.height * 0.25), birdPaint);
    
    // Oiseau 3
    _drawSingleBird(canvas, Offset(size.width * 0.75, size.height * 0.15), birdPaint);
  }

  void _drawSingleBird(Canvas canvas, Offset position, Paint paint) {
    final birdPath = Path();
    
    // Aile gauche
    birdPath.moveTo(position.dx - 8, position.dy);
    birdPath.quadraticBezierTo(
      position.dx - 4,
      position.dy - 5,
      position.dx,
      position.dy - 2,
    );
    
    // Aile droite
    birdPath.moveTo(position.dx, position.dy - 2);
    birdPath.quadraticBezierTo(
      position.dx + 4,
      position.dy - 5,
      position.dx + 8,
      position.dy,
    );
    
    canvas.drawPath(birdPath, paint);
  }

  @override
  bool shouldRepaint(BridgePainter oldDelegate) {
    return oldDelegate.streak != streak || oldDelegate.animation != animation;
  }
}