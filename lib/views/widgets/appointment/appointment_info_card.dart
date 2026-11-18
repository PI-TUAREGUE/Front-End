import 'package:flutter/material.dart';
import '../../../models/appointment.dart';

class AppointmentInfoCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentInfoCard({
    super.key,
    required this.appointment,
  });

  String _formatHour(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}h';
  }

  String _formatDayMonth(DateTime date) {
    const months = [
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
      'Dez.'
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    return '$day de $month';
  }

  String _formatYear(DateTime date) {
    return '${date.year}';
  }

  Widget _buildUnderlinedDateItem(String text) {
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
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDateRow(DateTime date) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildUnderlinedDateItem(_formatHour(date)),
        const SizedBox(width: 8),
        _buildUnderlinedDateItem(_formatDayMonth(date)),
        const SizedBox(width: 8),
        _buildUnderlinedDateItem(_formatYear(date)),
      ],
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

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(appointment.status);
    final statusLabel = _getStatusLabel(appointment.status);
    final createdDate = appointment.createdAt ?? appointment.startDate;
    final finishedDate = appointment.endDate ?? appointment.startDate;
    final scheduledBy = appointment.employee.isNotEmpty
        ? appointment.employee.first.name
        : 'Não informado';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            label: 'Nome',
            value: appointment.client,
          ),
          const Divider(
            color: Colors.white12,
            height: 26,
            thickness: 1,
          ),
          _buildInfoRow(
            label: 'Carro',
            value: appointment.car,
          ),
          const Divider(
            color: Colors.white12,
            height: 26,
            thickness: 1,
          ),
          _buildInfoRow(
            label: 'Placa',
            value: appointment.plate,
          ),
          const Divider(
            color: Colors.white12,
            height: 26,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Criado em',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              _buildDateRow(createdDate),
            ],
          ),
          const Divider(
            color: Colors.white12,
            height: 26,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Finalizado',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              _buildDateRow(finishedDate),
            ],
          ),
          const Divider(
            color: Colors.white12,
            height: 26,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.white12,
            height: 26,
            thickness: 1,
          ),
          _buildInfoRow(
            label: 'Agendado por',
            value: scheduledBy,
          ),
        ],
      ),
    );
  }
}
