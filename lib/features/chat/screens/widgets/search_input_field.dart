import 'package:repalogic_messanger/utilities/common_exports.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final VoidCallback clearSearch;
  final ValueChanged<String> onSearch;
  const SearchInputField({
    super.key,
    required this.searchQuery,
    required this.clearSearch,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: AppConstants.searchUsersHint,
          hintStyle: context.textTheme.bodyMedium,
          prefixIcon: const Icon(Icons.search, color: AppColors.lightGray),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.lightGray),
                  onPressed: clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightGray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: onSearch,
      ),
    );
  }
}
