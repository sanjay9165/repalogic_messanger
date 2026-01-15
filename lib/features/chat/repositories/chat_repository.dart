import 'package:repalogic_messanger/utilities/common_exports.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  ChatRepository({FirebaseFirestore? firestore, Uuid? uuid})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _uuid = uuid ?? const Uuid();

  // Create a new chat room
  Future<ChatRoomModel> createChatRoom({
    required String name,
    required String createdBy,
    required String createdByName,
  }) async {
    try {
      final roomId = _uuid.v4();
      final chatRoom = ChatRoomModel(
        id: roomId,
        name: name,
        createdBy: createdBy,
        createdByName: createdByName,
        participants: [createdBy],
        participantNames: [createdByName],
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.collectionChatRooms)
          .doc(roomId)
          .set(chatRoom.toMap());

      return chatRoom;
    } catch (e) {
      log('Error creating chat room: $e');
      throw Exception('Failed to create chat room: ${e.toString()}');
    }
  }

  // Get chat rooms for a user
  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    try {
      return _firestore
          .collection(AppConstants.collectionChatRooms)
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return ChatRoomModel.fromMap(doc.data());
            }).toList();
          });
    } catch (e) {
      log('Error getting chat rooms: $e');
      return Stream.value([]);
    }
  }

  // Get a single chat room
  Future<ChatRoomModel?> getChatRoom(String roomId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.collectionChatRooms)
          .doc(roomId)
          .get();
      if (doc.exists && doc.data() != null) {
        return ChatRoomModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      log('Error getting chat room: $e');
      return null;
    }
  }

  // Get a single chat room as stream for real-time updates
  Stream<ChatRoomModel?> getChatRoomStream(String roomId) {
    try {
      return _firestore
          .collection(AppConstants.collectionChatRooms)
          .doc(roomId)
          .snapshots()
          .map((doc) {
            if (doc.exists && doc.data() != null) {
              return ChatRoomModel.fromMap(doc.data()!);
            }
            return null;
          });
    } catch (e) {
      log('Error getting chat room stream: $e');
      return Stream.value(null);
    }
  }

  // Add user to chat room
  Future<void> addUserToChatRoom({
    required String roomId,
    required String userId,
    required String userName,
  }) async {
    try {
      final roomRef = _firestore
          .collection(AppConstants.collectionChatRooms)
          .doc(roomId);

      await roomRef.update({
        'participants': FieldValue.arrayUnion([userId]),
        'participantNames': FieldValue.arrayUnion([userName]),
      });
    } catch (e) {
      log('Error adding user to chat room: $e');
      throw Exception('Failed to add user to chat room: ${e.toString()}');
    }
  }

  // Send a message
  Future<MessageModel> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    String? senderPhotoUrl,
    required String text,
    MessageType type = MessageType.text,
  }) async {
    try {
      final messageId = _uuid.v4();
      final message = MessageModel(
        id: messageId,
        chatRoomId: chatRoomId,
        senderId: senderId,
        senderName: senderName,
        senderPhotoUrl: senderPhotoUrl,
        text: text,
        timestamp: DateTime.now(),
        type: type,
      );

      await _firestore
          .collection(AppConstants.collectionChatRooms)
          .doc(chatRoomId)
          .collection(AppConstants.collectionMessages)
          .doc(messageId)
          .set(message.toMap());

      await _firestore
          .collection(AppConstants.collectionChatRooms)
          .doc(chatRoomId)
          .update({
            'lastMessage': text,
            'lastMessageTime': Timestamp.fromDate(message.timestamp),
          });

      return message;
    } catch (e) {
      log('Error sending message: $e');
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  // Get messages for a chat room
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    try {
      return _firestore
          .collection(AppConstants.collectionChatRooms)
          .doc(chatRoomId)
          .collection(AppConstants.collectionMessages)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return MessageModel.fromMap(doc.data());
            }).toList();
          });
    } catch (e) {
      log('Error getting messages: $e');
      return Stream.value([]);
    }
  }

  // Search users by email or name
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      if (query.isEmpty) return [];

      final emailQuery = await _firestore
          .collection(AppConstants.collectionUsers)
          .where('email', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('email', isLessThan: '${query.toLowerCase()}z')
          .get();

      final nameQuery = await _firestore
          .collection(AppConstants.collectionUsers)
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThan: '${query}z')
          .get();

      final users = <String, UserModel>{};

      for (var doc in emailQuery.docs) {
        final user = UserModel.fromMap(doc.data());
        users[user.uid] = user;
      }

      for (var doc in nameQuery.docs) {
        final user = UserModel.fromMap(doc.data());
        users[user.uid] = user;
      }

      return users.values.toList();
    } catch (e) {
      log('Error searching users: $e');
      return [];
    }
  }

  // Get all users (for invitation)
  Future<List<UserModel>> getAllUsers({String? excludeUserId}) async {
    try {
      final query = _firestore.collection(AppConstants.collectionUsers);
      final snapshot = await query.get();

      final users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .where((user) => excludeUserId == null || user.uid != excludeUserId)
          .toList();

      return users;
    } catch (e) {
      log('Error getting all users: $e');
      return [];
    }
  }

  // Check if user is in chat room
  Future<bool> isUserInChatRoom(String roomId, String userId) async {
    try {
      final room = await getChatRoom(roomId);
      return room?.participants.contains(userId) ?? false;
    } catch (e) {
      log('Error checking if user is in chat room: $e');
      return false;
    }
  }
}
