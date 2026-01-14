import 'package:repalogic_messanger/utilities/common_exports.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final chatRoomsProvider = StreamProvider.family<List<ChatRoomModel>, String>((
  ref,
  userId,
) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getChatRooms(userId);
});

final messagesProvider = StreamProvider.family<List<MessageModel>, String>((
  ref,
  chatRoomId,
) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getMessages(chatRoomId);
});

final chatRoomProvider = StreamProvider.family<ChatRoomModel?, String>((
  ref,
  chatRoomId,
) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getChatRoomStream(chatRoomId);
});

final searchUsersProvider = FutureProvider.family<List<UserModel>, String>((
  ref,
  query,
) async {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return await chatRepository.searchUsers(query);
});

final allUsersProvider = FutureProvider.family<List<UserModel>, String?>((
  ref,
  excludeUserId,
) async {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return await chatRepository.getAllUsers(excludeUserId: excludeUserId);
});

final chatControllerProvider =
    StateNotifierProvider<ChatController, AsyncValue<String?>>((ref) {
      final chatRepository = ref.watch(chatRepositoryProvider);
      return ChatController(chatRepository);
    });

class ChatController extends StateNotifier<AsyncValue<String?>> {
  final ChatRepository _chatRepository;

  ChatController(this._chatRepository) : super(const AsyncValue.data(null));

  // Create a new chat room
  Future<ChatRoomModel?> createChatRoom({
    required String name,
    required String createdBy,
    required String createdByName,
  }) async {
    state = const AsyncValue.loading();

    try {
      final chatRoom = await _chatRepository.createChatRoom(
        name: name,
        createdBy: createdBy,
        createdByName: createdByName,
      );
      state = AsyncValue.data(chatRoom.id);
      return chatRoom;
    } catch (e, stackTrace) {
      log('Error creating chat room: $e');
      state = AsyncValue.error(e, stackTrace);
      return null;
    }
  }

  // Add user to chat room
  Future<bool> addUserToChatRoom({
    required String roomId,
    required String userId,
    required String userName,
  }) async {
    try {
      await _chatRepository.addUserToChatRoom(
        roomId: roomId,
        userId: userId,
        userName: userName,
      );
      return true;
    } catch (e) {
      log('Error adding user to chat room: $e');
      return false;
    }
  }

  // Send a message
  Future<bool> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    String? senderPhotoUrl,
    required String text,
    MessageType type = MessageType.text,
  }) async {
    try {
      await _chatRepository.sendMessage(
        chatRoomId: chatRoomId,
        senderId: senderId,
        senderName: senderName,
        senderPhotoUrl: senderPhotoUrl,
        text: text,
        type: type,
      );
      return true;
    } catch (e) {
      log('Error sending message: $e');
      return false;
    }
  }

  // Get chat room
  Future<ChatRoomModel?> getChatRoom(String roomId) async {
    try {
      return await _chatRepository.getChatRoom(roomId);
    } catch (e) {
      log('Error getting chat room: $e');
      return null;
    }
  }

  // Check if user is in chat room
  Future<bool> isUserInChatRoom(String roomId, String userId) async {
    try {
      return await _chatRepository.isUserInChatRoom(roomId, userId);
    } catch (e) {
      log('Error checking if user is in chat room: $e');
      return false;
    }
  }

  // Reset state
  void resetState() {
    state = const AsyncValue.data(null);
  }
}
