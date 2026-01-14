import 'package:repalogic_messanger/utilities/common_exports.dart';

class EmptySearchList extends StatelessWidget {
  final String searchQuery;
  const EmptySearchList({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.people_outline,
            size: 80,
            color: AppColors.lightGray,
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty
                ? AppConstants.noUsersAvailable
                : AppConstants.noUsersFound,
            style: context.textTheme.titleMedium?.copyWith(
              color: AppColors.lightGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isEmpty
                ? AppConstants.allUsersAlreadyInRoom
                : AppConstants.tryDifferentQuery,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
