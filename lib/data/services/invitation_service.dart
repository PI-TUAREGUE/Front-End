import '../network/requester.dart';

enum InvitationStatus {
  pending('Pendente'),
  accepted('Aceito'),
  rejected('Recusado'),
  cancelled('Cancelado');

  final String label;
  const InvitationStatus(this.label);
}

class InvitationService {
  final Requester _requester = Requester();

  Future<dynamic> create({
    required String schedulingId,
    required List<String> employeesIds,
  }) async {
    final body = {
      'scheduling': schedulingId,
      'employeesIds': employeesIds,
    };
    return await _requester.post('/invitations', body: body);
  }

  Future<dynamic> findById(String id) async {
    return await _requester.get('/invitations/$id');
  }

  Future<List<dynamic>> findMyInvitations({InvitationStatus? status}) async {
    final queryParameters = <String, dynamic>{};
    if (status != null) {
      queryParameters['status'] = status.label;
    }

    final response = await _requester.get(
      '/invitations/employee',
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    if (response is List) {
      return response;
    }
    return [];
  }

  Future<dynamic> respondToInvitation(String id, InvitationStatus status) async {
    final body = {
      'status': status.label,
    };
    return await _requester.patch('/invitations/$id', body: body);
  }
}