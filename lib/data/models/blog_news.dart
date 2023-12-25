import 'package:tradexpro_flutter/data/models/list_response.dart';

class BlogNewsSettings {
  String? blogCommentEnable;
  String? blogAutoCommentApproval;
  String? newsCommentEnable;
  String? newsAutoCommentApproval;
  String? blogFeatureEnable;
  String? blogFeatureHeading;
  String? blogFeatureDescription;
  String? blogSearchEnable;

  BlogNewsSettings({
    this.blogCommentEnable,
    this.blogAutoCommentApproval,
    this.newsCommentEnable,
    this.newsAutoCommentApproval,
    this.blogFeatureEnable,
    this.blogFeatureHeading,
    this.blogFeatureDescription,
    this.blogSearchEnable,
  });

  factory BlogNewsSettings.fromJson(Map<String, dynamic> json) => BlogNewsSettings(
        blogCommentEnable: json["blog_comment_enable"],
        blogAutoCommentApproval: json["blog_auto_comment_approval"],
        newsCommentEnable: json["news_comment_enable"],
        newsAutoCommentApproval: json["news_auto_comment_approval"],
        blogFeatureEnable: json["blog_feature_enable"],
        blogFeatureHeading: json["blog_feature_heading"],
        blogFeatureDescription: json["blog_feature_description"],
        blogSearchEnable: json["blog_search_enable"],
      );
}

class BNCategoryWithSub {
  String? id;
  String? title;
  List<BlogNewsCategory>? sub;

  BNCategoryWithSub({this.id, this.title, this.sub});

  factory BNCategoryWithSub.fromJson(Map<String, dynamic> json) => BNCategoryWithSub(
        id: json["id"],
        title: json["title"],
        sub: json["sub"] == null ? null : List<BlogNewsCategory>.from(json["sub"].map((x) => BlogNewsCategory.fromJson(x))),
      );
}

class BlogNewsCategory {
  String? id;
  String? title;

  BlogNewsCategory({this.id, this.title});

  factory BlogNewsCategory.fromJson(Map<String, dynamic> json) => BlogNewsCategory(
        id: json["id"],
        title: json["title"],
      );
}

class Blog {
  int? id;
  String? title;
  String? slug;
  String? thumbnail;
  int? category;
  int? subCategory;
  String? body;
  String? keywords;
  String? description;
  int? status;
  DateTime? publishAt;
  int? publish;
  int? commentAllow;
  int? views;
  int? isFetured;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? postId;
  List<dynamic>? translationBlogPost;

  Blog({
    this.id,
    this.title,
    this.slug,
    this.thumbnail,
    this.category,
    this.subCategory,
    this.body,
    this.keywords,
    this.description,
    this.status,
    this.publishAt,
    this.publish,
    this.commentAllow,
    this.views,
    this.isFetured,
    this.createdAt,
    this.updatedAt,
    this.postId,
    this.translationBlogPost,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        thumbnail: json["thumbnail"],
        category: json["category"],
        subCategory: json["sub_category"],
        body: json["body"],
        keywords: json["keywords"],
        description: json["description"],
        status: json["status"],
        publishAt: DateTime.parse(json["publish_at"]),
        publish: json["publish"],
        commentAllow: json["comment_allow"],
        views: json["views"],
        isFetured: json["is_fetured"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        postId: json["post_id"],
        translationBlogPost: List<dynamic>.from(json["translation_blog_post"].map((x) => x)),
      );
}

class BlogDetails {
  ListResponse? related;
  Blog? details;
  List<dynamic>? comments;

  BlogDetails({
    this.related,
    this.details,
    this.comments,
  });

  factory BlogDetails.fromJson(Map<String, dynamic> json) => BlogDetails(
        related: json["related"] == null ? null : ListResponse.fromJson(json["related"]),
        details: json["details"] == null ? null : Blog.fromJson(json["details"]),
        comments: json["comments"] == null ? null : List<dynamic>.from(json["comments"].map((x) => x)),
      );
}

class News {
  int? id;
  String? title;
  String? slug;
  String? thumbnail;
  int? category;
  int? subCategory;
  String? body;
  String? keywords;
  String? description;
  int? status;
  DateTime? publishAt;
  int? publish;
  int? commentAllow;
  int? views;
  int? isFetured;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? postId;
  List<dynamic>? translationNewsPost;

  News({
    this.id,
    this.title,
    this.slug,
    this.thumbnail,
    this.category,
    this.subCategory,
    this.body,
    this.keywords,
    this.description,
    this.status,
    this.publishAt,
    this.publish,
    this.commentAllow,
    this.views,
    this.isFetured,
    this.createdAt,
    this.updatedAt,
    this.postId,
    this.translationNewsPost,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    thumbnail: json["thumbnail"],
    category: json["category"],
    subCategory: json["sub_category"],
    body: json["body"],
    keywords: json["keywords"],
    description: json["description"],
    status: json["status"],
    publishAt: DateTime.parse(json["publish_at"]),
    publish: json["publish"],
    commentAllow: json["comment_allow"],
    views: json["views"],
    isFetured: json["is_fetured"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    postId: json["post_id"],
    translationNewsPost: List<dynamic>.from(json["translation_news_post"].map((x) => x)),
  );
}

class NewsDetails {
  ListResponse? related;
  News? details;
  List<dynamic>? comments;

  NewsDetails({
    this.related,
    this.details,
    this.comments,
  });

  factory NewsDetails.fromJson(Map<String, dynamic> json) => NewsDetails(
    related: json["related"] == null ? null : ListResponse.fromJson(json["related"]),
    details: json["details"] == null ? null : News.fromJson(json["details"]),
    comments: json["comments"] == null ? null : List<dynamic>.from(json["comments"].map((x) => x)),
  );
}