import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/blog_news.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'blog_controller.dart';
import 'blog_details_view.dart';

class BlogSearchView extends StatefulWidget {
  const BlogSearchView({Key? key}) : super(key: key);

  @override
  BlogSearchViewState createState() => BlogSearchViewState();
}

class BlogSearchViewState extends State<BlogSearchView> {
  final _controller = Get.find<BlogController>();
  RxList<Blog> blogList = <Blog>[].obs;
  RxBool isLoading = false.obs;
  Timer? _searchTimer;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          textFieldSearch(onTextChange: _onTextChanged),
          Obx(() {
            return blogList.isEmpty
                ? handleEmptyViewWithLoading(isLoading.value)
                : Expanded(
                    child: ListView(
                    children: List.generate(blogList.length, (index) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => showBottomSheetFullScreen(context, BlogDetailsView(blog: blogList[index]), title: "Blog Details".tr),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textAutoSizeKarla(blogList[index].title ?? "",
                                    maxLines: 3, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
                                dividerHorizontal()
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ));
          }),
        ],
      ),
    );
  }

  void _onTextChanged(String text) {
    if (_searchTimer?.isActive ?? false) _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(seconds: 1), () => _getSearchData(text));
  }

  void _getSearchData(String text) {
    blogList.clear();
    if (text.isEmpty) return;
    isLoading.value = true;
    _controller.getBlogSearchData(text, (data) {
      isLoading.value = false;
      blogList.value = data;
    });
  }
}
