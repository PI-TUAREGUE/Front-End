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
  final String? createdByName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const ServiceModel({
    required this.id,
    required this.name,
    required this.status,
    this.avatarUrl,
    this.createdByName,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    String? creatorName;
    if (json['creatorName'] is String && (json['creatorName'] as String).isNotEmpty) {
      creatorName = json['creatorName'] as String;
    } else if (json['createdBy'] is Map) {
      creatorName = (json['createdBy'] as Map)['name'] as String?;
    } else if (json['createdBy'] is String &&
        (json['createdBy'] as String).isNotEmpty &&
        !(json['createdBy'] as String).contains(RegExp(r'^[0-9a-fA-F]{24}$'))) {
      creatorName = json['createdBy'] as String;
    }

    return ServiceModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: ServiceStatus.fromString(json['status'] as String? ?? 'Ativo'),
      avatarUrl: json['avatarUrl'] as String?,
      createdByName: creatorName,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
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

  String get code {
    final cleanName = name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final prefix = cleanName.length >= 3
        ? cleanName.substring(0, 3).toUpperCase()
        : cleanName.toUpperCase().padRight(3, 'X');
    final year = (createdAt ?? DateTime.now()).year;
    final suffix = id.isNotEmpty ? id.substring(id.length > 4 ? id.length - 4 : 0).toUpperCase() : '1';
    return '$prefix-$year-$suffix';
  }

  ServiceModel copyWith({
    String? id,
    String? name,
    ServiceStatus? status,
    String? avatarUrl,
    String? createdByName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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