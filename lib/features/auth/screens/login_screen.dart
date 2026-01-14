import 'package:repalogic_messanger/utilities/common_exports.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginHeader(),
              const SizedBox(height: 32),
              authState.when(
                data: (_) => GoogleSignInButton(
                  onPressed: () async {
                    await ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle();

                    final authRepository = ref.read(authRepositoryProvider);
                    final isSignedIn = authRepository.isSignedIn();

                    if (isSignedIn && context.mounted) {
                      context.pushNamedAndRemoveUntil(Routes.chatRoomsScreen);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppConstants.somethingWentWrong,
                              style: context.textTheme.displaySmall,
                            ),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                  ),
                ),
                error: (error, _) => Column(
                  children: [
                    Text(
                      '${AppConstants.errorPrefix}${error.toString()}',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GoogleSignInButton(
                      onPressed: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInWithGoogle();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
