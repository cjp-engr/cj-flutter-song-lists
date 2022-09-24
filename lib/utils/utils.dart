import 'package:cj_itunes_artist/utils/size_config.dart';
import 'package:flutter/material.dart';

class Utils {
  static double size(BuildContext context, double mobileSize, double tabletSize,
      double desktopSize) {
    return SizeConfig.isSmallScreen(context)
        ? mobileSize
        : SizeConfig.isMediumScreen(context)
            ? tabletSize
            : desktopSize;
  }
}
