import 'package:flutter/material.dart';

class FilterDropdownOption<T> {
  final T value;
  final String label;

  const FilterDropdownOption({
    required this.value,
    required this.label,
  });
}

class FilterDropdown<T> extends StatelessWidget {
  final String prefixText;
  final T selectedValue;
  final List<FilterDropdownOption<T>> options;
  final ValueChanged<T> onSelected;

  const FilterDropdown({
    super.key,
    this.prefixText = 'Filtrar por',
    required this.selectedValue,
    required this.options,
    required this.onSelected,
  });

  String get _currentLabel {
    final match = options.where((o) => o.value == selectedValue);
    if (match.isNotEmpty) return match.first.label;
    return options.isNotEmpty ? options.first.label : '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          prefixText,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<T>(
          initialValue: selectedValue,
          onSelected: onSelected,
          color: const Color(0xFF28282B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) {
            return options.map((opt) {
              final isCurrent = selectedValue == opt.value;
              return PopupMenuItem<T>(
                value: opt.value,
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
                  _currentLabel,
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
