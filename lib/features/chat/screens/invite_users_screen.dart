import 'package:repalogic_messanger/utilities/common_exports.dart';

class InviteUsersScreen extends ConsumerStatefulWidget {
  final ChatRoomModel chatRoom;

  const InviteUsersScreen({super.key, required this.chatRoom});

  @override
  ConsumerState<InviteUsersScreen> createState() => _InviteUsersScreenState();
}

class _InviteUsersScreenState extends ConsumerState<InviteUsersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  Set<String> _invitingUsers = {};
  final Set<String> _invitedUsers = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _inviteUser(String userId, String userName) async {
    if (widget.chatRoom.participants.contains(userId)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppConstants.userAlreadyInRoom)),
        );
      }
      return;
    }

    setState(() {
      _invitingUsers.add(userId);
    });

    try {
      final chatController = ref.read(chatControllerProvider.notifier);
      final success = await chatController.addUserToChatRoom(
        roomId: widget.chatRoom.id,
        userId: userId,
        userName: userName,
      );

      if (mounted) {
        if (success) {
          setState(() {
            _invitedUsers.add(userId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$userName ${AppConstants.userHasBeenInvited}'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppConstants.failedToInviteUser)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppConstants.errorPrefix}${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        Set<String> tempInvitingUsers = _invitingUsers;
        tempInvitingUsers.remove(userId);
        setState(() {
          _invitingUsers = tempInvitingUsers;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final currentUser = authRepository.getCurrentUser();

    final usersAsync = _searchQuery.isEmpty
        ? ref.watch(allUsersProvider(currentUser?.uid))
        : ref.watch(searchUsersProvider(_searchQuery));

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.inviteUsers)),
      body: Column(
        children: [
          SearchInputField(
            searchController: _searchController,
            searchQuery: _searchQuery,
            clearSearch: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
            onSearch: (value) {
              setState(() {
                _searchQuery = value.trim();
              });
            },
          ),

          Expanded(
            child: usersAsync.when(
              data: (users) {
                final availableUsers = users
                    .where(
                      (user) =>
                          !widget.chatRoom.participants.contains(user.uid) &&
                          !_invitedUsers.contains(user.uid),
                    )
                    .toList();

                if (availableUsers.isEmpty) {
                  return EmptySearchList(searchQuery: _searchQuery);
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: availableUsers.length,
                  itemBuilder: (context, index) {
                    final user = availableUsers[index];
                    final isInviting = _invitingUsers.contains(user.uid);

                    return UserListTile(
                      user: user,
                      onTap: isInviting
                          ? null
                          : () => _inviteUser(user.uid, user.displayName),
                      trailing: isInviting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () =>
                                  _inviteUser(user.uid, user.displayName),

                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    AppConstants.invite,
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                              ),
                            ),
                    );
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
                      AppConstants.errorLoadingUsers,
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
          ),
        ],
      ),
    );
  }
}
