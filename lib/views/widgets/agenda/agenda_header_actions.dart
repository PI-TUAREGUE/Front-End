import 'package:flutter/material.dart';
import '../../../viewmodels/appointment_viewmodel.dart';

class AgendaHeaderActions extends StatelessWidget {
  final AgendaFilter currentFilter;
  final ValueChanged<AgendaFilter> onFilterChanged;
  final bool hasNotifications;
  final VoidCallback onNotificationsTap;

  const AgendaHeaderActions({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.hasNotifications,
    required this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Agendamentos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupMenuButton<AgendaFilter>(
              initialValue: currentFilter,
              color: const Color(0xFF1E1E22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.white12),
              ),
              onSelected: onFilterChanged,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: AgendaFilter.forMe,
                  child: Text(
                    'Para mim',
                    style: TextStyle(
                      color: currentFilter == AgendaFilter.forMe
                          ? const Color(0xFFFF7A00)
                          : Colors.white,
                      fontWeight: currentFilter == AgendaFilter.forMe
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: AgendaFilter.all,
                  child: Text(
                    'Todos',
                    style: TextStyle(
                      color: currentFilter == AgendaFilter.all
                          ? const Color(0xFFFF7A00)
                          : Colors.white,
                      fontWeight: currentFilter == AgendaFilter.all
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF28282B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentFilter == AgendaFilter.forMe
                          ? 'Para mim'
                          : 'Todos',
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
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onNotificationsTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFF28282B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  if (hasNotifications)
                    Positioned(
                      top: 1,
                      right: 1,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF28282B),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
