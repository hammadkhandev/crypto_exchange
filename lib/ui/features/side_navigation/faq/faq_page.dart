import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'faq_controller.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  FAQPageState createState() => FAQPageState();
}

class FAQPageState extends State<FAQPage> {
  final FAQController _controller = Get.put(FAQController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getFAQList(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BGViewMain(
            child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
        child: Column(
          children: [appBarBackWithActions(title: "FAQ".tr), _faqList()],
        ),
      ),
    )));
  }

  Widget _faqList() {
    return Obx(() {
      return _controller.faqList.isEmpty
          ? handleEmptyViewWithLoading(_controller.isLoading)
          : Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _controller.faqList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_controller.hasMoreData && index == (_controller.faqList.length - 1)) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getFAQList(true));
                  }
                  return faqItem(_controller.faqList[index]);
                },
              ),
            );
    });
  }


}
