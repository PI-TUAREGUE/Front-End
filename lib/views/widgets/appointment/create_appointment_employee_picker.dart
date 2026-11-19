import 'package:flutter/material.dart';
import '../../../models/employee.dart';
import '../../../viewmodels/employee_viewmodel.dart';

class CreateAppointmentEmployeePicker extends StatelessWidget {
  final EmployeeViewModel employeeViewModel;
  final String? currentUserId;
  final List<String> selectedInvitedEmployeeIds;
  final ValueChanged<String> onEmployeeToggled;

  const CreateAppointmentEmployeePicker({
    super.key,
    required this.employeeViewModel,
    required this.currentUserId,
    required this.selectedInvitedEmployeeIds,
    required this.onEmployeeToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          listenable: employeeViewModel,
          builder: (context, _) {
            if (employeeViewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF7A00)),
              );
            }

            final employees = employeeViewModel.employees
                .where((e) =>
                    e.id != currentUserId &&
                    e.status == EmployeeStatus.active)
                .toList();

            if (employees.isEmpty) {
              return const Text(
                'Nenhum outro mecânico ativo disponível para convidar.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              );
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: employees.map((e) {
                final isSelected = selectedInvitedEmployeeIds.contains(e.id);
                return FilterChip(
                  selected: isSelected,
                  label: Text(e.name),
                  selectedColor: const Color(0xFFFF7A00),
                  backgroundColor: const Color(0xFF28282B),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (_) => onEmployeeToggled(e.id),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
