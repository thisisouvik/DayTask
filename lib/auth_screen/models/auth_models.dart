class AuthModels {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final DateTime? createdAt;

  AuthModels({required this.id, required this.fullName, required this.email, this.avatarUrl, this.createdAt});


factory AuthModels.fromJSON(Map<String, dynamic> json) {
  return AuthModels(
    id: json['id'] as String,
    fullName: json['full_name'] as String,
    email: json['email'] as String,
    avatarUrl: json['avatar_url'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
Map<String, dynamic> toJson() {
    return {
      'id':         id,
      'full_name':  fullName,
      'email':      email,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory AuthModels.fromSupabaseUser(Map<String, dynamic> json) {
    return AuthModels(
      id:        json['id'] as String,
      fullName:  json['user_metadata']?['full_name'] as String? ?? '',
      email:     json['email'] as String? ?? '',
      avatarUrl: json['user_metadata']?['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  AuthModels copyWith({
    String? id,
    String? fullName,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return AuthModels(
      id:        id ?? this.id,
      fullName:  fullName ?? this.fullName,
      email:     email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'AuthModels(id: $id, fullName: $fullName, email: $email)';
  }
}
