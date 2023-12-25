import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/blog_news.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';

class NewsController extends GetxController {
  Rx<BlogNewsSettings> newsSettings = BlogNewsSettings().obs;
  RxList<BlogNewsCategory> newsCategories = <BlogNewsCategory>[].obs;
  RxList<News> featureNewsList = <News>[].obs;
  RxList<News> newsList = <News>[].obs;
  RxInt selectedCategory = 0.obs;
  RxBool isLoading = true.obs;
  int loadedPage = 0;
  bool hasMoreData = true;

  void getNewsSettings() {
    APIRepository().getBlogNewsSettings().then((resp) {
      if (resp.success) {
        newsSettings.value = BlogNewsSettings.fromJson(resp.data);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void getNewsCategories() {
    APIRepository().getNewsCategoryList().then((resp) {
      if (resp.success) {
        newsCategories.value = List<BlogNewsCategory>.from(resp.data.map((x) => BlogNewsCategory.fromJson(x)));
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void getNewsListType(int type) {
    final limit = type == BlogNewsType.popular ? DefaultValue.listLimitMedium : DefaultValue.listLimitLarge;
    APIRepository().getNewsListType(type, limit, 1).then((resp) {
      if (resp.success) {
        final listResp = ListResponse.fromJson(resp.data);
        if (type == BlogNewsType.popular) {
          featureNewsList.value = List<News>.from(listResp.data.map((x) => News.fromJson(x)));
        } else {
          isLoading.value = false;
          newsList.value = List<News>.from(listResp.data.map((x) => News.fromJson(x)));
        }
      } else {
        isLoading.value = false;
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  void getNewsListByCategory(bool isFromLoadMore) {
    if (selectedCategory.value == -1) return;

    if (!isFromLoadMore) {
      loadedPage = 0;
      hasMoreData = false;
      newsList.clear();
    }
    isLoading.value = true;
    loadedPage++;
    final category = newsCategories[selectedCategory.value];
    APIRepository().getNewsListCategory(category.id ?? "", DefaultValue.listLimitLarge, loadedPage).then((resp) {
      isLoading.value = false;
      if (resp.success) {
        ListResponse listResp = ListResponse.fromJson(resp.data);
        if (listResp.data != null) {
          final list = List<News>.from(listResp.data.map((x) => News.fromJson(x)));
          newsList.addAll(list);
        }
        loadedPage = listResp.currentPage ?? 0;
        hasMoreData = listResp.nextPageUrl != null;
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  void getNewsDetailsData(String slug, Function(NewsDetails?) onDetailsData) {
    APIRepository().getNewsDetails(slug).then((resp) {
      if (resp.success) {
        final details = NewsDetails.fromJson(resp.data);
        onDetailsData(details);
      } else {
        showToast(resp.message);
        onDetailsData(null);
      }
    }, onError: (err) {
      showToast(err.toString());
      onDetailsData(null);
    });
  }
}
