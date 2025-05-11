import 'package:flutter/material.dart';
import 'auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _circleAnimation;
  late final Animation<double> _logoSizeAnimation;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _circleAnimation = Tween<double>(begin: 0, end: 1000).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _logoSizeAnimation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_navigated) {
        _navigated = true;

        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthPage()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepOrange.shade700,
                      Colors.orangeAccent.shade100,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Container(
                width: _circleAnimation.value,
                height: _circleAnimation.value,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/EventMatch_Adobe.png',
                    height: _logoSizeAnimation.value,
                  ),
                  if (_circleAnimation.value > 900) const SizedBox(height: 20),
                  if (_circleAnimation.value > 900)
                    const AnimatedLetters(
                      text: 'EventMatch',
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.blue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class AnimatedLetters extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const AnimatedLetters({
    required this.text,
    required this.gradient,
    required this.style,
    super.key,
  });

  @override
  _AnimatedLettersState createState() => _AnimatedLettersState();
}

class _AnimatedLettersState extends State<AnimatedLetters>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _letterAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _letterAnimations = List.generate(widget.text.length, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index / widget.text.length,
            (index + 1) / widget.text.length,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return widget.gradient.createShader(Offset.zero & bounds.size);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.text.length, (index) {
          final letter = widget.text[index];
          return FadeTransition(
            opacity: _letterAnimations[index],
            child: Text(
              letter,
              style: widget.style.copyWith(color: Colors.white),
            ),
          );
        }),
      ),
    );
  }
}
