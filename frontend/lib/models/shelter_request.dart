import 'package:flutter/material.dart';

enum ShelterRequestStatus {
  pending,
  approved,
  rejected,
}

class ShelterRequest {
  final String id;
  final String name;
  final String address;
  final int capacity;
  final int currentOccupants;
  final ShelterRequestStatus status;
  final DateTime timestamp;
  final List<String> amenities;

  ShelterRequest({
    required this.id,
    required this.name,
    required this.address,
    required this.capacity,
    required this.currentOccupants,
    required this.status,
    required this.timestamp,
    required this.amenities,
  });

  String get statusLabel {
    switch (status) {
      case ShelterRequestStatus.pending:
        return 'Đang chờ duyệt';
      case ShelterRequestStatus.approved:
        return 'Đã phê duyệt';
      case ShelterRequestStatus.rejected:
        return 'Từ chối';
    }
  }

  Color get statusColor {
    switch (status) {
      case ShelterRequestStatus.pending:
        return Colors.orange;
      case ShelterRequestStatus.approved:
        return Colors.green;
      case ShelterRequestStatus.rejected:
        return Colors.red;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case ShelterRequestStatus.pending:
        return Icons.hourglass_empty;
      case ShelterRequestStatus.approved:
        return Icons.check_circle_outline;
      case ShelterRequestStatus.rejected:
        return Icons.error_outline;
    }
  }
}
