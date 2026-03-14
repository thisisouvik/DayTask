import 'package:daytask/core/theme/app_colours.dart';
import 'package:daytask/dashboard_screen/bloc/task_bloc.dart';
import 'package:daytask/dashboard_screen/models/task_model.dart';
import 'package:daytask/common/widget/task_list_item.dart';
import 'package:daytask/dashboard_screen/presentation/edit_task_screen.dart';
import 'package:daytask/dashboard_screen/presentation/add_sub_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Task Details',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text(
                      'Are you sure you want to delete this task?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<TaskBloc>().add(DeleteTask(task.id));
                          Navigator.pop(dialogContext); // Close dialog
                          Navigator.pop(context); // Close TaskDetailsScreen
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_outline),
            color: Colors.redAccent,
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          TaskModel currentTask = task;
          if (state is TaskLoaded) {
            try {
              currentTask = state.tasks.firstWhere((t) => t.id == task.id);
            } catch (_) {}
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  currentTask.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    _InfoBox(
                      icon: Icons.calendar_month_outlined,
                      label: 'Due Date',
                      value: _formatDate(currentTask.dueDate),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Project Details
                const Text(
                  'Project Details',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  currentTask.description.isEmpty
                      ? 'No description provided.'
                      : currentTask.description,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'All Tasks',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),

                if (currentTask.subTasks.isEmpty)
                  const Text(
                    'No sub-tasks yet. Tap "Add Task" to add.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontFamily: 'Inter',
                    ),
                  ),

                ...List.generate(currentTask.subTasks.length, (index) {
                  final sub = currentTask.subTasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TaskListItem(
                      title: sub.title,
                      isCompleted: sub.isCompleted,
                      onToggle: (val) {
                        context.read<TaskBloc>().add(
                          ToggleSubTask(
                            taskId: currentTask.id,
                            subTaskIndex: index,
                            isCompleted: val,
                          ),
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final newStatus = task.status == TaskStatus.completed
                        ? 'ongoing'
                        : 'completed';
                    context.read<TaskBloc>().add(
                      UpdateTaskProgress(
                        taskId: task.id,
                        progress: newStatus == 'completed' ? 100 : 0,
                        status: newStatus,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    task.status == TaskStatus.completed
                        ? 'Mark Ongoing'
                        : 'Mark Completed',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddSubTaskScreen(taskId: task.id),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month]}';
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBox({required this.icon, required this.label, this.value = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
