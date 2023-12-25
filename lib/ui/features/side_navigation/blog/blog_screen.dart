import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/blog_news.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/blog/blog_details_view.dart';
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
import 'blog_controller.dart';
import 'blog_search_view.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  BlogScreenState createState() => BlogScreenState();
}

class BlogScreenState extends State<BlogScreen> {
  final _controller = Get.put(BlogController());
  late double textScaleFactor;

  @override
  void initState() {
    super.initState();
    _controller.selectedCategory.value = -1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getBlogSettings();
      _controller.getBlogListType(BlogNewsType.feature);
      _controller.getBlogCategories();
      _controller.getBlogListType(BlogNewsType.recent);
    });
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
            child: Column(
              children: [
                Obx(
                  () {
                    final actionList = _controller.blogSettings.value.blogSearchEnable == "1" ? [AssetConstants.icSearch] : <String>[];
                    return appBarBackWithActions(
                        title: "Blog".tr,
                        actionIcons: actionList,
                        onPress: (index) => showBottomSheetFullScreen(context, const BlogSearchView(), title: "Search Your Blog".tr));
                  },
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      Obx(() => _getBlogHeaderView(_controller.blogSettings.value)),
                      Obx(() => _getBlogFeatureView(_controller.blogSettings.value, _controller.featureBlogList)),
                      Obx(() => _getBlogCategoryView(_controller.blogCategories, _controller.selectedCategory.value)),
                      Obx(() {
                        return _controller.blogList.isEmpty
                            ? SliverFillRemaining(child: handleEmptyViewWithLoading(_controller.isLoading.value))
                            : SliverPadding(
                                padding: const EdgeInsets.all(Dimens.paddingMid),
                                sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                  childCount: _controller.blogList.length,
                                  (context, index) {
                                    if (_controller.selectedCategory.value != -1 &&
                                        _controller.hasMoreData &&
                                        index == (_controller.blogList.length - 1)) {
                                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getBlogListByCategory(true));
                                    }
                                    return BlogItemView(blog: _controller.blogList[index]);
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

  _getBlogHeaderView(BlogNewsSettings settings) {
    if (settings.blogFeatureHeading.isValid || settings.blogFeatureDescription.isValid) {
      final width = context.width - 20;
      final titleSize =
          getTextSize(settings.blogFeatureHeading ?? "", context.textTheme.bodyLarge!, maxLine: 3, width: width, scale: textScaleFactor);
      final subSize =
          getTextSize(settings.blogFeatureDescription ?? "", context.textTheme.labelSmall!, maxLine: 10, width: width, scale: textScaleFactor);
      double height = titleSize.height + subSize.height + 20;
      return SliverAppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: height,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(Dimens.paddingMid),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(settings.blogFeatureHeading ?? "",
                textAlign: TextAlign.start, style: context.textTheme.bodyLarge!.copyWith(fontSize: Dimens.regularFontSizeMid), maxLines: 3),
            vSpacer5(),
            Text(settings.blogFeatureDescription ?? "", textAlign: TextAlign.start, maxLines: 10, style: context.textTheme.labelSmall!)
          ]),
        ),
      );
    } else {
      return const SliverAppBar(backgroundColor: Colors.transparent, automaticallyImplyLeading: false, toolbarHeight: 0);
    }
  }

  _getBlogFeatureView(BlogNewsSettings settings, List<Blog> fList) {
    if (settings.blogFeatureEnable == "1" && fList.isValid) {
      final height = context.width * 0.75;
      return SliverAppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: height,
        flexibleSpace: CarouselSlider.builder(
            itemCount: fList.length,
            itemBuilder: (context, index, realIndex) => BlogSliderView(blog: fList[index]),
            options: CarouselOptions(height: height, viewportFraction: 1, autoPlay: true, autoPlayInterval: const Duration(seconds: 3))),
      );
    } else {
      return const SliverAppBar(backgroundColor: Colors.transparent, automaticallyImplyLeading: false, toolbarHeight: 0);
    }
  }

  _getBlogCategoryView(List<BNCategoryWithSub> cList, int selected) {
    if (cList.isValid) {
      return SliverAppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
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
                _controller.getBlogListByCategory(false);
              }),
            );
          },
          itemCount: cList.length,
        ),
      );
    } else {
      return const SliverAppBar(backgroundColor: Colors.transparent, automaticallyImplyLeading: false, toolbarHeight: 0);
    }
  }
}

class BlogItemView extends StatelessWidget {
  const BlogItemView({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    final width = (context.width - 20) / 3;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showBottomSheetFullScreen(context, BlogDetailsView(blog: blog), title: "Blog Details".tr),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showImageNetwork(imagePath: blog.thumbnail, width: width, height: width, boxFit: BoxFit.cover),
              hSpacer5(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textAutoSizeKarla(blog.title ?? "", fontSize: Dimens.regularFontSizeMid, maxLines: 3, textAlign: TextAlign.start),
                    vSpacer5(),
                    textAutoSizePoppins(blog.description ?? "", textAlign: TextAlign.start, maxLines: 3),
                    vSpacer5(),
                    Align(
                        alignment: Alignment.centerRight,
                        child: textAutoSizePoppins(formatDate(blog.updatedAt, format: dateFormatMMMMDddYyy), color: context.theme.primaryColor)),
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

class BlogSliderView extends StatelessWidget {
  const BlogSliderView({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    final height = context.width * 0.45;
    return Container(
      padding: const EdgeInsets.all(Dimens.paddingMid),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showBottomSheetFullScreen(context, BlogDetailsView(blog: blog), title: "Blog Details".tr),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showImageNetwork(imagePath: blog.thumbnail, width: context.width - 20, height: height, boxFit: BoxFit.cover),
              vSpacer5(),
              textAutoSizeKarla(blog.title ?? "", fontSize: Dimens.regularFontSizeLarge, maxLines: 2, textAlign: TextAlign.start),
              vSpacer5(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                hSpacer5(),
                textAutoSizePoppins(formatDate(blog.updatedAt, format: dateTimeFormatDdMMMMYyyyHhMm), textAlign: TextAlign.end)
              ])
            ],
          ),
        ),
      ),
    );
  }
}
