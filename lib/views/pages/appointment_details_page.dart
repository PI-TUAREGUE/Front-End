import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../models/appointment.dart';
import '../widgets/appointment/appointment_collaborators_section.dart';
import '../widgets/appointment/appointment_header_image.dart';
import '../widgets/appointment/appointment_info_card.dart';
import '../widgets/appointment/appointment_receipt_button.dart';
import '../widgets/appointment/appointment_services_section.dart';

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
  late Appointment _appointment;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
    _refreshDetails();
  }

  Future<void> _refreshDetails() async {
    try {
      final updated = await _repository.getAppointmentById(_appointment.id);
      if (mounted) {
        setState(() {
          _appointment = updated;
        });
      }
    } catch (_) {}
  }

  Future<void> _handleDownloadReceipt() async {
    setState(() => _isDownloading = true);
    try {
      final bytes = await _repository.getAppointmentReceipt(_appointment.id);
      if (bytes.isEmpty) {
        throw Exception('Comprovante vazio retornado pelo servidor.');
      }

      final tempDir = await getTemporaryDirectory();
      final cleanPlate = _appointment.plate.replaceAll(RegExp(r'\s+'), '_');
      final fileName = 'comprovante_$cleanPlate.pdf';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      final xFile = XFile(
        file.path,
        mimeType: 'application/pdf',
        name: fileName,
      );

      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      final originRect = box != null
          ? (box.localToGlobal(Offset.zero) & box.size)
          : null;

      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          text:
              'Comprovante de Agendamento - ${_appointment.client} (${_appointment.car} / ${_appointment.plate})',
          sharePositionOrigin: originRect,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFDC2626),
          content: Text('Erro ao gerar/compartilhar comprovante: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppointmentHeaderImage(),
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
                  AppointmentInfoCard(appointment: _appointment),
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
    );
  }
}
