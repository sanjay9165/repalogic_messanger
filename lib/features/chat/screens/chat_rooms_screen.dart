import 'package:repalogic_messanger/utilities/common_exports.dart';

class ChatRoomsScreen extends ConsumerWidget {
  const ChatRoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final currentUser = authRepository.getCurrentUser();

    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushNamedAndRemoveUntil(Routes.loginScreen);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final chatRoomsAsync = ref.watch(chatRoomsProvider(currentUser.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.chatRooms),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.pushNamedAndRemoveUntil(Routes.loginScreen);
              }
            },
          ),
        ],
      ),
      body: chatRoomsAsync.when(
        data: (chatRooms) {
          if (chatRooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: AppColors.lightGray,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.noChatRoomsYet,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.lightGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.createNewChatRoom,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              return ChatRoomCard(
                chatRoom: chatRoom,
                onTap: () {
                  context.pushNamed(Routes.chatScreen, arguments: chatRoom);
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                AppConstants.errorLoadingChatRooms,
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(Routes.createChatRoomScreen);
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
