import 'package:daytask/core/theme/app_theme.dart';
import 'package:daytask/core/theme/theme_cubit.dart';
import 'package:daytask/splash_screen/presentation/splash_screen.dart';
import 'package:daytask/auth_screen/bloc/auth_bloc.dart';
import 'package:daytask/auth_screen/repository/auth_repository.dart';
import 'package:daytask/auth_screen/presentation/login_screen.dart';
import 'package:daytask/dashboard_screen/bloc/task_bloc.dart';
import 'package:daytask/dashboard_screen/presentation/home_screen.dart';
import 'package:daytask/dashboard_screen/repository/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE-URL-LINK']!,
    anonKey: dotenv.env['SUPABASE-ANON-KEY']!,
  );

  final authRepository = AuthRepository();
  final taskRepository = TaskRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => AuthBloc(authRepository)..add(AuthCheckRequested()),
        ),
        BlocProvider(create: (_) => TaskBloc(taskRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isAuth = Supabase.instance.client.auth.currentSession != null;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: isAuth ? const HomeScreen() : const SplashScreen(),
          routes: {
            '/auth': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}
