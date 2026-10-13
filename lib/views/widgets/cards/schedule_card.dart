import 'package:flutter/material.dart';
import 'package:front_end/views/widgets/shared/team_avatar_stack.dart';
import '../../../models/appointment.dart';
import '../../pages/appointment_details_page.dart';

class ScheduleCard extends StatelessWidget {
  final Appointment appointment;

  const ScheduleCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        16,
      ), 
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppointmentDetailsPage(appointment: appointment),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF28282B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment.serviceTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  appointment.formattedTime,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.white54,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment.clientName,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.directions_car_outlined,
                  size: 16,
                  color: Colors.white54,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment.vehicleModel,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 14),

            TeamAvatarStack(employees: appointment.mechanics),
          ],
        ),
      ),
    );
  }
}
