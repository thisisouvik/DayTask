import 'package:daytask/dashboard_screen/models/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskRepository {
  final _supabase = Supabase.instance.client;

  Stream<List<TaskModel>> watchTasks() {
    final userId = _supabase.auth.currentUser?.id;
    return _supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId ?? '')
        .order('created_at', ascending: false)
        .map((rows) => rows.map((row) => TaskModel.fromJson(row)).toList());
  }

  Future<List<TaskModel>> fetchTasks() async {
    final userId = _supabase.auth.currentUser?.id;
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId ?? '')
        .order('created_at', ascending: false);
    return response.map<TaskModel>((row) => TaskModel.fromJson(row)).toList();
  }

  Future<void> createTask(TaskModel task) async {
    await _supabase.from('tasks').insert(task.toJson());
  }

  Future<void> updateTask(String id, Map<String, dynamic> updates) async {
    await _supabase.from('tasks').update(updates).eq('id', id);
  }

  Future<void> deleteTask(String id) async {
    await _supabase.from('tasks').delete().eq('id', id);
  }
}
