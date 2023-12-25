import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/ui/features/root/root_controller.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import '../../data/local/constants.dart';
import '../ui/features/notifications/notifications_page.dart';
import 'button_util.dart';
import 'decorations.dart';
import 'dimens.dart';

AppBar appBarMain(BuildContext context, {String? title, IconData? subActionIcon, VoidCallback? subIconPress}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    leading: buttonOnlyIcon(
        iconPath: AssetConstants.icMenu, iconColor: context.theme.primaryColor, onPressCallback: () => Scaffold.of(context).openDrawer()),
    title: textAutoSizeTitle(title ?? "", fontSize: Dimens.regularFontSizeLarge),
    actions: [
      if (subActionIcon != null)
        buttonOnlyIcon(
            iconData: subActionIcon,
            iconColor: context.theme.primaryColor,
            size: Dimens.iconSizeMid,
            onPressCallback: subIconPress,
            visualDensity: minimumVisualDensity),
      Stack(alignment: Alignment.center, children: [
        buttonOnlyIcon(
            iconPath: AssetConstants.icNotification,
            iconColor: context.theme.primaryColor,
            size: Dimens.iconSizeMid,
            visualDensity: minimumVisualDensity,
            onPressCallback: () => Get.to(() => const NotificationsPage())),
        Obx(() {
          int count = Get.find<RootController>().notificationCount.value;
          return count > 0
              ? Positioned(
                  right: 10,
                  top: 5,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: boxDecorationRoundCorner(color: context.theme.primaryColorLight, radius: 10),
                    height: 20,
                    width: 20,
                    padding: const EdgeInsets.all(2),
                    child: AutoSizeText(count.toString(),
                        minFontSize: 5,
                        style: Get.textTheme.bodyMedium!.copyWith(color: context.theme.colorScheme.background),
                        textAlign: TextAlign.center),
                  ),
                )
              : const SizedBox();
        }),
      ]),
      hSpacer10(),
    ],
  );
}

AppBar appBarBackWithActions({String? title, List<String>? actionIcons, Function(int)? onPress, double? fontSize}) {
  return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading:
          buttonOnlyIcon(onPressCallback: () => Get.back(), iconPath: AssetConstants.icArrowLeft, size: 22, iconColor: Get.theme.primaryColorDark),
      title: textAutoSizeTitle(title ?? "", fontSize: fontSize ?? Dimens.regularFontSizeLarge),
      actions: (actionIcons == null || actionIcons.isEmpty)
          ? [const SizedBox(width: 25)]
          : List.generate(actionIcons.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: buttonOnlyIcon(
                    size: 25,
                    onPressCallback: () => onPress != null ? onPress(index) : null,
                    iconPath: actionIcons[index],
                    iconColor: Get.theme.primaryColorDark),
              );
            }));
}

TabBar tabBarUnderline(List<String> titles, TabController? controller,
    {Function(int)? onTap,
    bool isScrollable = false,
    TabBarIndicatorSize indicatorSize = TabBarIndicatorSize.tab,
    Color? indicatorColor,
    double? fontSize}) {
  return TabBar(
    controller: controller,
    isScrollable: isScrollable,
    labelColor: Get.theme.primaryColor,
    unselectedLabelColor: Get.theme.primaryColorLight,
    indicatorColor: indicatorColor ?? Get.theme.primaryColor,
    indicatorSize: indicatorSize,
    tabs: List.generate(titles.length, (index) => Tab(child: textAutoSizeKarla(titles[index], fontSize: fontSize ?? Dimens.regularFontSizeLarge))),
    onTap: (index) => onTap == null ? () {} : onTap(index),
  );
}

TabBar tabBarFill(List<String> titles, TabController? controller, {Function(int)? onTap}) {
  return TabBar(
    isScrollable: true,
    controller: controller,
    labelColor: Get.theme.colorScheme.background,
    unselectedLabelColor: Get.theme.primaryColor,
    indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusCornerMid),
        color: Get.theme.colorScheme.secondary,
        border: Border.all(color: Get.theme.colorScheme.secondary)),
    indicatorSize: TabBarIndicatorSize.tab,
    tabs: List.generate(titles.length, (index) => Tab(height: 35, child: Text(titles[index]))),
    onTap: (index) => onTap == null ? () {} : onTap(index),
  );
}

Widget tabBarText(List<String> titles, int selectedIndex, Function(int) onTap, {Color? selectedColor, double? fontSize}) {
  selectedColor = selectedColor ?? Colors.green;
  return Row(
      children: List.generate(
          titles.length,
          (index) => InkWell(
                onTap: () => onTap(index),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.paddingMin),
                  child: textAutoSizeKarla(titles[index],
                      fontSize: fontSize ?? Dimens.regularFontSizeMid, color: index == selectedIndex ? selectedColor : null),
                ),
              )));
}
