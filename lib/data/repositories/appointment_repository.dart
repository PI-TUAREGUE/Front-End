import '../../models/appointment.dart';
import '../services/appointment_service.dart';

class AppointmentRepository {
  final AppointmentService _appointmentService = AppointmentService();

  Future<List<Appointment>> getAppointments({
    SchedulingStatus? status,
    DateTime? startDate,
    String? client,
    String? car,
    String? plate,
  }) async {
    return await _appointmentService.findAll(
      status: status,
      startDate: startDate,
      client: client,
      car: car,
      plate: plate,
    );
  }

  Future<Appointment> getAppointmentById(String id) async {
    return await _appointmentService.findById(id);
  }

  Future<Appointment> createAppointment({
    required String client,
    required String clientTel,
    required String plate,
    required String car,
    required DateTime startDate,
    required List<String> employeeIds,
    required List<String> serviceIds,
    DateTime? endDate,
    List<String>? invitedEmployeeIds,
  }) async {
    return await _appointmentService.create(
      client: client,
      clientTel: clientTel,
      plate: plate,
      car: car,
      startDate: startDate,
      employeeIds: employeeIds,
      serviceIds: serviceIds,
      endDate: endDate,
      invitedEmployeeIds: invitedEmployeeIds,
    );
  }

  Future<Appointment> updateAppointmentStatus({
    required String id,
    required SchedulingStatus status,
  }) async {
    return await _appointmentService.updateStatus(id, status);
  }

  Map<int, List<Appointment>> groupAppointmentsByHour(List<Appointment> appointments) {
    final Map<int, List<Appointment>> grouped = {};
    for (var item in appointments) {
      final hour = item.startDate.hour;
      grouped.putIfAbsent(hour, () => []).add(item);
    }
    return grouped;
  }

  Future<List<int>> getAppointmentReceipt(String id) async {
    return await _appointmentService.getReceipt(id);
  }
}