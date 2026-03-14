part of 'task_bloc.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class TasksUpdated extends TaskEvent {
  final List<dynamic> tasks;
  TasksUpdated(this.tasks);
}

class AddTask extends TaskEvent {
  final String title;
  final String description;
  final DateTime dueDate;
  AddTask({
    required this.title,
    required this.description,
    required this.dueDate,
  });
}

class UpdateTaskProgress extends TaskEvent {
  final String taskId;
  final int progress;
  final String status;
  UpdateTaskProgress({
    required this.taskId,
    required this.progress,
    required this.status,
  });
}

class ToggleSubTask extends TaskEvent {
  final String taskId;
  final int subTaskIndex;
  final bool isCompleted;
  ToggleSubTask({
    required this.taskId,
    required this.subTaskIndex,
    required this.isCompleted,
  });
}

class AddSubTask extends TaskEvent {
  final String taskId;
  final String subTaskTitle;
  AddSubTask({required this.taskId, required this.subTaskTitle});
}

class UpdateTask extends TaskEvent {
  final String taskId;
  final String title;
  final String description;
  final DateTime dueDate;
  UpdateTask({
    required this.taskId,
    required this.title,
    required this.description,
    required this.dueDate,
  });
}

class DeleteTask extends TaskEvent {
  final String taskId;
  DeleteTask(this.taskId);
}
