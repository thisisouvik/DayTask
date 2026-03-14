import 'package:daytask/core/theme/app_theme.dart';
import 'package:daytask/core/theme/theme_cubit.dart';
import 'package:daytask/splash_screen/presentation/splash_screen.dart';
import 'package:daytask/auth_screen/bloc/auth_bloc.dart';
import 'package:daytask/auth_screen/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepository = AuthRepository();

  await DotEnv().load();

  await Supabase.initialize(
    url: DotEnv().env['SUPABASE-URL-LINK']!,
    anonKey: DotEnv().env['SUPABASE-ANON-KEY']!
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => AuthBloc(authRepository)),
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
