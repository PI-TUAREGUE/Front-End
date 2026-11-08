import 'package:front_end/models/appointment.dart';
import 'package:front_end/models/employee.dart';
import 'package:front_end/models/service.dart';

final List<Appointment> appointmentsMock = [
  Appointment(
    id: 'mock_1',
    client: 'Guilherme Briggs',
    clientTel: '(11) 98765-4321',
    plate: 'BRA-2E19',
    car: 'Hyundai Creta 2.0',
    startDate: DateTime(2026, 12, 14, 8, 0),
    status: SchedulingStatus.wik,
    service: const [
      ServiceModel(
        id: 'srv_1',
        name: 'Troca de óleo e filtro',
        status: ServiceStatus.active,
      ),
    ],
    employee: const [
      Employee(
        id: 'emp_1',
        name: 'Wendel Bezerra',
        cpf: '123.456.789-00',
        email: 'wendel@tuaregue.com',
        roles: [EmployeeRole.mechanic],
        status: EmployeeStatus.active,
        avatarUrl: 'https://i.pravatar.cc/150?img=11',
      ),
      Employee(
        id: 'emp_2',
        name: 'Marcio Seixas',
        cpf: '234.567.890-11',
        email: 'marcio@tuaregue.com',
        roles: [EmployeeRole.mechanic],
        status: EmployeeStatus.active,
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
      ),
    ],
  ),
  Appointment(
    id: 'mock_2',
    client: 'Fernanda Montenegro',
    clientTel: '(11) 91234-5678',
    plate: 'RIO-4A20',
    car: 'Honda Civic G10',
    startDate: DateTime(2026, 12, 14, 8, 30),
    status: SchedulingStatus.scheduled,
    service: const [
      ServiceModel(
        id: 'srv_2',
        name: 'Revisão do sistema de freios',
        status: ServiceStatus.active,
      ),
    ],
    employee: const [
      Employee(
        id: 'emp_1',
        name: 'Wendel Bezerra',
        cpf: '123.456.789-00',
        email: 'wendel@tuaregue.com',
        roles: [EmployeeRole.mechanic],
        status: EmployeeStatus.active,
        avatarUrl: 'https://i.pravatar.cc/150?img=33',
      ),
    ],
  ),
  Appointment(
    id: 'mock_3',
    client: 'Lucas Silva',
    clientTel: '(11) 97777-8888',
    plate: 'SPX-9C11',
    car: 'Toyota Corolla Cross',
    startDate: DateTime(2026, 12, 14, 9, 0),
    status: SchedulingStatus.finished,
    service: const [
      ServiceModel(
        id: 'srv_3',
        name: 'Alinhamento e balanceamento',
        status: ServiceStatus.active,
      ),
    ],
    employee: const [
      Employee(
        id: 'emp_3',
        name: 'Mauro Ramos',
        cpf: '345.678.901-22',
        email: 'mauro@tuaregue.com',
        roles: [EmployeeRole.mechanic],
        status: EmployeeStatus.active,
        avatarUrl: 'https://i.pravatar.cc/150?img=60',
      ),
    ],
  ),
];
