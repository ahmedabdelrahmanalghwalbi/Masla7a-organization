import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';
import '../../../../utils/size_config.dart';

class SplashBackButton extends StatelessWidget {
  SplashBackButton({
    required this.pageController,
    this.animationController,
  });

  final PageController pageController;
  final AnimationController? animationController;

  late final Animation<Offset> _offset =
      Tween<Offset>(begin: Offset(-1.5, 0.0), end: Offset(0.0, 0.0))
          .animate(animationController!);

  void _perviousSlide(PageController controller) {
    controller.previousPage(
      duration: kAnimationDuration,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: kPrimaryColor,
        ),
        onPressed: () {
          _perviousSlide(pageController);
          print('Back');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20.0,
              ),
              Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(16),
                  letterSpacing: 0.75,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
