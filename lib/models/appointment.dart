import 'employee.dart';
import 'service.dart';

enum SchedulingStatus {
  scheduled('Agendado'),
  late('Atrasado'),
  finished('Concluído'),
  canceled('Cancelado'),
  wik('Em progresso');

  final String label;
  const SchedulingStatus(this.label);

  static SchedulingStatus fromString(String value) {
    return SchedulingStatus.values.firstWhere(
      (status) => status.label.toLowerCase() == value.toLowerCase(),
      orElse: () => SchedulingStatus.scheduled,
    );
  }
}

class Appointment {
  final String id;
  final String client;
  final String clientTel;
  final String plate;
  final String car;
  final DateTime startDate;
  final DateTime? endDate;
  final SchedulingStatus status;
  final List<Employee> employee;
  final List<ServiceModel> service;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Appointment({
    required this.id,
    required this.client,
    required this.clientTel,
    required this.plate,
    required this.car,
    required this.startDate,
    required this.status,
    required this.employee,
    required this.service,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedTime =>
      '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}';

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      client: json['client'] as String? ?? '',
      clientTel: json['clientTel'] as String? ?? '',
      plate: json['plate'] as String? ?? '',
      car: json['car'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      status: SchedulingStatus.fromString(
        json['status'] as String? ?? 'Agendado',
      ),
      employee: (json['employee'] as List<dynamic>?)
              ?.map((item) {
                if (item is Map<String, dynamic>) {
                  return Employee.fromJson(item);
                }
                return Employee(
                  id: item.toString(),
                  name: 'Mecânico',
                  cpf: '',
                  email: '',
                  roles: [EmployeeRole.mechanic],
                  status: EmployeeStatus.active,
                );
              })
              .toList() ??
          [],
      service: (json['service'] as List<dynamic>?)
              ?.map((item) {
                if (item is Map<String, dynamic>) {
                  return ServiceModel.fromJson(item);
                }
                return ServiceModel(
                  id: item.toString(),
                  name: 'Serviço',
                  status: ServiceStatus.active,
                );
              })
              .toList() ??
          [],
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
      'client': client,
      'clientTel': clientTel,
      'plate': plate,
      'car': car,
      'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      'status': status.label,
      'employee': employee.map((e) => e.id).toList(),
      'service': service.map((s) => s.id).toList(),
    };
  }
}