import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool isSearchBar;
  final TextEditingController? searchController;
  final VoidCallback? onSearchSubmitted;
  final FocusNode? searchFocusNode;
  final Color? backgroundColor;

  const CustomAppBar({
    Key? key,
    this.title = 'HARK!',
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBackPressed,
    this.isSearchBar = false,
    this.searchController,
    this.onSearchSubmitted,
    this.searchFocusNode,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSearchBar) {
      return _buildSearchAppBar(context);
    }
    return _buildRegularAppBar(context);
  }

  AppBar _buildRegularAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      title: Text(
        title,
        style: AppStyles.headline3.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      )
          : leading ??
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Navigate to search screen
              // Navigator.pushNamed(context, AppRoutes.search);
            },
          ),
      actions: actions,
    );
  }

  AppBar _buildSearchAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor ?? AppColors.primary,
      centerTitle: false,
      title: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        onSubmitted: (_) => onSearchSubmitted?.call(),
        decoration: InputDecoration(
          hintText: 'Search HARK!',
          hintStyle: AppStyles.bodyText2.copyWith(color: Colors.black54),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.black54),
            onPressed: () {
              searchController?.clear();
            },
          ),
        ),
        style: AppStyles.bodyText1.copyWith(color: Colors.black87),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}