import 'package:repalogic_messanger/utilities/common_exports.dart';

class ChatRoomCard extends StatelessWidget {
  final ChatRoomModel chatRoom;
  final VoidCallback onTap;

  const ChatRoomCard({super.key, required this.chatRoom, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          radius: 28,
          child: Text(
            chatRoom.name.isNotEmpty
                ? chatRoom.name[0].toUpperCase()
                : AppConstants.defaultChatRoomInitial,
            style: context.textTheme.displayMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          chatRoom.displayName,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chatRoom.lastMessage ?? AppConstants.noMessagesYetWidget,
              style: context.textTheme.bodyMedium?.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${chatRoom.participantCount} ${chatRoom.participantCount == 1 ? AppConstants.participant : AppConstants.participants}',
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: AppColors.lightGray,
              ),
            ),
          ],
        ),
        trailing: chatRoom.lastMessageTime != null
            ? Text(
                chatRoom.lastMessageTime!.formatTime(),
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: AppColors.lightGray,
                ),
              )
            : null,
      ),
    );
  }
}
