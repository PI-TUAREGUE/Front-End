import '../../appointment.dart';
import '../mocks/appointment_mock.dart';

class AppointmentRepository {
  List<Appointment> getAppointments() {
    return appointmentsMock;
  }

  Map<int, List<Appointment>> getAppointmentsGroupedByHour() {
    final Map<int, List<Appointment>> grouped = {};
    for (var item in getAppointments()) {
      final hour = item.dateTime.hour;
      grouped.putIfAbsent(hour, () => []).add(item);
    }
    return grouped;
  }
}