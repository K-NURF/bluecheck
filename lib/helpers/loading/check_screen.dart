import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationOverlay extends StatefulWidget {
  const AnimationOverlay({super.key});

  @override
  _AnimationOverlayState createState() => _AnimationOverlayState();
}

class _AnimationOverlayState extends State<AnimationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, child) {
          return Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(_animation.value),
              child: Center(
                child: Lottie.asset(
                    'assets/lottie/19148-bluetooth-connected.json'),
              ),
            ),
          );
        });
  }
}
