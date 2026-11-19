import 'package:flutter/material.dart';
import '../../../models/service.dart';

class ServiceStatusModal extends StatelessWidget {
  final ServiceStatus currentStatus;

  const ServiceStatusModal({
    super.key,
    required this.currentStatus,
  });

  static Future<ServiceStatus?> show(
    BuildContext context,
    ServiceStatus currentStatus,
  ) {
    return showModalBottomSheet<ServiceStatus>(
      context: context,
      backgroundColor: const Color(0xFF1E1E22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ServiceStatusModal(currentStatus: currentStatus),
    );
  }

  Color _getStatusColor(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.active:
        return const Color(0xFF28A745);
      case ServiceStatus.inactive:
        return const Color(0xFFFF7A00);
    }
  }

  IconData _getStatusIcon(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.active:
        return Icons.check_circle_outline;
      case ServiceStatus.inactive:
        return Icons.pause_circle_outline;
    }
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
                    'Alterar Status do Serviço',
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
            ...ServiceStatus.values.map((status) {
              final isCurrent = status == currentStatus;
              final color = _getStatusColor(status);

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
                      Icon(
                        _getStatusIcon(status),
                        color: color,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          status.label,
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.white70,
                            fontSize: 16,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isCurrent)
                        Icon(
                          Icons.check,
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
