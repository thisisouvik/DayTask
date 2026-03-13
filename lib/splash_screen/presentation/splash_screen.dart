import 'package:daytask/common/button/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daytask/auth_screen/bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthUnauthenticated || state is AuthLoggedOut) {
          Navigator.pushReplacementNamed(context, '/auth');
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child : SvgPicture.asset(
              'assets/images/logo/applogo.svg',
              semanticsLabel: 'App Logo',
            ),
          ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),

              Image(
                height: 300,
                image: AssetImage(
                  isDark
                      ? 'assets/images/splash_image/dark.png'
                      : 'assets/images/splash_image/light.png',
                ),
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'PilatExtended',
                      fontSize: 45,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      height: 1.2,
                    ),
                    children: const [
                      TextSpan(text: 'Manage your Task with '),
                      TextSpan(
                        text: 'DayTask',
                        style: TextStyle(
                          color: Color(0xFFFED36A), fontSize: 48, fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: BasicAppButton(
                    text: 'Get Started',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    height: 56,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}
