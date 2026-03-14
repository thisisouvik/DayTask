import 'package:daytask/common/button/app_button.dart';
import 'package:daytask/core/theme/app_colours.dart';
import 'package:daytask/core/theme/theme_cubit.dart';
import 'package:daytask/auth_screen/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    final user = _supabase.auth.currentUser;
    final displayName =
        user?.userMetadata?['full_Name'] ?? user?.userMetadata?['name'] ?? '';
    _nameController = TextEditingController(text: displayName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      try {
        await _supabase.auth.updateUser(
          UserAttributes(data: {'full_Name': newName}),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
        }
      }
    }
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF263238),
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '1. Acceptance of Terms\nBy accessing and using DayTask, you accept and agree to be bound by the terms and provision of this agreement.\n\n2. User Account\nYou must create an account and provide certain information about yourself in order to use some of the features that are offered.\n\n3. Privacy Policy\nYour use of DayTask is also subject to DayTask\'s Privacy Policy.\n\n4. Changes to Terms\nWe reserve the right to modify these terms at any time.',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDarkMode;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Edit User Details',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF455A64),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.save, color: AppColors.primary),
                    onPressed: _updateName,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF263238),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.dark_mode_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Dark Theme',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                      ),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                    const Divider(
                      color: Colors.white12,
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.description_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Terms and Conditions',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white54,
                        size: 16,
                      ),
                      onTap: _showTerms,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              BasicAppButton(
                text: 'Logout',
                onPressed: () {
                  context.read<AuthBloc>().add(AuthSighoutRequested());
                },
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
