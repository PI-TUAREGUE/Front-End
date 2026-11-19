import 'package:flutter/material.dart';
import '../../../models/service.dart';

class ServiceGeneralInfoCard extends StatelessWidget {
  final ServiceModel service;
  final bool isAdmin;
  final bool isUpdatingStatus;
  final VoidCallback onStatusTap;

  const ServiceGeneralInfoCard({
    super.key,
    required this.service,
    required this.isAdmin,
    required this.isUpdatingStatus,
    required this.onStatusTap,
  });

  static const List<String> _monthAbbr = [
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

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomRow(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 14,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildDateRow(DateTime? date) {
    final localDate = date?.toLocal() ?? DateTime.now();
    final hourStr = '${localDate.hour.toString().padLeft(2, '0')}h';
    final monthStr = _monthAbbr[localDate.month - 1];
    final dayMonthStr = '${localDate.day.toString().padLeft(2, '0')} de $monthStr';
    final yearStr = localDate.year.toString();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDateSegment(hourStr),
        const SizedBox(width: 8),
        _buildDateSegment(dayMonthStr),
        const SizedBox(width: 8),
        _buildDateSegment(yearStr),
      ],
    );
  }

  Widget _buildDateSegment(String text) {
    return Container(
      padding: const EdgeInsets.only(bottom: 2),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFFF7A00),
            width: 1.5,
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isActive = service.status == ServiceStatus.active;
    final color = isActive ? const Color(0xFF28A745) : const Color(0xFFFF7A00);

    return InkWell(
      onTap: onStatusTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUpdatingStatus)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else ...[
              Text(
                service.status.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isAdmin) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF26262A),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildRow('Criado por', service.createdByName ?? 'Não informado'),
          const Divider(color: Color(0xFF26262A), height: 1, thickness: 1),
          _buildRow('Código', service.code),
          const Divider(color: Color(0xFF26262A), height: 1, thickness: 1),
          _buildCustomRow('Criado em', _buildDateRow(service.createdAt)),
          const Divider(color: Color(0xFF26262A), height: 1, thickness: 1),
          _buildCustomRow(
            'Editado em',
            _buildDateRow(service.updatedAt ?? service.createdAt),
          ),
          const Divider(color: Color(0xFF26262A), height: 1, thickness: 1),
          _buildCustomRow('Status', _buildStatusBadge(context)),
        ],
      ),
    );
  }
}
