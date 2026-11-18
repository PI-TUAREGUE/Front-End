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

class _DaySelectorBarState extends State<DaySelectorBar>
    with WidgetsBindingObserver {
  ScrollController? _scrollController;
  final Map<int, GlobalKey> _dayKeys = {};

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

  GlobalKey _getKeyForDay(int day) =>
      _dayKeys.putIfAbsent(day, () => GlobalKey());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollController == null) {
      final initialOffset = _calculateTargetOffset();
      _scrollController = ScrollController(initialScrollOffset: initialOffset);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleCentering(animate: false);
  }

  @override
  void didUpdateWidget(DaySelectorBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _scheduleCentering(animate: true);
    } else {
      _scheduleCentering(animate: false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _scheduleCentering(animate: false);
    }
  }

  void _scheduleCentering({bool animate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToSelectedDay(animate: animate);
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      _scrollToSelectedDay(animate: animate);
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _scrollToSelectedDay(animate: animate);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController?.dispose();
    super.dispose();
  }

  double _calculateTargetOffset([double? customViewportWidth]) {
    final targetIndex = widget.selectedDate.day - 1;
    const itemWidth = 46.0;
    const separatorWidth = 10.0;
    const itemSpacing = itemWidth + separatorWidth;

    final screenWidth = MediaQuery.of(context).size.width;
    final viewportWidth = customViewportWidth ??
        (screenWidth > 40.0 ? screenWidth - 40.0 : screenWidth);

    final totalContentWidth = (_daysInMonth * itemSpacing) - separatorWidth;
    final maxScroll =
        (totalContentWidth - viewportWidth).clamp(0.0, double.infinity);

    final itemCenter = (targetIndex * itemSpacing) + (itemWidth / 2);
    final targetOffset = itemCenter - (viewportWidth / 2);

    return targetOffset.clamp(0.0, maxScroll);
  }

  void _scrollToSelectedDay({bool animate = true}) {
    final targetContext = _dayKeys[widget.selectedDate.day]?.currentContext;
    if (targetContext != null && targetContext.mounted) {
      Scrollable.ensureVisible(
        targetContext,
        alignment: 0.5,
        duration: animate ? const Duration(milliseconds: 300) : Duration.zero,
        curve: Curves.easeOut,
      );
      return;
    }

    if (_scrollController == null || !_scrollController!.hasClients) return;

    final position = _scrollController!.position;
    final maxScroll = position.maxScrollExtent;
    if (maxScroll <= 0) return;

    final viewportWidth = position.viewportDimension;
    final offset = _calculateTargetOffset(viewportWidth);
    final clampedOffset = offset.clamp(0.0, maxScroll);

    if (animate) {
      _scrollController!.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController!.jumpTo(clampedOffset);
    }
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
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      for (int index = 0; index < _daysInMonth; index++) ...[
                        if (index > 0) const SizedBox(width: 10),
                        DaySelectorItem(
                          key: _getKeyForDay(index + 1),
                          dayNumber: index + 1,
                          label: _weekdays[DateTime(
                            currentYear,
                            currentMonth,
                            index + 1,
                          ).weekday - 1],
                          isSelected: (index + 1) == widget.selectedDate.day,
                          onTap: () => widget.onDateSelected(
                            DateTime(currentYear, currentMonth, index + 1),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
