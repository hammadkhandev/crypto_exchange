import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/colors.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

class ColorItemView extends StatelessWidget {
  const ColorItemView(this.title, this.cList, this.isSelect, this.isList, this.onTap, {Key? key}) : super(key: key);
  final String title;
  final VoidCallback onTap;
  final List<Color> cList;
  final bool isSelect;
  final bool isList;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Dimens.paddingMid, horizontal: isList ? Dimens.paddingMid : 0),
          decoration: isSelect ? boxDecorationRoundBorder(borderColor: Theme.of(context).focusColor, color: Colors.transparent) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textAutoSizeKarla(title, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMid),
              Row(
                children: [
                  ClipOval(child: Container(height: Dimens.iconSizeMin, width: Dimens.iconSizeMin, color: cList[0])),
                  hSpacer5(),
                  ClipOval(child: Container(height: Dimens.iconSizeMin, width: Dimens.iconSizeMin, color: cList[1])),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PreferenceItemView extends StatelessWidget {
  const PreferenceItemView(this.title, this.index, this.isSelect, this.isList, this.onTap, {Key? key}) : super(key: key);
  final String title;
  final VoidCallback onTap;
  final bool isSelect;
  final bool isList;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cIndex = GetStorage().read(PreferenceKey.buySellColorIndex);
    final colors = bsColorList[cIndex];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Dimens.paddingMid, horizontal: isList ? Dimens.paddingMid : 0),
          decoration: isSelect ? boxDecorationRoundBorder(borderColor: Theme.of(context).focusColor, color: Colors.transparent) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textAutoSizeKarla(title, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMid),
              Row(
                children: [
                  Icon(Icons.arrow_upward, size: Dimens.iconSizeMin, color: index == 0 ? colors[0] : colors[1]),
                  Icon(Icons.arrow_downward, size: Dimens.iconSizeMin, color: index == 0 ? colors[1] : colors[0]),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
