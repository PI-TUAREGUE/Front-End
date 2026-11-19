import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../models/service.dart';
import '../../viewmodels/appointment_viewmodel.dart';
import '../../viewmodels/employee_viewmodel.dart';
import '../../viewmodels/service_viewmodel.dart';
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
    _employeeViewModel.loadEmployees();
  }

  @override
  void dispose() {
    _clientController.dispose();
    _clientTelController.dispose();
    _plateController.dispose();
    _carController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF7A00),
              surface: Color(0xFF1E1E22),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF7A00),
              surface: Color(0xFF1E1E22),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedStartTime = picked);
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF7A00),
              surface: Color(0xFF1E1E22),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedEndTime = picked);
    }
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFF7A00),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141416),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFFFF7A00), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Realizar Agendamento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthTextField(
              label: 'Nome do Cliente',
              hint: 'Ex: João Souza',
              icon: Icons.person_outline,
              controller: _clientController,
            ),
            const SizedBox(height: 18),
            AuthTextField(
              label: 'Telefone do Cliente',
              hint: 'Ex: 11999998888',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              controller: _clientTelController,
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
            const Text(
              'Data do Agendamento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F0F),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFFFF7A00),
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.edit_calendar_outlined,
                      color: Colors.white38,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Início',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickStartTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F0F0F),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Color(0xFFFF7A00),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedStartTime.hour.toString().padLeft(2, '0')}:${_selectedStartTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Término',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickEndTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F0F0F),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time_filled,
                                color: Colors.white54,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedEndTime.hour.toString().padLeft(2, '0')}:${_selectedEndTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Serviços',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ListenableBuilder(
              listenable: _serviceViewModel,
              builder: (context, _) {
                if (_serviceViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A00)));
                }
                final services = _serviceViewModel.services
                    .where((s) => s.status == ServiceStatus.active)
                    .toList();
                if (services.isEmpty) {
                  return const Text(
                    'Nenhum serviço ativo disponível no momento.',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: services.map((s) {
                    final isSelected = _selectedServiceIds.contains(s.id);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(s.name),
                      selectedColor: const Color(0xFFFF7A00),
                      backgroundColor: const Color(0xFF28282B),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedServiceIds.add(s.id);
                          } else {
                            _selectedServiceIds.remove(s.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Convidar outros mecânicos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ListenableBuilder(
              listenable: _employeeViewModel,
              builder: (context, _) {
                if (_employeeViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A00)));
                }
                final employees = _employeeViewModel.employees
                    .where((e) => e.id != _currentUserId)
                    .toList();
                if (employees.isEmpty) {
                  return const Text(
                    'Nenhum outro mecânico disponível para convidar.',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: employees.map((e) {
                    final isSelected = _selectedInvitedEmployeeIds.contains(e.id);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(e.name),
                      selectedColor: const Color(0xFFFF7A00),
                      backgroundColor: const Color(0xFF28282B),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedInvitedEmployeeIds.add(e.id);
                          } else {
                            _selectedInvitedEmployeeIds.remove(e.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
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
          ],
        ),
      ),
    );
  }
}
