import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final String? titleText;
  final Widget? titleWidget;  // Added back the titleWidget parameter
  final double? elevation;
  final bool useLogo;
  final TextStyle? titleStyle;
  final String logoAssetPath;

  const CustomAppBar({
    super.key,
    this.backgroundColor,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.titleText,
    this.titleWidget,  // Added to constructor
    this.elevation,
    this.useLogo = true,
    this.titleStyle,
    this.logoAssetPath = 'assets/imin_display_logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      elevation: elevation ?? 0,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      )
          : null,
      title: titleWidget ?? (useLogo
          ? Image.asset(
        logoAssetPath,
        color: Colors.white,
        height: 20,
      )
          : Text(
        titleText ?? '',
        style: titleStyle ??
            const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
      )),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}