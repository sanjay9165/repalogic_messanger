import 'package:repalogic_messanger/utilities/common_exports.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ChatRoomModel chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final authRepository = ref.read(authRepositoryProvider);
    final currentUser = authRepository.getCurrentUser();

    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppConstants.pleaseSignInFirst)),
        );
      }
      return;
    }

    setState(() {
      _isSending = true;
    });

    _messageController.clear();

    try {
      final chatController = ref.read(chatControllerProvider.notifier);
      final success = await chatController.sendMessage(
        chatRoomId: widget.chatRoom.id,
        senderId: currentUser.uid,
        senderName: currentUser.displayName ?? AppConstants.unknownUser,
        senderPhotoUrl: currentUser.photoURL,
        text: message,
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppConstants.failedToSendMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppConstants.errorPrefix}${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final currentUser = authRepository.getCurrentUser();
    final messagesAsync = ref.watch(messagesProvider(widget.chatRoom.id));
    final chatRoomAsync = ref.watch(chatRoomProvider(widget.chatRoom.id));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatRoom.displayName),
            chatRoomAsync.when(
              data: (chatRoom) {
                final participantCount =
                    chatRoom?.participantCount ??
                    widget.chatRoom.participantCount;
                return Text(
                  '$participantCount ${participantCount == 1 ? AppConstants.participant : AppConstants.participants}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                );
              },
              loading: () => Text(
                '${widget.chatRoom.participantCount} ${widget.chatRoom.participantCount == 1 ? AppConstants.participant : AppConstants.participants}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              error: (_, __) => Text(
                '${widget.chatRoom.participantCount} ${widget.chatRoom.participantCount == 1 ? AppConstants.participant : AppConstants.participants}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: AppColors.white),
            onPressed: () {
              context.pushNamed(
                Routes.inviteUsersScreen,
                arguments: widget.chatRoom,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.message_outlined,
                          size: 80,
                          color: AppColors.lightGray,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppConstants.noMessagesYet,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: AppColors.lightGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppConstants.sendMessageToStart,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUser?.uid;
                    return MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppConstants.errorLoadingMessages,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          MessageInputField(
            messageController: _messageController,
            sendMessage: _sendMessage,
            isSending: _isSending,
          ),
        ],
      ),
    );
  }
}
