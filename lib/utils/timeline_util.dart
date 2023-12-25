import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';

class TimeLine {
  TimelineTile buildTimelineTile({
    required String startText,
    required String title,
    required String subtitle,
    // required String message,
    bool isLast = false,
    bool isFirst = false,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      beforeLineStyle: LineStyle(color: Get.theme.primaryColor, thickness: 1),
      indicatorStyle:
          const IndicatorStyle(indicatorXY: 0.3, drawGap: true, width: Dimens.iconSizeMin, height: Dimens.iconSizeMin, indicator: _IconIndicator()),
      isLast: isLast,
      isFirst: isFirst,
      startChild: Center(child: Container(alignment: const Alignment(0.0, -0.50), child: Text(startText, style: Get.textTheme.bodyMedium))),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Get.textTheme.bodyLarge!.copyWith(fontSize: Dimens.regularFontSizeMid)),
            const SizedBox(height: 4),
            Text(subtitle, style: Get.textTheme.bodyMedium),
            // const SizedBox(height: 4),
            // Text(message, style: Get.textTheme.bodyMedium)
          ],
        ),
      ),
    );
  }
}

class _IconIndicator extends StatelessWidget {
  const _IconIndicator({Key? key}) : super(key: key);

  // final IconData? iconData;
  // final double? size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Get.theme.primaryColorDark)),
        Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                    height: Dimens.iconSizeMid,
                    width: Dimens.iconSizeMid,
                    child: Icon(Icons.circle, color: Get.theme.primaryColorDark)))),
      ],
    );
  }
}
