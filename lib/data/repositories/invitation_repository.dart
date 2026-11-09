import '../../models/invitation.dart';
import '../services/invitation_service.dart';

class InvitationRepository {
  final InvitationService _invitationService = InvitationService();

  Future<void> sendInvitations({
    required String schedulingId,
    required List<String> employeeIds,
  }) async {
    await _invitationService.create(
      schedulingId: schedulingId,
      employeesIds: employeeIds,
    );
  }

  Future<Invitation?> getInvitationById(String id) async {
    final response = await _invitationService.findById(id);
    if (response is Map<String, dynamic>) {
      return Invitation.fromJson(response);
    }
    return null;
  }

  Future<List<Invitation>> getMyInvitations({InvitationStatus? status}) async {
    final response = await _invitationService.findMyInvitations(status: status);
    return response
        .whereType<Map<String, dynamic>>()
        .map((item) => Invitation.fromJson(item))
        .toList();
  }

  Future<void> respondToInvitation({
    required String id,
    required InvitationStatus status,
  }) async {
    await _invitationService.respondToInvitation(id, status);
  }
}