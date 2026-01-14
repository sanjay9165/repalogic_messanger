import 'package:repalogic_messanger/utilities/common_exports.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          textAlign: TextAlign.center,
          style: context.textTheme.displayLarge?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          AppConstants.appTagline,
          textAlign: TextAlign.center,
          style: context.textTheme.titleMedium?.copyWith(
            color: AppColors.lightGray,
          ),
        ),
        const SizedBox(height: 64),

        Text(
          AppConstants.welcome,
          textAlign: TextAlign.center,
          style: context.textTheme.displayMedium?.copyWith(
            color: AppColors.black,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          AppConstants.signInToContinue,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
