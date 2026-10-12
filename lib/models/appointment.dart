import 'package:front_end/models/employee.dart';

class Appointment {
  final String serviceTitle;
  final String clientName;
  final String vehicleModel;
  final DateTime dateTime; 
  final List<Employee> mechanics;

  const Appointment({
    required this.serviceTitle,
    required this.clientName,
    required this.vehicleModel,
    required this.dateTime,
    this.mechanics = const [],
  });

  String get formattedTime =>
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

final List<Appointment> appointmentsMock = [
  Appointment(
    serviceTitle: 'Troca de óleo',
    clientName: 'Guilherme Briggs',
    vehicleModel: 'Hyundai Creta',
    dateTime: DateTime(2026, 12, 14, 8, 0),
    mechanics: const [
      Employee(name: 'Wendel Bezerra', avatarUrl: 'https://i.pravatar.cc/150?img=11'),
      Employee(name: 'Marcio Seixas', avatarUrl: 'https://i.pravatar.cc/150?img=12'),
      Employee(name: 'Mauro Ramos', avatarUrl: 'https://i.pravatar.cc/150?img=13'),
      Employee(name: 'Carlos Seidl'),
      Employee(name: 'Nelson Machado'),
    ],
  ),
  Appointment(
    serviceTitle: 'Troca de motor',
    clientName: 'Guilherme Briggs',
    vehicleModel: 'Hyundai Creta',
    dateTime: DateTime(2026, 12, 14, 8, 0),
    mechanics: const [
      Employee(name: 'Wendel Bezerra', avatarUrl: 'https://i.pravatar.cc/150?img=33'),
      Employee(name: 'Marcio Seixas', avatarUrl: 'https://i.pravatar.cc/150?img=32'),
    ],
  ),
  Appointment(
    serviceTitle: 'Alinhamento',
    clientName: 'Lucas Silva',
    vehicleModel: 'Toyota Corolla',
    dateTime: DateTime(2026, 12, 14, 9, 0),
    mechanics: const [
      Employee(name: 'Mauro Ramos', avatarUrl: 'https://i.pravatar.cc/150?img=60'),
    ],
  ),
];

  