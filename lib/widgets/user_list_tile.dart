import 'package:repalogic_messanger/utilities/common_exports.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isSelected;

  const UserListTile({
    super.key,
    required this.user,
    this.onTap,
    this.trailing,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        backgroundImage: user.photoUrl != null
            ? NetworkImage(user.photoUrl!)
            : null,
        radius: 24,
        child: user.photoUrl == null
            ? Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toUpperCase()
                    : AppConstants.defaultUserInitial,
                style: context.textTheme.displayMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        user.displayName,
        style: context.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        user.email,
        style: context.textTheme.bodyMedium?.copyWith(fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing:
          trailing ??
          (isSelected
              ? const Icon(Icons.check_circle, color: AppColors.primaryColor)
              : null),
    );
  }
}
