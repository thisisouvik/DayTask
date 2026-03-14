enum TaskStatus { ongoing, completed }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final int progress; 
  final TaskStatus status;
  final String userId;
  final List<SubTask> subTasks;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.progress,
    required this.status,
    required this.userId,
    this.subTasks = const [],
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      dueDate: DateTime.parse(json['due_date'] as String),
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      status: (json['status'] as String?) == 'completed'
          ? TaskStatus.completed
          : TaskStatus.ongoing,
      userId: json['user_id'] as String,
      subTasks: (json['sub_tasks'] as List<dynamic>?)
              ?.map((e) => SubTask.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'due_date': dueDate.toIso8601String(),
        'progress': progress,
        'status': status == TaskStatus.completed ? 'completed' : 'ongoing',
        'user_id': userId,
        'sub_tasks': subTasks.map((s) => s.toJson()).toList(),
      };
}

class SubTask {
  final String id;
  final String title;
  final bool isCompleted;

  const SubTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'] as String? ?? '',
      title: json['title'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'is_completed': isCompleted,
      };

  SubTask copyWith({bool? isCompleted}) => SubTask(
        id: id,
        title: title,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}
