import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'shimmer_placeholders.dart';

class ShimmerViewLanding extends StatelessWidget {
  const ShimmerViewLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: const SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 15),
              TitlePlaceholder(width: double.infinity),
              BannerPlaceholder(),
              TitlePlaceholder(width: double.infinity),
              SizedBox(height: 5),
              TitlePlaceholder(width: double.infinity),
              SizedBox(height: 15),
              SliderPlaceholder(),
              SizedBox(height: 15),
              ContentPlaceholder(lineType: ContentLineType.twoLines),
              SizedBox(height: 15),
              ContentPlaceholder(lineType: ContentLineType.twoLines),
              SizedBox(height: 15),
              ContentPlaceholder(lineType: ContentLineType.twoLines),
              SizedBox(height: 15),
              ContentPlaceholder(lineType: ContentLineType.twoLines),
              SizedBox(height: 15),
              ContentPlaceholder(lineType: ContentLineType.twoLines),
            ],
          ),
        ));
  }
}
