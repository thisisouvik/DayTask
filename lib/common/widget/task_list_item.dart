import 'package:flutter/material.dart';
import 'package:daytask/core/theme/app_colours.dart';

/// Single task row in Task Details "All Tasks" list with checkbox
class TaskListItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final ValueChanged<bool>? onToggle;

  const TaskListItem({
    super.key,
    required this.title,
    required this.isCompleted,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF263238),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle != null ? () => onToggle!(!isCompleted) : null,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.primary : Colors.white54,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.black)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
