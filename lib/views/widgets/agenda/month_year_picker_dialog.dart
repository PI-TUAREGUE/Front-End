import 'package:flutter/material.dart';

class MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final List<String> monthNames;

  const MonthYearPickerDialog({
    super.key,
    required this.initialDate,
    required this.monthNames,
  });

  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Colors.white12),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => setState(() => _selectedYear--),
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  splashRadius: 20,
                ),
                Text(
                  '$_selectedYear',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedYear++),
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, index) {
                final monthNumber = index + 1;
                final isSelected = _selectedYear == widget.initialDate.year &&
                    monthNumber == widget.initialDate.month;

                return GestureDetector(
                  onTap: () {
                    final maxDays =
                        DateTime(_selectedYear, monthNumber + 1, 0).day;
                    final newDay = widget.initialDate.day > maxDays
                        ? maxDays
                        : widget.initialDate.day;
                    Navigator.of(context).pop(
                      DateTime(_selectedYear, monthNumber, newDay),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFF7A00)
                          : const Color(0xFF28282B),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      widget.monthNames[index],
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
