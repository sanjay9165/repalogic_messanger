import 'package:repalogic_messanger/utilities/common_exports.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authRepository = ref.read(authRepositoryProvider);
    final isSignedIn = authRepository.isSignedIn();

    if (isSignedIn) {
      context.pushNamedAndRemoveUntil(Routes.chatRoomsScreen);
    } else {
      context.pushNamedAndRemoveUntil(Routes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline_sharp,
                size: 60,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 32),

            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              AppConstants.appTagline,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.lightGray),
            ),
            const SizedBox(height: 48),

            const CircularProgressIndicator(color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }
}
