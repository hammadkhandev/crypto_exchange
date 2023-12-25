import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';


class FAQController extends GetxController {
  List<FAQ> faqList = <FAQ>[].obs;
  bool isLoading = true;
  int loadedPage = 0;
  bool hasMoreData = true;

  void getFAQList(bool isFromLoadMore) {
    if (!isFromLoadMore) {
      loadedPage = 0;
      hasMoreData = true;
      faqList.clear();
      isLoading = false;
    }
    isLoading = true;
    loadedPage++;
    APIRepository().getFAQList(loadedPage).then((resp) {
      isLoading = false;
      if (resp.success) {
        ListResponse response = ListResponse.fromJson(resp.data);
        if (response.data != null) {
          List<FAQ> list = List<FAQ>.from(response.data!.map((x) => FAQ.fromJson(x)));
          faqList.addAll(list);
        }
        loadedPage = response.currentPage ?? 0;
        hasMoreData = response.nextPageUrl != null;
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading = false;
      showToast(err.toString());
    });
  }
}
