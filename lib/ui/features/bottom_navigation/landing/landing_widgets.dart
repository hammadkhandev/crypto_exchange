import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/settings.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

class AnnouncementItemView extends StatelessWidget {
  const AnnouncementItemView({super.key, required this.announcement, required this.onTap});

  final Announcement announcement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.paddingMin),
      child: InkWell(
        onTap: onTap,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          showImageAsset(icon: Icons.campaign_outlined, iconSize: Dimens.iconSizeMid),
          hSpacer5(),
          Expanded(child: textAutoSizePoppins(announcement.title ?? "", maxLines: 3, color: context.theme.primaryColor, textAlign: TextAlign.start)),
        ]),
      ),
    );
  }
}

class AnnouncementDetailsView extends StatelessWidget {
  const AnnouncementDetailsView({super.key, required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final dateText = "${"Last revised".tr}: ${formatDate(announcement.updatedAt, format: dateTimeFormatDdMMMMYyyyHhMm)}";
    return Flexible(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
        children: [
          vSpacer10(),
          textAutoSizeKarla(announcement.title ?? "", maxLines: 5, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeLarge),
          vSpacer5(),
          textAutoSizePoppins(dateText, textAlign: TextAlign.start),
          if (announcement.image.isValid)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
              child: showImageNetwork(
                  imagePath: announcement.image, height: Get.width / 2, width: Get.width, boxFit: BoxFit.cover, padding: Dimens.paddingMin),
            ),
          vSpacer10(),
          Padding(
            padding: const EdgeInsets.all(Dimens.paddingMid),
            child: HtmlWidget(announcement.description ?? "", onLoadingBuilder: (context, element, loadingProgress) => showLoadingSmall()),
          ),
        ],
      ),
    );
  }
}

class MarketTrendItemView extends StatelessWidget {
  const MarketTrendItemView({super.key, required this.coin});

  final CoinPair coin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMin),
      child: Row(children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              showImageNetwork(imagePath: coin.icon, width: Dimens.iconSizeMin, height: Dimens.iconSizeMin),
              hSpacer5(),
              Expanded(
                  child: textAutoSizeKarla(coin.getCoinPairName(),
                      fontSize: Dimens.regularFontSizeExtraMid, maxLines: 2, textAlign: TextAlign.start)),
            ],
          ),
        ),
        hSpacer5(),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              textAutoSizePoppins(coin.lastPrice ?? "0", color: context.theme.primaryColor),
              textAutoSizePoppins("${coinFormat(coin.priceChange)}%", color: getNumberColor(coin.priceChange)),
            ],
          ),
        ),
        hSpacer5(),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {
              coin.coinPair = coin.getCoinPairKey();
              getDashboardController().selectedCoinPair.value = coin;
              getRootController().changeBottomNavIndex(0, false);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                textAutoSizePoppins(coinFormat(coin.volume), color: context.theme.primaryColor),
                buttonText("Trade".tr, visualDensity: minimumVisualDensity)
              ],
            ),
          ),
        )
      ]),
    );
  }
}
