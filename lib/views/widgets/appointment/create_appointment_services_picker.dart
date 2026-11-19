import 'package:flutter/material.dart';
import '../../../models/service.dart';
import '../../../viewmodels/service_viewmodel.dart';

class CreateAppointmentServicesPicker extends StatelessWidget {
  final ServiceViewModel serviceViewModel;
  final List<String> selectedServiceIds;
  final ValueChanged<String> onServiceToggled;

  const CreateAppointmentServicesPicker({
    super.key,
    required this.serviceViewModel,
    required this.selectedServiceIds,
    required this.onServiceToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          listenable: serviceViewModel,
          builder: (context, _) {
            if (serviceViewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF7A00)),
              );
            }

            final services = serviceViewModel.services
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
                final isSelected = selectedServiceIds.contains(s.id);
                return FilterChip(
                  selected: isSelected,
                  label: Text(s.name),
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
                  onSelected: (_) => onServiceToggled(s.id),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
