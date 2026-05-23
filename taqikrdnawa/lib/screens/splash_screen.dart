import 'package:flutter/material.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  late AnimationController _textController;
  late Animation<double> _textAnimation;

  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    // ICON animation
    _iconController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 20000));
    _iconAnimation =
        CurvedAnimation(parent: _iconController, curve: Curves.elasticOut);
    _iconController.forward();

    // TEXT animation
    _textController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _textAnimation =
        CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    Future.delayed(Duration(milliseconds: 400), () {
      _textController.forward();
    });

    // BUTTON animation
    _buttonController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _buttonAnimation =
        CurvedAnimation(parent: _buttonController, curve: Curves.easeIn);
    Future.delayed(Duration(milliseconds: 1000), () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade600, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ICON with scale animation
              ScaleTransition(
                scale: _iconAnimation,
                child: Icon(Icons.shopping_bag, size: 120, color: Colors.white),
              ),

              SizedBox(height: 16),

              // TITLE with fade-in
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  'Aurora',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 8),

              // SUBTITLE with fade-in
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  'Shop anywhere globally',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ),

              SizedBox(height: 40),

              // BUTTON with fade-in
              FadeTransition(
                opacity: _buttonAnimation,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding:
                    EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
                  },
                  child: Text(
                    "Start",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
