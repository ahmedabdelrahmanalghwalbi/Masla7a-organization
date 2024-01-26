import 'package:flutter/material.dart';

import '../../../../utils/size_config.dart';

class SplashSkipButton extends StatelessWidget {
  SplashSkipButton({
    required this.animationController,
    required this.pageController,
    required this.pages,
  });

  final AnimationController animationController;
  final PageController pageController;
  final List pages;

  late final Animation<Offset> _offset =
      Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
          .animate(animationController);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: () {
            pageController.animateToPage(
              pages.length - 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeIn,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: getProportionateScreenWidth(16),
                    letterSpacing: 0.75,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: 18.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
