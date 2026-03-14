import 'package:flutter/material.dart';
import 'package:daytask/dashboard_screen/models/task_model.dart';

class CompletedTaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const CompletedTaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isFirst = task.status == TaskStatus.completed;
    final cardColor = isFirst ? const Color(0xFFFED36A) : const Color(0xFF455A64);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isFirst ? Colors.black : Colors.white,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: isFirst ? Colors.black54 : Colors.white70,
                  ),
                ),
                Text(
                  '${task.progress}%',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isFirst ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: task.progress / 100,
                backgroundColor: isFirst ? Colors.black26 : Colors.white24,
                color: isFirst ? Colors.black : const Color(0xFFFED36A),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
