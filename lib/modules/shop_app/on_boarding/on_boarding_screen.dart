import 'package:flutter/material.dart';
import 'package:login_screen/modules/shop_app/login/shop_login_screen.dart';
import 'package:login_screen/shared/components/components.dart';
import 'package:login_screen/shared/network/local/cache_helper.dart';
import 'package:login_screen/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController boardController = PageController();
  bool isLast = false;

  void submit() {
    CacheHelper.saveData(key: "onBoarding", value: true).then((value) {
      if (value) {
        navigateAndFinish(context, ShopLoginScreen());
      }
    });
  }

  List<BoardingModel> boarding = [
    BoardingModel(
        image: "assets/images/onboard_1.jpg",
        title: "On Board Title 1",
        body: "On Board Title Body 1"),
    BoardingModel(
        image: "assets/images/onboard_1.jpg",
        title: "On Board Title 2",
        body: "On Board Title Body 2"),
    BoardingModel(
        image: "assets/images/onboard_1.jpg",
        title: "On Board Title 3",
        body: "On Board Title Body 3"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [defaultTextButton(function: () => submit(), text: "skip")],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: boarding.length,
                  effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: defaultColor,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5.0),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardController.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(image: AssetImage(model.image)),
          ),
          const SizedBox(height: 30.0),
          Text(
            model.title,
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(height: 15.0),
          Text(model.body, style: const TextStyle(fontSize: 24.0)),
          const SizedBox(height: 30.0),
        ],
      );
}
