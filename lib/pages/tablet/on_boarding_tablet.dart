import 'package:donna/utils/mobile/waves.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingTablet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Title of first page",
              body: "Here you can write the description of the page, to explain someting...",
              image: Center(
                child: Image.network("https://logowik.com/content/uploads/images/flutter5786.jpg", height: 175.0),
              ),
            ),
            PageViewModel(
              title: "Title of first page",
              body: "Here you can write the description of the page, to explain someting...",
              image: Center(
                child: Image.network("https://logowik.com/content/uploads/images/flutter5786.jpg", height: 175.0),
              ),
            ),
            PageViewModel(
              title: "Title of first page",
              body: "Here you can write the description of the page, to explain someting...",
              image: Center(
                child: Image.network("https://logowik.com/content/uploads/images/flutter5786.jpg", height: 175.0),
              ),
            )
          ],
          showSkipButton: true,
          onDone: () {

          },
          onSkip: () {

          },
          skip: const Icon(Icons.skip_next),
          next: const Icon(Icons.navigate_next),
          done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: Colors.white,
              color: Colors.blue,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)
              )
          ),
        ),
        bottomNavigationBar: const WavesMobile(),
      ),
    );
}
}
