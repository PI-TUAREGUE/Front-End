enum InvitationStatus {
  pending('Pendente'),
  accepted('Aceito'),
  rejected('Recusado'),
  cancelled('Cancelado');

  final String label;
  const InvitationStatus(this.label);

  static InvitationStatus fromString(String value) {
    return InvitationStatus.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => InvitationStatus.pending,
    );
  }
}

class Invitation {
  final String id;
  final String schedulingId;
  final String senderId;
  final String receiverId;
  final InvitationStatus status;
  final DateTime? respondedAt;
  final DateTime? createdAt;

  Invitation({
    required this.id,
    required this.schedulingId,
    required this.senderId,
    required this.receiverId,
    required this.status,
    this.respondedAt,
    this.createdAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      schedulingId: json['scheduling'] is Map
          ? (json['scheduling']['_id'] ?? '')
          : (json['scheduling']?.toString() ?? ''),
      senderId: json['sender'] is Map
          ? (json['sender']['_id'] ?? '')
          : (json['sender']?.toString() ?? ''),
      receiverId: json['receiver'] is Map
          ? (json['receiver']['_id'] ?? '')
          : (json['receiver']?.toString() ?? ''),
      status: json['status'] != null
          ? InvitationStatus.fromString(json['status'].toString())
          : InvitationStatus.pending,
      respondedAt: json['respondedAt'] != null
          ? DateTime.tryParse(json['respondedAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}