import 'package:repalogic_messanger/utilities/common_exports.dart';

class CreateChatRoomScreen extends ConsumerStatefulWidget {
  const CreateChatRoomScreen({super.key});

  @override
  ConsumerState<CreateChatRoomScreen> createState() =>
      _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends ConsumerState<CreateChatRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  Future<void> _createChatRoom() async {
    if (!_formKey.currentState!.validate()) return;

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
      _isLoading = true;
    });

    try {
      final chatController = ref.read(chatControllerProvider.notifier);
      final chatRoom = await chatController.createChatRoom(
        name: _roomNameController.text.trim(),
        createdBy: currentUser.uid,
        createdByName: currentUser.displayName ?? AppConstants.unknownUser,
      );

      if (mounted) {
        if (chatRoom != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppConstants.chatRoomCreatedSuccess)),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppConstants.failedToCreateChatRoom)),
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.createChatRoom)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(
                Icons.chat_bubble_outline,
                size: 80,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 32),
              Text(
                AppConstants.createNewChatRoomTitle,
                textAlign: TextAlign.center,
                style: context.textTheme.displayMedium?.copyWith(
                  color: AppColors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.enterChatRoomName,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: AppConstants.chatRoomName,
                hintText: AppConstants.chatRoomNameHint,
                controller: _roomNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppConstants.pleaseEnterRoomName;
                  }
                  if (value.trim().length < 3) {
                    return AppConstants.roomNameMinLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: AppConstants.createRoom,
                onPressed: _isLoading ? null : _createChatRoom,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text(AppConstants.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
