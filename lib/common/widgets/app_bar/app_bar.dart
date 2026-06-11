import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lumi_core/utils/constants/sizes.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.leadingImage,
    this.actions,
    this.bottomBar,
    this.height,
    this.leadingOnPressed,
  });

  final Widget? title;
  final double? height;
  final bool showBackButton;
  final String? leadingImage;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final PreferredSizeWidget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace / 3),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: title,
        leadingWidth: showBackButton ? 25 : null,
        centerTitle: false,
        actions: actions,
        bottom: bottomBar,
        leading: showBackButton
            ? IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left))
            : leadingImage != null
                ? Image.asset(leadingImage!, fit: BoxFit.contain, height: TSizes.lg, width: TSizes.lg)
                : null,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
