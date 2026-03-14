import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:daytask/dashboard_screen/models/task_model.dart';
import 'package:daytask/dashboard_screen/repository/task_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  StreamSubscription<List<TaskModel>>? _taskSubscription;

  TaskBloc(this.taskRepository) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<TasksUpdated>(_onTasksUpdated);
    on<AddTask>(_onAddTask);
    on<UpdateTaskProgress>(_onUpdateTaskProgress);
    on<ToggleSubTask>(_onToggleSubTask);
    on<AddSubTask>(_onAddSubTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) {
    emit(TaskLoading());
    _taskSubscription?.cancel();
    _taskSubscription = taskRepository.watchTasks().listen(
      (tasks) => add(TasksUpdated(tasks)),
      onError: (error) => emit(TaskError(error.toString())),
    );
  }

  void _onTasksUpdated(TasksUpdated event, Emitter<TaskState> emit) {
    final tasks = event.tasks as List<TaskModel>;
    emit(TaskLoaded(tasks));
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      final task = TaskModel(
        id: '',
        title: event.title,
        description: event.description,
        dueDate: event.dueDate,
        progress: 0,
        status: TaskStatus.ongoing,
        userId: userId,
      );
      await taskRepository.createTask(task);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTaskProgress(
    UpdateTaskProgress event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await taskRepository.updateTask(event.taskId, {
        'progress': event.progress,
        'status': event.status,
      });
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleSubTask(
    ToggleSubTask event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final current = state as TaskLoaded;
      final task = current.tasks.firstWhere((t) => t.id == event.taskId, orElse: () => throw Exception('Task not found'));
      final updated = List<SubTask>.from(task.subTasks);
      updated[event.subTaskIndex] =
          updated[event.subTaskIndex].copyWith(isCompleted: event.isCompleted);
      final completedCount = updated.where((s) => s.isCompleted).length;
      final progress = updated.isEmpty
          ? 0
          : ((completedCount / updated.length) * 100).round();
      final status = progress == 100 ? 'completed' : 'ongoing';
      await taskRepository.updateTask(event.taskId, {
        'sub_tasks': updated.map((s) => s.toJson()).toList(),
        'progress': progress,
        'status': status,
      });
    }
  }

  Future<void> _onAddSubTask(
    AddSubTask event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final current = state as TaskLoaded;
      try {
        final task = current.tasks.firstWhere((t) => t.id == event.taskId);
        final updated = List<SubTask>.from(task.subTasks);
        updated.add(SubTask(title: event.subTaskTitle, isCompleted: false, id: ''));
        
        final completedCount = updated.where((s) => s.isCompleted).length;
        final progress = updated.isEmpty
            ? 0
            : ((completedCount / updated.length) * 100).round();
        final status = progress == 100 ? 'completed' : 'ongoing';

        await taskRepository.updateTask(event.taskId, {
          'sub_tasks': updated.map((s) => s.toJson()).toList(),
          'progress': progress,
          'status': status,
        });
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await taskRepository.updateTask(event.taskId, {
        'title': event.title,
        'description': event.description,
        'due_date': event.dueDate.toIso8601String(),
      });
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.taskId);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
