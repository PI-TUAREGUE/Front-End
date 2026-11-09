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