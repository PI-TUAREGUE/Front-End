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


  

  