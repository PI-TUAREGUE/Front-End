import 'package:flutter/material.dart';
import '../../../models/appointment.dart';

class StatusSelectorModal extends StatelessWidget {
  final SchedulingStatus currentStatus;

  const StatusSelectorModal({
    super.key,
    required this.currentStatus,
  });

  static Future<SchedulingStatus?> show(
    BuildContext context,
    SchedulingStatus currentStatus,
  ) {
    return showModalBottomSheet<SchedulingStatus>(
      context: context,
      backgroundColor: const Color(0xFF1E1E22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatusSelectorModal(currentStatus: currentStatus),
    );
  }

  Color _getStatusColor(SchedulingStatus status) {
    switch (status) {
      case SchedulingStatus.finished:
        return const Color(0xFF2EBD59);
      case SchedulingStatus.wik:
        return const Color(0xFF0284C7);
      case SchedulingStatus.scheduled:
        return const Color(0xFFFF7A00);
      case SchedulingStatus.late:
      case SchedulingStatus.canceled:
        return const Color(0xFFDC2626);
    }
  }

  String _getStatusLabel(SchedulingStatus status) {
    if (status == SchedulingStatus.finished) return 'Finalizado';
    return status.label;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Alterar Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white60),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...SchedulingStatus.values.map((status) {
              final isCurrent = status == currentStatus;
              final color = _getStatusColor(status);
              final label = _getStatusLabel(status);

              return InkWell(
                onTap: () => Navigator.of(context).pop(status),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF28282D)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent ? color : Colors.white10,
                      width: isCurrent ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.white70,
                            fontSize: 15,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isCurrent)
                        Icon(
                          Icons.check_circle,
                          color: color,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
