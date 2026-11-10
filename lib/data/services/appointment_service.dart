import '../../models/appointment.dart';
import '../network/requester.dart';

class AppointmentService {
  final Requester _requester = Requester();

  Future<List<Appointment>> findAll({
    SchedulingStatus? status,
    DateTime? startDate,
    String? client,
    String? car,
    String? plate,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (status != null) {
      queryParameters['status'] = status.label;
    }
    if (startDate != null) {
      final year = startDate.year.toString().padLeft(4, '0');
      final month = startDate.month.toString().padLeft(2, '0');
      final day = startDate.day.toString().padLeft(2, '0');
      queryParameters['startDate'] = '$year-$month-$day';
    }
    if (client != null && client.isNotEmpty) {
      queryParameters['client'] = client;
    }
    if (car != null && car.isNotEmpty) {
      queryParameters['car'] = car;
    }
    if (plate != null && plate.isNotEmpty) {
      queryParameters['plate'] = plate;
    }

    final response = await _requester.get(
      '/schedulings',
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    if (response is List) {
      return response
          .map((item) => Appointment.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Appointment> findById(String id) async {
    final response = await _requester.get('/schedulings/$id');
    return Appointment.fromJson(response as Map<String, dynamic>);
  }

  Future<Appointment> create({
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
    final body = <String, dynamic>{
      'client': client,
      'clientTel': clientTel,
      'plate': plate,
      'car': car,
      'startDate': startDate.toIso8601String(),
      'employee': employeeIds,
      'service': serviceIds,
    };

    if (endDate != null) {
      body['endDate'] = endDate.toIso8601String();
    }
    if (invitedEmployeeIds != null && invitedEmployeeIds.isNotEmpty) {
      body['invitedEmployees'] = invitedEmployeeIds;
    }

    final response = await _requester.post('/schedulings', body: body);
    return Appointment.fromJson(response as Map<String, dynamic>);
  }

  Future<Appointment> updateStatus(String id, SchedulingStatus status) async {
    final body = {
      'status': status.label,
    };

    final response = await _requester.patch('/schedulings/$id/status', body: body);
    return Appointment.fromJson(response as Map<String, dynamic>);
  }

  Future<List<int>> getReceipt(String id) async {
    return await _requester.getBytes('/schedulings/$id/receipt');
  }
}