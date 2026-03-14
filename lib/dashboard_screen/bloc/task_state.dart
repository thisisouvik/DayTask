part of 'task_bloc.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  TaskLoaded(this.tasks);

  List<TaskModel> get completedTasks =>
      tasks.where((t) => t.status == TaskStatus.completed).toList();

  List<TaskModel> get ongoingTasks =>
      tasks.where((t) => t.status == TaskStatus.ongoing).toList();
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
