import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class unEventLoading {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          color: Colors.transparent,
          child: Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: Color(0xFF41E4A9),
              rightDotColor: Color(0xffE83094),
              size: 100,
            ),
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
