import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../viewmodels/appointment_viewmodel.dart';
import '../../viewmodels/invitation_viewmodel.dart';
import '../widgets/agenda/agenda_header_actions.dart';
import '../widgets/agenda/day_selector_bar.dart';
import '../widgets/agenda/invitations_modal.dart';
import '../widgets/cards/schedule_card.dart';
import '../widgets/shared/timeline_group.dart';
import 'create_appointment_page.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late final AppointmentViewModel _viewModel;
  late final InvitationViewModel _invitationViewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AppointmentViewModel();
    _invitationViewModel = InvitationViewModel();

    AuthRepository().getCurrentUserId().then((id) {
      if (mounted) _viewModel.setCurrentUserId(id);
    });

    _viewModel.loadAppointments();
    _invitationViewModel.loadMyInvitations();
  }

  Future<void> _navigateToAddAppointment() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateAppointmentPage(
          initialDate: _viewModel.selectedDate,
        ),
      ),
    );

    if (created == true && mounted) {
      _viewModel.loadAppointments();
    }
  }

  void _openInvitations() {
    InvitationsModal.show(
      context: context,
      invitationViewModel: _invitationViewModel,
      onInvitationAccepted: () {
        _viewModel.loadAppointments();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Column(
        children: [
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return DaySelectorBar(
                selectedDate: _viewModel.selectedDate,
                onDateSelected: (date) {
                  _viewModel.selectDate(date);
                },
                onAddAppointment: _navigateToAddAppointment,
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListenableBuilder(
                    listenable: Listenable.merge([
                      _viewModel,
                      _invitationViewModel,
                    ]),
                    builder: (context, _) {
                      return AgendaHeaderActions(
                        currentFilter: _viewModel.filter,
                        onFilterChanged: (filter) =>
                            _viewModel.setFilter(filter),
                        hasNotifications:
                            _invitationViewModel.hasNotifications,
                        onNotificationsTap: _openInvitations,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      if (_viewModel.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF7A00),
                            ),
                          ),
                        );
                      }

                      if (_viewModel.errorMessage != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _viewModel.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () =>
                                      _viewModel.loadAppointments(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF7A00),
                                  ),
                                  child: const Text(
                                    'Tentar novamente',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final grouped = _viewModel.groupedAppointments;
                      final hours = _viewModel.hours;

                      if (hours.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Text(
                              'Nenhum agendamento para este dia.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < hours.length; i++) ...[
                            Builder(
                              builder: (context) {
                                final hour = hours[i];
                                final appointmentsInHour = grouped[hour]!;
                                final isLast = i == hours.length - 1;
                                return TimelineGroup(
                                  title:
                                      '${hour.toString().padLeft(2, '0')}:00',
                                  closingTitle: isLast
                                      ? '${(hour + 1).toString().padLeft(2, '0')}:00'
                                      : null,
                                  children: appointmentsInHour
                                      .map(
                                        (item) => ScheduleCard(
                                          appointment: item,
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
