import 'package:flutter/material.dart';

class SplashLogoAnimation extends StatefulWidget {
  const SplashLogoAnimation({
    super.key,
    required this.child,
    this.entranceDuration = const Duration(milliseconds: 900),
    this.breathingDuration = const Duration(milliseconds: 1600),
  });

  final Widget child;
  final Duration entranceDuration;
  final Duration breathingDuration;

  @override
  State<SplashLogoAnimation> createState() => _SplashLogoAnimationState();
}

class _SplashLogoAnimationState extends State<SplashLogoAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _entranceScale;
  late final Animation<double> _entranceOpacity;

  late final AnimationController _breathingController;
  late final Animation<double> _breathingScale;

  @override
  void initState() {
    super.initState();

    // Entrance: zoom OUT from 1.4x down to 1.0x while fading in.
    _entranceController = AnimationController(
      vsync: this,
      duration: widget.entranceDuration,
    );

    _entranceScale = Tween<double>(begin: 1.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _entranceOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _breathingController = AnimationController(
      vsync: this,
      duration: widget.breathingDuration,
    );

    _breathingScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.03), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.03, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _entranceController.forward().whenComplete(() {
      if (mounted) _breathingController.repeat();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _breathingController]),
      builder: (context, child) {
        final scale = _entranceScale.value *
            (_entranceController.isCompleted ? _breathingScale.value : 1.0);
        return Opacity(
          opacity: _entranceOpacity.value,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: widget.child,
    );
  }
}