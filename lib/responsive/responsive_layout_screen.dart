import 'package:flutter/material.dart';
import 'package:instagram_flutter/Utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth > webScreenSize) {
        return webScreenLayout;
      }
      return mobileScreenLayout;
    });
  }
}
