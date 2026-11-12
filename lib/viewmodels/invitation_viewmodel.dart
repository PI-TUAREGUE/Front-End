import 'package:flutter/foundation.dart';
import '../data/repositories/invitation_repository.dart';
import '../models/invitation.dart';

class InvitationViewModel extends ChangeNotifier {
  final InvitationRepository _repository = InvitationRepository();

  List<Invitation> _invitations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Invitation> get invitations => _invitations;
  bool get hasNotifications => _invitations.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMyInvitations({
    InvitationStatus status = InvitationStatus.pending,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _invitations = await _repository.getMyInvitations(status: status);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendInvitations({
    required String schedulingId,
    required List<String> employeeIds,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.sendInvitations(
        schedulingId: schedulingId,
        employeeIds: employeeIds,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> respondToInvitation({
    required String id,
    required InvitationStatus status,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.respondToInvitation(id: id, status: status);
      _invitations.removeWhere((inv) => inv.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}