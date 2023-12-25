import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/blog_news.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'news_controller.dart';
import 'news_details_view.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  final NewsController _controller = Get.put(NewsController());

  @override
  void initState() {
    _controller.selectedCategory.value = -1;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getNewsListType(BlogNewsType.popular);
      _controller.getNewsCategories();
      _controller.getNewsListType(BlogNewsType.recent);
      _controller.getNewsSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
            child: Column(
              children: [
                appBarBackWithActions(title: "News".tr),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: false,
                          toolbarHeight: 40,
                          flexibleSpace: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid, vertical: Dimens.paddingMin),
                            child: textAutoSizeKarla("Top News".tr, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeLarge),
                          )),
                      Obx(() => _getTopNewsView(_controller.featureNewsList)),
                      Obx(() => _getNewsCategoryView(_controller.newsCategories, _controller.selectedCategory.value)),
                      Obx(() {
                        return _controller.newsList.isEmpty
                            ? SliverFillRemaining(child: handleEmptyViewWithLoading(_controller.isLoading.value))
                            : SliverPadding(
                                padding: const EdgeInsets.all(Dimens.paddingMid),
                                sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                  childCount: _controller.newsList.length,
                                  (context, index) {
                                    if (_controller.selectedCategory.value != -1 &&
                                        _controller.hasMoreData &&
                                        index == (_controller.newsList.length - 1)) {
                                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getNewsListByCategory(true));
                                    }
                                    return NewsItemView(news: _controller.newsList[index]);
                                  },
                                )));
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getTopNewsView(List<News> tList) {
    if (tList.isValid) {
      final height = context.width * 0.5;
      return SliverAppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: height,
        flexibleSpace: CarouselSlider.builder(
            itemCount: tList.length,
            itemBuilder: (context, index, realIndex) {
              return showImageNetwork(
                imagePath: tList[index].thumbnail,
                width: double.infinity,
                height: height,
                boxFit: BoxFit.cover,
                onPressCallback: () => showBottomSheetFullScreen(context, NewsDetailsView(news: tList[index]), title: "News Details".tr),
              );
            },
            options: CarouselOptions(
                enlargeCenterPage: true, height: height, viewportFraction: 0.8, autoPlay: true, autoPlayInterval: const Duration(seconds: 3))),
      );
    } else {
      return const SliverAppBar(backgroundColor: Colors.transparent, automaticallyImplyLeading: false, toolbarHeight: 0);
    }
  }

  _getNewsCategoryView(List<BlogNewsCategory> cList, int selected) {
    if (cList.isValid) {
      return SliverAppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        pinned: true,
        flexibleSpace: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid, horizontal: Dimens.paddingMin),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = cList[index];
              final bgColor = selected == index ? context.theme.focusColor.withOpacity(0.5) : Colors.transparent;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMin),
                child: buttonText(category.title ?? "", bgColor: bgColor, textColor: context.theme.primaryColor, fontSize: Dimens.regularFontSizeMid,
                    onPressCallback: () {
                  _controller.selectedCategory.value = index;
                  _controller.getNewsListByCategory(false);
                }),
              );
            },
            itemCount: cList.length),
      );
    } else {
      return const SliverAppBar(backgroundColor: Colors.transparent, automaticallyImplyLeading: false, toolbarHeight: 0);
    }
  }
}

class NewsItemView extends StatelessWidget {
  const NewsItemView({super.key, required this.news});

  final News news;

  @override
  Widget build(BuildContext context) {
    final width = (context.width - 20) / 3;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showBottomSheetFullScreen(context, NewsDetailsView(news: news), title: "News Details".tr),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showImageNetwork(imagePath: news.thumbnail, width: width, height: width, boxFit: BoxFit.cover),
              hSpacer5(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textAutoSizeKarla(news.title ?? "", fontSize: Dimens.regularFontSizeMid, maxLines: 2, textAlign: TextAlign.start),
                    vSpacer5(),
                    textAutoSizePoppins(news.description ?? "", textAlign: TextAlign.start, maxLines: 3),
                    vSpacer5(),
                    Align(
                        alignment: Alignment.centerRight,
                        child: textAutoSizePoppins(formatDate(news.updatedAt, format: dateFormatMMMMDddYyy), color: context.theme.primaryColor)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
