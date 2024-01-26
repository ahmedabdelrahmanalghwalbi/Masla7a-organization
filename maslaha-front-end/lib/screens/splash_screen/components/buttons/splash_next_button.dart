import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';
import '../../../../utils/size_config.dart';

class SplashNextButton extends StatelessWidget {
  const SplashNextButton({
    required this.pageController,
  });

  final PageController pageController;

  void _nextSlide(PageController controller) {
    controller.nextPage(
      duration: kAnimationDuration,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: kPrimaryColor,
      ),
      onPressed: () {
        _nextSlide(pageController);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(16),
                letterSpacing: 0.75,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
