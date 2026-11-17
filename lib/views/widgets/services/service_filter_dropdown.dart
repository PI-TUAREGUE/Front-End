import 'package:flutter/material.dart';

enum ServiceFilterOption {
  date('Data'),
  name('Nome (A-Z)'),
  active('Ativos'),
  inactive('Inativos');

  final String label;
  const ServiceFilterOption(this.label);
}

class ServiceFilterDropdown extends StatelessWidget {
  final ServiceFilterOption selectedFilter;
  final ValueChanged<ServiceFilterOption> onSelected;

  const ServiceFilterDropdown({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Filtrar por',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<ServiceFilterOption>(
          initialValue: selectedFilter,
          onSelected: onSelected,
          color: const Color(0xFF28282B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) {
            return ServiceFilterOption.values.map((opt) {
              final isCurrent = selectedFilter == opt;
              return PopupMenuItem(
                value: opt,
                child: Text(
                  opt.label,
                  style: TextStyle(
                    color: isCurrent ? const Color(0xFFFF7A00) : Colors.white,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white24,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedFilter.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
