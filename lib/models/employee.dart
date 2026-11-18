enum EmployeeRole {
  admin('Administrador'),
  mechanic('Mecânico');

  final String label;
  const EmployeeRole(this.label);

  static EmployeeRole fromString(String value) {
    return EmployeeRole.values.firstWhere(
      (role) => role.label.toLowerCase() == value.toLowerCase(),
      orElse: () => EmployeeRole.mechanic,
    );
  }
}

enum EmployeeStatus {
  active('Ativo'),
  inactive('Inativo');

  final String label;
  const EmployeeStatus(this.label);

  static EmployeeStatus fromString(String value) {
    return EmployeeStatus.values.firstWhere(
      (status) => status.label.toLowerCase() == value.toLowerCase(),
      orElse: () => EmployeeStatus.active,
    );
  }
}

class Employee {
  final String id;
  final String name;
  final String cpf;
  final String email;
  final List<EmployeeRole> roles;
  final EmployeeStatus status;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Employee({
    required this.id,
    required this.name,
    required this.cpf,
    required this.email,
    required this.roles,
    required this.status,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  String get rolesFormatted => roles.map((r) => r.label).join(', ');

  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    if (avatarUrl!.startsWith('http://') || avatarUrl!.startsWith('https://')) {
      return avatarUrl;
    }
    final cleanPath = avatarUrl!.replaceAll(r'\', '/');
    final formattedPath =
        cleanPath.startsWith('/') ? cleanPath.substring(1) : cleanPath;
    return 'http://localhost:3000/$formattedPath';
  }

  String get formattedCpf {
    final clean = cpf.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 11) {
      return '${clean.substring(0, 3)}.${clean.substring(3, 6)}.${clean.substring(6, 9)}-${clean.substring(9)}';
    }
    return cpf;
  }

  String get formattedCreatedAt {
    final date = createdAt?.toLocal() ?? DateTime.now();
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    return '$d/$m/$y';
  }

  String get formattedUpdatedAt {
    final date = (updatedAt ?? createdAt)?.toLocal() ?? DateTime.now();
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    return '$d/$m/$y';
  }

  String get rolesDisplay {
    return roles.map((r) {
      if (r == EmployeeRole.admin) return 'Admin';
      return r.label;
    }).join(', ');
  }

  Employee copyWith({
    String? id,
    String? name,
    String? cpf,
    String? email,
    List<EmployeeRole>? roles,
    EmployeeStatus? status,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      cpf: json['cpf'] as String? ?? '',
      email: json['email'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((item) => EmployeeRole.fromString(item.toString()))
              .toList() ??
          [EmployeeRole.mechanic],
      status: EmployeeStatus.fromString(json['status'] as String? ?? 'Ativo'),
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cpf': cpf,
      'email': email,
      'roles': roles.map((r) => r.label).toList(),
      'status': status.label,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }
}