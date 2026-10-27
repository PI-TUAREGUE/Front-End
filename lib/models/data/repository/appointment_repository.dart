import 'package:shared_preferences/shared_preferences.dart';
import '../../appointment.dart';
import '../mocks/appointment_mock.dart';

class AppointmentRepository {
  static const String _selectedTabKey = 'selected_tab';

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

  Future<void> saveSelectedTab(int tabIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedTabKey, tabIndex);
  }

  Future<int> getSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedTabKey) ?? 0;
  }
}
