import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/models/blog_news.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'news_controller.dart';
import 'news_screen.dart';

class NewsDetailsView extends StatefulWidget {
  const NewsDetailsView({Key? key, required this.news}) : super(key: key);
  final News news;

  @override
  NewsDetailsViewState createState() => NewsDetailsViewState();
}

class NewsDetailsViewState extends State<NewsDetailsView> {
  final _controller = Get.find<NewsController>();
  Rx<NewsDetails> newsDetails = NewsDetails().obs;
  bool isLoading = true;

  @override
  void initState() {
    newsDetails.value.details = widget.news;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getNewsDetailsData(widget.news.slug ?? "", (details) {
        isLoading = false;
        if (details != null) newsDetails.value = details;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final news = newsDetails.value.details;
      List<News> relatedList = [];
      if (newsDetails.value.related?.data != null) {
        relatedList = List<News>.from(newsDetails.value.related!.data.map((x) => News.fromJson(x)));
      }
      return Expanded(
        child: ListView(
          padding: const EdgeInsets.all(Dimens.paddingMid),
          children: [
            showImageNetwork(imagePath: news?.thumbnail, width: context.width - 20, boxFit: BoxFit.fitWidth),
            vSpacer10(),
            textAutoSizeKarla(news?.title ?? "", fontSize: Dimens.regularFontSizeLarge, textAlign: TextAlign.start, maxLines: 10),
            vSpacer5(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textAutoSizePoppins(formatDate(news?.updatedAt, format: dateTimeFormatDdMMMMYyyyHhMm), textAlign: TextAlign.end),
                buttonText("Share".tr,
                    borderColor: context.theme.focusColor,
                    bgColor: Colors.transparent,
                    textColor: context.theme.primaryColor,
                    visualDensity: VisualDensity.compact,
                    onPressCallback: () => shareText(URLConstants.blogShare + (news?.slug ?? "")))
              ],
            ),
            vSpacer20(),
            isLoading
                ? showLoadingSmall()
                : HtmlWidget(news?.body ?? "", onLoadingBuilder: (context, element, loadingProgress) => showLoadingSmall()),
            vSpacer10(),
            if (relatedList.isNotEmpty) Align(alignment: Alignment.centerLeft, child: textAutoSizeKarla("More News".tr)),
            if (relatedList.isNotEmpty) Column(children: List.generate(relatedList.length, (index) => NewsItemView(news: relatedList[index]))),
          ],
        ),
      );
    });
  }
}
