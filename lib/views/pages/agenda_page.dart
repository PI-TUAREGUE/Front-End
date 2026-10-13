import 'package:flutter/material.dart';
import '../../models/appointment.dart';
import '../widgets/cards/schedule_card.dart';
import '../widgets/shared/timeline_group.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = groupAppointmentsByHour(appointmentsMock);
    final hours = grouped.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Agendamentos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
          
                for (int i = 0; i < hours.length; i++) ...[
                  Builder(
                    builder: (context) {
                      final hour = hours[i];
                      final appointmentsInHour = grouped[hour]!;
                      final isLast = i == hours.length - 1;
                      return TimelineGroup(
                        title: '${hour.toString().padLeft(2, '0')}:00',
                        closingTitle: isLast
                            ? '${(hour + 1).toString().padLeft(2, '0')}:00'
                            : null,
                        children: appointmentsInHour
                            .map((item) => ScheduleCard(appointment: item))
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}