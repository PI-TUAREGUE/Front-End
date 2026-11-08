enum ServiceStatus {
  active('Ativo'),
  inactive('Inativo');

  final String label;
  const ServiceStatus(this.label);

  static ServiceStatus fromString(String value) {
    return ServiceStatus.values.firstWhere(
      (status) => status.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ServiceStatus.active,
    );
  }
}

class ServiceModel {
  final String id;
  final String name;
  final ServiceStatus status;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const ServiceModel({
    required this.id,
    required this.name,
    required this.status,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: ServiceStatus.fromString(json['status'] as String? ?? 'Ativo'),
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
      'status': status.label,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }
}