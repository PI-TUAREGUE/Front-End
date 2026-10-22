import 'package:front_end/models/appointment.dart';
import 'package:front_end/models/employee.dart';

final List<Appointment> appointmentsMock = [
  Appointment(
    serviceTitle: 'Troca de óleo e filtro',
    clientName: 'Guilherme Briggs',
    vehicleModel: 'Hyundai Creta 2.0',
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
    serviceTitle: 'Revisão do sistema de freios',
    clientName: 'Fernanda Montenegro',
    vehicleModel: 'Honda Civic G10',
    dateTime: DateTime(2026, 12, 14, 8, 30),
    mechanics: const [
      Employee(name: 'Wendel Bezerra', avatarUrl: 'https://i.pravatar.cc/150?img=33'),
      Employee(name: 'Marcio Seixas', avatarUrl: 'https://i.pravatar.cc/150?img=32'),
    ],
  ),
  Appointment(
    serviceTitle: 'Alinhamento e balanceamento',
    clientName: 'Lucas Silva',
    vehicleModel: 'Toyota Corolla Cross',
    dateTime: DateTime(2026, 12, 14, 9, 0),
    mechanics: const [
      Employee(name: 'Mauro Ramos', avatarUrl: 'https://i.pravatar.cc/150?img=60'),
    ],
  ),
  Appointment(
    serviceTitle: 'Troca de correia dentada',
    clientName: 'Juliana Paes',
    vehicleModel: 'Jeep Compass Longitude',
    dateTime: DateTime(2026, 12, 14, 9, 45),
    mechanics: const [
      Employee(name: 'Alexandre Moreno', avatarUrl: 'https://i.pravatar.cc/150?img=59'),
      Employee(name: 'Philippe Maia', avatarUrl: 'https://i.pravatar.cc/150?img=58'),
      Employee(name: 'Guilherme Lopes', avatarUrl: 'https://i.pravatar.cc/150?img=57'),
      Employee(name: 'Ricardo Juarez', avatarUrl: 'https://i.pravatar.cc/150?img=56'),
      Employee(name: 'Jorge Vasconcellos'),
      Employee(name: 'Manolo Rey'),
    ],
  ),
  Appointment(
    serviceTitle: 'Higienização e recarga de A/C',
    clientName: 'Rodrigo Hilbert',
    vehicleModel: 'Volkswagen Polo GTS',
    dateTime: DateTime(2026, 12, 14, 10, 15),
    mechanics: const [
      Employee(name: 'Wendel Bezerra', avatarUrl: 'https://i.pravatar.cc/150?img=11'),
      Employee(name: 'Alexandre Moreno', avatarUrl: 'https://i.pravatar.cc/150?img=59'),
      Employee(name: 'Mauro Ramos', avatarUrl: 'https://i.pravatar.cc/150?img=60'),
    ],
  ),
  Appointment(
    serviceTitle: 'Diagnóstico de injeção eletrônica',
    clientName: 'Camila Pitanga',
    vehicleModel: 'Chevrolet Onix Plus Turbo',
    dateTime: DateTime(2026, 12, 14, 11, 0),
    mechanics: const [
      Employee(name: 'Carlos Seidl'),
    ],
  ),
  Appointment(
    serviceTitle: 'Retífica de cabeçote',
    clientName: 'Wagner Moura',
    vehicleModel: 'Ford Ranger 3.2 4x4',
    dateTime: DateTime(2026, 12, 14, 14, 0),
    mechanics: const [
      Employee(name: 'Marcio Seixas', avatarUrl: 'https://i.pravatar.cc/150?img=12'),
      Employee(name: 'Guilherme Lopes', avatarUrl: 'https://i.pravatar.cc/150?img=57'),
      Employee(name: 'Philippe Maia', avatarUrl: 'https://i.pravatar.cc/150?img=58'),
      Employee(name: 'Nelson Machado'),
    ],
  ),
  Appointment(
    serviceTitle: 'Troca de pastilhas e discos',
    clientName: 'Ana Maria Braga',
    vehicleModel: 'Fiat Toro Volcano',
    dateTime: DateTime(2026, 12, 14, 15, 30),
    mechanics: const [],
  ),
  Appointment(
    serviceTitle: 'Troca de amortecedores dianteiros',
    clientName: 'Selton Mello',
    vehicleModel: 'Renault Duster 1.6',
    dateTime: DateTime(2026, 12, 14, 16, 0),
    mechanics: const [
      Employee(name: 'Wendel Bezerra', avatarUrl: 'https://i.pravatar.cc/150?img=33'),
      Employee(name: 'Alexandre Moreno', avatarUrl: 'https://i.pravatar.cc/150?img=59'),
    ],
  ),
  Appointment(
    serviceTitle: 'Revisão preventiva dos 30.000 km',
    clientName: 'Lázaro Ramos',
    vehicleModel: 'BMW 320i M Sport',
    dateTime: DateTime(2026, 12, 14, 17, 15),
    mechanics: const [
      Employee(name: 'Marcio Seixas', avatarUrl: 'https://i.pravatar.cc/150?img=32'),
      Employee(name: 'Mauro Ramos', avatarUrl: 'https://i.pravatar.cc/150?img=13'),
    ],
  ),
];