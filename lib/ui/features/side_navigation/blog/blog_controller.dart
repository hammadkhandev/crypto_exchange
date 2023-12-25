import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/blog_news.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';

class BlogController extends GetxController {
  Rx<BlogNewsSettings> blogSettings = BlogNewsSettings().obs;
  RxList<BNCategoryWithSub> blogCategories = <BNCategoryWithSub>[].obs;
  RxList<Blog> featureBlogList = <Blog>[].obs;
  RxList<Blog> blogList = <Blog>[].obs;
  RxInt selectedCategory = 0.obs;
  RxBool isLoading = true.obs;
  int loadedPage = 0;
  bool hasMoreData = false;

  void getBlogSettings() {
    APIRepository().getBlogNewsSettings().then((resp) {
      if (resp.success) {
        blogSettings.value = BlogNewsSettings.fromJson(resp.data);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void getBlogCategories() {
    APIRepository().getBlogCategoryList().then((resp) {
      if (resp.success) {
        blogCategories.value = List<BNCategoryWithSub>.from(resp.data.map((x) => BNCategoryWithSub.fromJson(x)));
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void getBlogListType(int type) {
    final limit = type == BlogNewsType.feature ? DefaultValue.listLimitMedium : DefaultValue.listLimitLarge;
    APIRepository().getBlogListType(type, limit, 1).then((resp) {
      if (resp.success) {
        final listResp = ListResponse.fromJson(resp.data);
        if (type == BlogNewsType.feature) {
          featureBlogList.value = List<Blog>.from(listResp.data.map((x) => Blog.fromJson(x)));
        } else {
          isLoading.value = false;
          blogList.value = List<Blog>.from(listResp.data.map((x) => Blog.fromJson(x)));
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

  void getBlogListByCategory(bool isFromLoadMore) {
    if (selectedCategory.value == -1) return;

    if (!isFromLoadMore) {
      loadedPage = 0;
      hasMoreData = false;
      blogList.clear();
    }
    isLoading.value = true;
    loadedPage++;
    final category = blogCategories[selectedCategory.value];
    APIRepository().getBlogListCategory(category.id ?? "", DefaultValue.listLimitLarge, loadedPage).then((resp) {
      isLoading.value = false;
      if (resp.success) {
        ListResponse listResp = ListResponse.fromJson(resp.data);
        if (listResp.data != null) {
          final list = List<Blog>.from(listResp.data.map((x) => Blog.fromJson(x)));
          blogList.addAll(list);
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

  void getBlogSearchData(String query, Function(List<Blog>) onSearchData) {
    APIRepository().getBlogSearch(query).then((resp) {
      if (resp.success) {
        final list = List<Blog>.from(resp.data.map((x) => Blog.fromJson(x)));
        onSearchData(list);
      } else {
        showToast(resp.message);
        onSearchData([]);
      }
    }, onError: (err) {
      showToast(err.toString());
      onSearchData([]);
    });
  }

  void getBlogDetailsData(String slug, Function(BlogDetails?) onDetailsData) {
    APIRepository().getBlogDetails(slug).then((resp) {
      if (resp.success) {
        final details = BlogDetails.fromJson(resp.data);
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
