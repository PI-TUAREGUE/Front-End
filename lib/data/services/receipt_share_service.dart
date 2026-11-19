import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/appointment.dart';
import '../repositories/appointment_repository.dart';

class ReceiptShareService {
  final AppointmentRepository _repository = AppointmentRepository();

  Future<void> downloadAndShareReceipt({
    required BuildContext context,
    required Appointment appointment,
  }) async {
    final bytes = await _repository.getAppointmentReceipt(appointment.id);
    if (bytes.isEmpty) {
      throw Exception('Comprovante vazio retornado pelo servidor.');
    }

    final tempDir = await getTemporaryDirectory();
    final cleanPlate = appointment.plate.replaceAll(RegExp(r'\s+'), '_');
    final fileName = 'comprovante_$cleanPlate.pdf';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    final xFile = XFile(
      file.path,
      mimeType: 'application/pdf',
      name: fileName,
    );

    if (!context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    final originRect =
        box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;

    await SharePlus.instance.share(
      ShareParams(
        files: [xFile],
        text:
            'Comprovante de Agendamento - ${appointment.client} (${appointment.car} / ${appointment.plate})',
        sharePositionOrigin: originRect,
      ),
    );
  }
}
