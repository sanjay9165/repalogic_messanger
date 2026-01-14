import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final String name;
  final String createdBy;
  final String createdByName;
  final List<String> participants;
  final List<String> participantNames;
  final DateTime createdAt;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  ChatRoomModel({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdByName,
    required this.participants,
    required this.participantNames,
    required this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'participants': participants,
      'participantNames': participantNames,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null
          ? Timestamp.fromDate(lastMessageTime!)
          : null,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdByName: map['createdByName'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      participantNames: List<String>.from(map['participantNames'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null
          ? (map['lastMessageTime'] as Timestamp).toDate()
          : null,
    );
  }

  int get participantCount => participants.length;

  String get displayName => name.isEmpty ? 'Unnamed Chat' : name;
}
