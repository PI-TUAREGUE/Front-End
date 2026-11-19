import 'package:flutter/material.dart';

class AppointmentDatePickerHelper {
  static ThemeData get _theme {
    return ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF7A00),
        onPrimary: Colors.white,
        surface: Color(0xFF1E1E22),
        onSurface: Colors.white,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFF1E1E22),
      ),
    );
  }

  static Future<DateTime?> pickDateTime({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    required String dateHelpText,
    required String timeHelpText,
  }) async {
    final effectiveFirstDate = firstDate ?? DateTime(2020);
    final effectiveLastDate = lastDate ?? DateTime(2035);

    final safeInitialDate = initialDate.isBefore(effectiveFirstDate)
        ? effectiveFirstDate
        : (initialDate.isAfter(effectiveLastDate)
            ? effectiveLastDate
            : initialDate);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: effectiveFirstDate,
      lastDate: effectiveLastDate,
      helpText: dateHelpText,
      builder: (context, child) => Theme(
        data: _theme,
        child: child!,
      ),
    );

    if (pickedDate == null || !context.mounted) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      helpText: timeHelpText,
      builder: (context, child) => Theme(
        data: _theme,
        child: child!,
      ),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  static Future<({DateTime start, DateTime end})?> promptReschedule({
    required BuildContext context,
    required DateTime currentStartDate,
    DateTime? currentEndDate,
  }) async {
    final newStart = await pickDateTime(
      context: context,
      initialDate: currentStartDate,
      dateHelpText: 'SELECIONE A NOVA DATA DE INÍCIO',
      timeHelpText: 'SELECIONE O NOVO HORÁRIO DE INÍCIO',
    );

    if (newStart == null || !context.mounted) return null;

    final currentDuration = currentEndDate != null &&
            currentEndDate.isAfter(currentStartDate)
        ? currentEndDate.difference(currentStartDate)
        : const Duration(hours: 1);
    final defaultEndDate = newStart.add(currentDuration);

    final newEnd = await pickDateTime(
      context: context,
      initialDate: defaultEndDate,
      firstDate: newStart,
      dateHelpText: 'SELECIONE A NOVA DATA PREVISTA DE TÉRMINO',
      timeHelpText: 'SELECIONE O NOVO HORÁRIO PREVISTO DE TÉRMINO',
    );

    if (newEnd == null) return null;

    if (!newEnd.isAfter(newStart)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFDC2626),
            content:
                Text('A data prevista de término deve ser posterior ao início.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return null;
    }

    return (start: newStart, end: newEnd);
  }

  static Future<DateTime?> promptEndDate({
    required BuildContext context,
    required DateTime currentStartDate,
    DateTime? currentEndDate,
  }) async {
    final initialDate = currentEndDate ?? currentStartDate;
    final newEnd = await pickDateTime(
      context: context,
      initialDate: initialDate,
      firstDate: currentStartDate,
      dateHelpText: 'SELECIONE A NOVA DATA PREVISTA DE TÉRMINO',
      timeHelpText: 'SELECIONE O NOVO HORÁRIO PREVISTO DE TÉRMINO',
    );

    if (newEnd == null) return null;

    if (!newEnd.isAfter(currentStartDate)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFDC2626),
            content:
                Text('A data prevista de término deve ser posterior ao início.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return null;
    }

    return newEnd;
  }
}
