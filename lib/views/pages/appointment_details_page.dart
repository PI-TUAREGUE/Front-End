import 'package:flutter/material.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/receipt_share_service.dart';
import '../../models/appointment.dart';
import '../widgets/appointment/appointment_collaborators_section.dart';
import '../widgets/appointment/appointment_date_picker_helper.dart';
import '../widgets/appointment/appointment_header_image.dart';
import '../widgets/appointment/appointment_info_card.dart';
import '../widgets/appointment/appointment_receipt_button.dart';
import '../widgets/appointment/appointment_services_section.dart';
import '../widgets/appointment/status_selector_modal.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailsPage({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  final AppointmentRepository _repository = AppointmentRepository();
  final AuthService _authService = AuthService();
  final ReceiptShareService _receiptService = ReceiptShareService();

  late Appointment _appointment;
  bool _isDownloading = false;
  bool _canEdit = false;
  bool _isUpdating = false;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
    _refreshDetails();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      final currentUserId = await _authService.getCurrentUserId();
      final isAdmin = await _authService.isCurrentUserAdmin();
      if (mounted) {
        setState(() {
          _canEdit = _appointment.canBeEditedBy(
            userId: currentUserId,
            isAdmin: isAdmin,
          );
        });
      }
    } catch (_) {}
  }

  Future<void> _refreshDetails() async {
    try {
      final updated = await _repository.getAppointmentById(_appointment.id);
      if (mounted) {
        setState(() {
          _appointment = updated;
        });
        _checkPermissions();
      }
    } catch (_) {}
  }

  Future<void> _executeAction({
    required Future<Appointment> Function() action,
    required String successMessage,
  }) async {
    setState(() => _isUpdating = true);
    try {
      final updated = await action();
      if (mounted) {
        setState(() {
          _appointment = updated;
          _hasChanged = true;
        });
        _showSnackbar(successMessage, isError: false);
      }
    } catch (e) {
      if (mounted) {
        _showSnackbar(e.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  Future<void> _handleSelectStatus() async {
    if (!_canEdit || _isUpdating) return;

    final selected = await StatusSelectorModal.show(
      context,
      _appointment.status,
    );

    if (selected != null && selected != _appointment.status) {
      await _executeAction(
        action: () => _repository.updateAppointmentStatus(
          id: _appointment.id,
          status: selected,
        ),
        successMessage: 'Status atualizado com sucesso!',
      );
    }
  }

  Future<void> _handleSelectStartDate() async {
    if (!_canEdit || _isUpdating) return;

    final range = await AppointmentDatePickerHelper.promptReschedule(
      context: context,
      currentStartDate: _appointment.startDate,
      currentEndDate: _appointment.endDate,
    );

    if (range != null) {
      await _executeAction(
        action: () => _repository.reschedule(
          id: _appointment.id,
          newStartDate: range.start,
          newEndDate: range.end,
          currentEndDate: _appointment.endDate,
        ),
        successMessage: 'Datas e horários atualizados com sucesso!',
      );
    }
  }

  Future<void> _handleSelectEndDate() async {
    if (!_canEdit || _isUpdating) return;

    final newEndDate = await AppointmentDatePickerHelper.promptEndDate(
      context: context,
      currentStartDate: _appointment.startDate,
      currentEndDate: _appointment.endDate,
    );

    if (newEndDate != null) {
      await _executeAction(
        action: () => _repository.updateEndDate(
          id: _appointment.id,
          endDate: newEndDate,
        ),
        successMessage: 'Data prevista atualizada com sucesso!',
      );
    }
  }

  Future<void> _handleDownloadReceipt() async {
    setState(() => _isDownloading = true);
    try {
      await _receiptService.downloadAndShareReceipt(
        context: context,
        appointment: _appointment,
      );
    } catch (e) {
      if (mounted) {
        _showSnackbar(
          'Erro ao gerar/compartilhar comprovante: ${e.toString()}',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  void _showSnackbar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            isError ? const Color(0xFFDC2626) : const Color(0xFF2EBD59),
        content: Text(message),
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppointmentHeaderImage(
                onBackPressed: () => Navigator.of(context).pop(_hasChanged),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações gerais:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppointmentInfoCard(
                      appointment: _appointment,
                      canEditStatus: _canEdit,
                      onStatusTap: _handleSelectStatus,
                      canEditDates: _canEdit,
                      onStartDateTap: _handleSelectStartDate,
                      onEndDateTap: _handleSelectEndDate,
                    ),
                    const SizedBox(height: 28),
                    AppointmentServicesSection(services: _appointment.service),
                    const SizedBox(height: 28),
                    AppointmentCollaboratorsSection(
                      employees: _appointment.employee,
                    ),
                    const SizedBox(height: 36),
                    AppointmentReceiptButton(
                      isDownloading: _isDownloading,
                      onPressed: _handleDownloadReceipt,
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
