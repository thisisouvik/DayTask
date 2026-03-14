import 'package:daytask/core/theme/app_colours.dart';
import 'package:daytask/dashboard_screen/bloc/task_bloc.dart';
import 'package:daytask/dashboard_screen/presentation/task_details_screen.dart';
import 'package:daytask/common/widget/completed_task_card.dart';
import 'package:daytask/common/widget/ongoing_task_card.dart';
import 'package:daytask/common/widget/section_header.dart';
import 'package:daytask/dashboard_screen/presentation/create_task_screen.dart';
import 'package:daytask/profile_screen/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final displayName =
        user?.userMetadata?['full_Name'] ??
        user?.userMetadata?['name'] ??
        'User';

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                context.read<TaskBloc>().add(LoadTasks());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Welcome Back!',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ProfileScreen(),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.primary,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF263238),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                SizedBox(width: 14),
                                Icon(
                                  Icons.search,
                                  color: Colors.white38,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search tasks',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.white38,
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Completed Tasks Section
                          SectionHeader(
                            title: 'Completed Tasks',
                            onSeeAll: () {},
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: _buildCompletedSection(state)),

                  // Ongoing Tasks Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
                      child: SectionHeader(
                        title: 'Ongoing Tasks',
                        onSeeAll: () {},
                      ),
                    ),
                  ),

                  // Ongoing Task Cards
                  _buildOngoingSection(state),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'New Task',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildCompletedSection(TaskState state) {
    if (state is TaskLoading || state is TaskInitial) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state is TaskError) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Error: ${state.message}',
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }
    if (state is TaskLoaded) {
      final completed = state.completedTasks;
      if (completed.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'No completed tasks yet.',
            style: TextStyle(color: Colors.white54),
          ),
        );
      }
      return SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: completed.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final task = completed[index];
            return CompletedTaskCard(
              task: task,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailsScreen(task: task),
                ),
              ),
            );
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildOngoingSection(TaskState state) {
    if (state is TaskLoaded) {
      final ongoing = state.ongoingTasks;
      if (ongoing.isEmpty) {
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'No ongoing tasks. Create one!',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final task = ongoing[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: OngoingTaskCard(
              task: task,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailsScreen(task: task),
                ),
              ),
            ),
          );
        }, childCount: ongoing.length),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
