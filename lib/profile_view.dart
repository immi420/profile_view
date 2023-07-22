library profile_view;

import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final CircleAvatar child;

  const ProfileView({super.key, required this.child});

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
                      child: child),
                ),
              );
            });
      },
      child: child,
    );
  }
}
