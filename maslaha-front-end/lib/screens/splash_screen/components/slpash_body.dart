import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../utils/size_config.dart';
import '../components/buttons/splash_back_button.dart';
import '../components/buttons/splash_next_button.dart';
import '../components/buttons/splash_skip_button.dart';
import 'buttons/splash_get_started_button.dart';
import 'splash_main_content.dart';

class SplashBody extends StatefulWidget {
  @override
  _SplashBodyState createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _skipButtonAnimationController;
  late final AnimationController _backButtonAnimationController;
  int _currentPageIndex = 0;

  final List<Map<String, String>> _splashData = const [
    {
      "image": "assets/images/splash_images/find_your_service.svg",
      "title": "Find Your Desired Service",
      "description":
          "Wherever you are, whenever you want and whatever you need, you can always find it in our application, where we provide a wide range of services of all kinds (carpentry, plumbing, home services, etc.)."
    },
    {
      "image": "assets/images/splash_images/full_time_support.svg",
      "title": "Full-Time Support",
      "description":
          "We strive to offer all our users a flawless experience using our application, but if you ever have a complaint or problem you can always report to us and we will worked it out as soon as possible."
    },
    {
      "image": "assets/images/splash_images/virtual_workshops.svg",
      "title": "Virtual Workshops",
      "description":
          "If you need a bunch of various services related to one another, instead of hiring different craftsmen or technicians you can find in our workshops multiple related services being provided at a single bundle."
    },
    {
      "image": "assets/images/splash_images/online_payment.svg",
      "title": "Online Payment",
      "description":
          "No cash available at the moment? no worries, we've got you covered, you can pay online with your credit card while booking the service with a money-back guarantee in case of any accidental issue."
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _skipButtonAnimationController =
        AnimationController(vsync: this, duration: kAnimationDuration);
    _backButtonAnimationController =
        AnimationController(vsync: this, duration: kAnimationDuration);
  }

  void _handleButtonsAnimationsDuringPageTransition(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });

    print('current page index: $_currentPageIndex');

    //  Start buttons animation according to slide change
    switch (_currentPageIndex) {
      case 0:
        _backButtonAnimationController.reverse();
        break;
      case 1:
        _backButtonAnimationController.forward();
        break;
      case 2:
        _backButtonAnimationController.forward();
        _skipButtonAnimationController.reverse();
        break;
      case 3:
        _backButtonAnimationController.reverse();
        _skipButtonAnimationController.forward();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _skipButtonAnimationController.dispose();
    _backButtonAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            SplashSkipButton(
              pageController: _pageController,
              animationController: _skipButtonAnimationController,
              pages: _splashData,
            ),
            //  PageView slides.
            Expanded(
              flex: 4,
              child: PageView.builder(
                physics: _currentPageIndex == _splashData.length - 1
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: _handleButtonsAnimationsDuringPageTransition,
                itemCount: _splashData.length,
                itemBuilder: (context, index) => SplashMainContent(
                  image: _splashData[index]["image"] as String,
                  title: _splashData[index]["title"] as String,
                  description: _splashData[index]["description"] as String,
                ),
              ),
            ),
            //  Dots.
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                margin: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(20),
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(),
                    //  Navigation buttons
                    Stack(
                      children: [
                        LayoutBuilder(
                          builder: (_, cons) {
                            return Align(
                              alignment: Alignment.bottomRight,
                              child: AnimatedContainer(
                                height: getProportionateScreenHeight(43),
                                width: _currentPageIndex < 3
                                    ? getProportionateScreenWidth(94)
                                    : cons.biggest.width,
                                duration: kAnimationDuration,
                                child: _currentPageIndex < 3
                                    ? SplashNextButton(
                                        pageController: _pageController)
                                    : SplashGetStartedButton(),
                              ),
                            );
                          },
                        ),
                        SplashBackButton(
                          pageController: _pageController,
                          animationController: _backButtonAnimationController,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Animate the dots.
  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5.0),
      height: getProportionateScreenHeight(7.5),
      width: _currentPageIndex == index ? 20.0 : 6.0,
      decoration: BoxDecoration(
        color: _currentPageIndex == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
