import 'package:flutter/foundation.dart';
import '../data/repositories/appointment_repository.dart';
import '../models/appointment.dart';

enum AgendaFilter {
  forMe,
  all,
}

class AppointmentViewModel extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();

  List<Appointment> _appointments = [];
  Appointment? _selectedAppointment;
  DateTime _selectedDate = DateTime.now();
  AgendaFilter _filter = AgendaFilter.forMe;
  String? _currentUserId;
  bool _isLoading = false;
  String? _errorMessage;

  List<Appointment> get appointments => _appointments;
  Appointment? get selectedAppointment => _selectedAppointment;
  DateTime get selectedDate => _selectedDate;
  AgendaFilter get filter => _filter;
  String? get currentUserId => _currentUserId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setFilter(AgendaFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setCurrentUserId(String? id) {
    _currentUserId = id;
    notifyListeners();
  }

  List<Appointment> get filteredAppointments {
    if (_filter == AgendaFilter.all || _currentUserId == null) {
      return _appointments;
    }
    return _appointments
        .where((a) => a.employee.any((e) => e.id == _currentUserId))
        .toList();
  }

  Map<int, List<Appointment>> get groupedAppointments =>
      _repository.groupAppointmentsByHour(filteredAppointments);

  List<int> get hours {
    final list = groupedAppointments.keys.toList();
    list.sort();
    return list;
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    loadAppointments(startDate: date);
  }

  Future<void> loadAppointments({
    SchedulingStatus? status,
    DateTime? startDate,
    String? client,
    String? car,
    String? plate,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final date = startDate ?? _selectedDate;
      _appointments = await _repository.getAppointments(
        status: status,
        startDate: date,
        client: client,
        car: car,
        plate: plate,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadAppointmentById(String id) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedAppointment = await _repository.getAppointmentById(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createAppointment({
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
    _setLoading(true);
    _clearError();

    try {
      final created = await _repository.createAppointment(
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

      if (created.startDate.year == _selectedDate.year &&
          created.startDate.month == _selectedDate.month &&
          created.startDate.day == _selectedDate.day) {
        _appointments.add(created);
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateAppointmentStatus({
    required String id,
    required SchedulingStatus status,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updated = await _repository.updateAppointmentStatus(
        id: id,
        status: status,
      );
      _replaceAppointment(updated);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateStartDate({
    required String id,
    required DateTime startDate,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updated = await _repository.updateStartDate(
        id: id,
        startDate: startDate,
      );
      _replaceAppointment(updated);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateEndDate({
    required String id,
    required DateTime endDate,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updated = await _repository.updateEndDate(
        id: id,
        endDate: endDate,
      );
      _replaceAppointment(updated);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<int>?> downloadReceipt(String id) async {
    _setLoading(true);
    _clearError();

    try {
      return await _repository.getAppointmentReceipt(id);
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _replaceAppointment(Appointment updated) {
    final index = _appointments.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _appointments[index] = updated;
    }
    if (_selectedAppointment?.id == updated.id) {
      _selectedAppointment = updated;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}