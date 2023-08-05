library profile_view;

import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final ImageProvider<Object> image;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool circle;

  /// ## [ProfileView]
  ///  [ProfileView] is Widget that is used to show profiles and pictures in Enlarge way.
  ///  * Required Parameters:
  ///  [image] e.g NetworkImage(url)
  /// * Optional Parameters:
  /// [circle] e.g true/false (default value is true).
  ///
  /// [borderRadius] e.g 8.0 (default is 0 if not added)
  /// border radius only work if [circle] is false.
  ///
  /// [height] e.g double 30.0 (default is 50 if not added).
  ///
  /// [width] e.g double 30.0 (default is 50 if not added).
  ///

  const ProfileView({
    super.key,
    required this.image,
    this.height = 50,
    this.width = 50,
    this.circle = true,
    this.borderRadius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
              barrierColor: Colors.transparent,
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 6,
                    sigmaY: 6,
                  ),
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    backgroundColor: Colors.red,
                    elevation: 0,
                    shape: const CircleBorder(),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.29,
                      child: CircleAvatar(
                        backgroundImage: image,
                      ),
                    ),
                  ),
                );
              });
        },
        child: displayWidget());
  }

  Widget displayWidget() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circle ? null : BorderRadius.circular(borderRadius!),
          image: DecorationImage(image: image, fit: BoxFit.cover)),
    );
  }
}
