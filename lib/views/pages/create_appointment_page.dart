import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../models/employee.dart';
import '../../models/service.dart';
import '../../viewmodels/appointment_viewmodel.dart';
import '../../viewmodels/employee_viewmodel.dart';
import '../../viewmodels/service_viewmodel.dart';
import '../widgets/appointment/create_appointment_date_time_picker.dart';
import '../widgets/appointment/create_appointment_employee_picker.dart';
import '../widgets/appointment/create_appointment_services_picker.dart';
import '../widgets/auth/auth_button.dart';
import '../widgets/auth/auth_text_field.dart';

class CreateAppointmentPage extends StatefulWidget {
  final DateTime? initialDate;

  const CreateAppointmentPage({super.key, this.initialDate});

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  final _clientController = TextEditingController();
  final _clientTelController = TextEditingController();
  final _plateController = TextEditingController();
  final _carController = TextEditingController();

  late final AppointmentViewModel _appointmentViewModel;
  late final ServiceViewModel _serviceViewModel;
  late final EmployeeViewModel _employeeViewModel;

  String? _currentUserId;
  late DateTime _selectedDate;
  TimeOfDay _selectedStartTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _selectedEndTime = const TimeOfDay(hour: 10, minute: 0);

  final List<String> _selectedServiceIds = [];
  final List<String> _selectedInvitedEmployeeIds = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _appointmentViewModel = AppointmentViewModel();
    _serviceViewModel = ServiceViewModel();
    _employeeViewModel = EmployeeViewModel();

    AuthRepository().getCurrentUserId().then((id) {
      if (mounted) setState(() => _currentUserId = id);
    });

    _serviceViewModel.loadServices(status: ServiceStatus.active);
    _employeeViewModel.loadEmployees(status: EmployeeStatus.active);
  }

  @override
  void dispose() {
    _clientController.dispose();
    _clientTelController.dispose();
    _plateController.dispose();
    _carController.dispose();
    _appointmentViewModel.dispose();
    _serviceViewModel.dispose();
    _employeeViewModel.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF7A00),
      ),
    );
  }

  void _toggleService(String serviceId) {
    setState(() {
      if (_selectedServiceIds.contains(serviceId)) {
        _selectedServiceIds.remove(serviceId);
      } else {
        _selectedServiceIds.add(serviceId);
      }
    });
  }

  void _toggleEmployee(String employeeId) {
    setState(() {
      if (_selectedInvitedEmployeeIds.contains(employeeId)) {
        _selectedInvitedEmployeeIds.remove(employeeId);
      } else {
        _selectedInvitedEmployeeIds.add(employeeId);
      }
    });
  }

  Future<void> _handleSave() async {
    final client = _clientController.text.trim();
    final clientTel = _clientTelController.text.trim();
    final plate = _plateController.text.trim().toUpperCase();
    final car = _carController.text.trim();

    if (client.isEmpty || clientTel.isEmpty || plate.isEmpty || car.isEmpty) {
      _showMessage('Preencha todos os campos do cliente e do veículo.');
      return;
    }

    if (_selectedServiceIds.isEmpty) {
      _showMessage('Selecione ao menos um serviço.');
      return;
    }

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedStartTime.hour,
      _selectedStartTime.minute,
    );

    final endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedEndTime.hour,
      _selectedEndTime.minute,
    );

    final success = await _appointmentViewModel.createAppointment(
      client: client,
      clientTel: clientTel,
      plate: plate,
      car: car,
      startDate: startDateTime,
      endDate: endDateTime,
      serviceIds: _selectedServiceIds,
      employeeIds: _currentUserId != null ? [_currentUserId!] : [],
      invitedEmployeeIds: _selectedInvitedEmployeeIds.isNotEmpty
          ? _selectedInvitedEmployeeIds
          : null,
    );

    if (success && mounted) {
      Navigator.pop(context, true);
    } else if (mounted && _appointmentViewModel.errorMessage != null) {
      _showMessage(_appointmentViewModel.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Novo Agendamento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              label: 'Nome do Cliente',
              hint: 'Ex: Carlos Silva',
              icon: Icons.person_outline,
              controller: _clientController,
            ),
            const SizedBox(height: 18),
            AuthTextField(
              label: 'Telefone do Cliente',
              hint: 'Ex: (11) 98765-4321',
              icon: Icons.phone_outlined,
              controller: _clientTelController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 18),
            AuthTextField(
              label: 'Modelo do Veículo',
              hint: 'Ex: Honda Civic',
              icon: Icons.directions_car_outlined,
              controller: _carController,
            ),
            const SizedBox(height: 18),
            AuthTextField(
              label: 'Placa do Veículo',
              hint: 'Ex: ABC-1D23',
              icon: Icons.pin_outlined,
              controller: _plateController,
            ),
            const SizedBox(height: 24),
            CreateAppointmentDateTimePicker(
              selectedDate: _selectedDate,
              selectedStartTime: _selectedStartTime,
              selectedEndTime: _selectedEndTime,
              onDateChanged: (date) => setState(() => _selectedDate = date),
              onStartTimeChanged: (time) =>
                  setState(() => _selectedStartTime = time),
              onEndTimeChanged: (time) =>
                  setState(() => _selectedEndTime = time),
            ),
            const SizedBox(height: 24),
            CreateAppointmentServicesPicker(
              serviceViewModel: _serviceViewModel,
              selectedServiceIds: _selectedServiceIds,
              onServiceToggled: _toggleService,
            ),
            const SizedBox(height: 24),
            CreateAppointmentEmployeePicker(
              employeeViewModel: _employeeViewModel,
              currentUserId: _currentUserId,
              selectedInvitedEmployeeIds: _selectedInvitedEmployeeIds,
              onEmployeeToggled: _toggleEmployee,
            ),
            const SizedBox(height: 32),
            ListenableBuilder(
              listenable: _appointmentViewModel,
              builder: (context, _) {
                return AuthButton(
                  text: 'Confirmar Agendamento',
                  isLoading: _appointmentViewModel.isLoading,
                  onPressed: _handleSave,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
