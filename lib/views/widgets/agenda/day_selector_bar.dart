import 'package:flutter/material.dart';
import 'day_selector_item.dart';
import 'month_year_picker_dialog.dart';

class DaySelectorBar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback? onAddAppointment;

  const DaySelectorBar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.onAddAppointment,
  });

  @override
  State<DaySelectorBar> createState() => _DaySelectorBarState();
}

class _DaySelectorBarState extends State<DaySelectorBar> {
  final ScrollController _scrollController = ScrollController();

  static const List<String> _weekdays = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];

  static const List<String> _monthNames = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  static const List<String> _shortMonthNames = [
    'Jan.',
    'Fev.',
    'Mar.',
    'Abr.',
    'Mai.',
    'Jun.',
    'Jul.',
    'Ago.',
    'Set.',
    'Out.',
    'Nov.',
    'Dez.',
  ];

  int get _daysInMonth =>
      DateTime(widget.selectedDate.year, widget.selectedDate.month + 1, 0).day;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
  }

  @override
  void didUpdateWidget(DaySelectorBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDay() {
    if (!_scrollController.hasClients) return;
    final targetIndex = widget.selectedDate.day - 1;
    const itemWidth = 56.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = (targetIndex * itemWidth) - (screenWidth / 2) + 23;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final offset = targetOffset.clamp(0.0, maxScroll);
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _openMonthYearPicker() async {
    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => MonthYearPickerDialog(
        initialDate: widget.selectedDate,
        monthNames: _monthNames,
      ),
    );

    if (pickedDate != null && mounted) {
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = widget.selectedDate.year;
    final currentMonth = widget.selectedDate.month;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141416),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onAddAppointment,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A00),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Novo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _openMonthYearPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF28282B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_shortMonthNames[currentMonth - 1]} $currentYear',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 84,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _daysInMonth,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final dayNumber = index + 1;
                    final dayDate =
                        DateTime(currentYear, currentMonth, dayNumber);
                    final weekdayIndex = dayDate.weekday - 1;
                    final label = _weekdays[weekdayIndex];
                    final isSelected = dayNumber == widget.selectedDate.day;

                    return DaySelectorItem(
                      dayNumber: dayNumber,
                      label: label,
                      isSelected: isSelected,
                      onTap: () => widget.onDateSelected(dayDate),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
