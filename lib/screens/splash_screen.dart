import 'package:flutter/material.dart';
import 'auth_page.dart'; // Import AuthPage for the transition

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      home: const SplashScreen(),
    );
  }
}

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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Faster animation duration
    );

    _circleAnimation = Tween<double>(begin: 0, end: 1000).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _logoSizeAnimation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // Transition to AuthPage after animation completes and a short delay
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
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
              // Gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepOrange.shade700, // Top gradient color
                      Colors.orangeAccent.shade100, // Bottom gradient color
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Expanding white circle animation
              Container(
                width: _circleAnimation.value,
                height: _circleAnimation.value,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              // Logo and text animation
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo size
                  Image.asset(
                    'images/EventMatch_Adobe.png', // Replace with your transparent logo
                    height: _logoSizeAnimation.value,
                  ),
                  if (_circleAnimation.value > 900)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        AnimatedLetters(
                          text: 'EventMatch',
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.blue],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

// Animated letter-by-letter gradient text widget
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
      duration: const Duration(
          milliseconds:
              1400), // Faster animation duration (2 seconds for all text)
    )..forward();

    // Create list of animations for each letter with an even faster speed
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
