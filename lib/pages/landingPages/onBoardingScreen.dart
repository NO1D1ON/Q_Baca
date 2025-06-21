import 'package:flutter/material.dart';
import 'package:q_baca/pages/landingPages/size_config.dart';
import 'package:q_baca/pages/landingPages/onBoardingContents.dart';
import 'package:q_baca/pages/loginPages/login.dart';
import 'package:q_baca/theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:q_baca/pages/loginPages/login.dart';
import 'package:q_baca/pages/loginPages/register.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    Color(0xFFE6FADD),
    Color(0xFFE6FADD),
    Color(0xFFE6FADD),
    Color(0xFFE6FADD),
  ];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Palette.hijauButton,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 0.0,
                      left: 0.0,
                      top: 120.0,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          // Wrap the Image.asset with Expanded
                          child: Image.asset(
                            contents[i].image,
                            width: 385.0,
                            height: 348.0,
                            // Remove fixed height here, let it be flexible
                          ),
                        ),
                        SizedBox(height: (height >= 850) ? 35 : 25),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (width <= 550) ? 30 : 35,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          contents[i].desc,
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w300,
                              fontSize: (width <= 550) ? 17 : 25,
                              color: Palette.hijauButton,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40.0),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        contents.length,
                        (int index) => _buildDots(index: index),
                      ),
                    ),
                    _currentPage + 1 == contents.length
                        ? Padding(
                            padding: const EdgeInsets.all(30),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "MULAI",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.hijauButton,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: (width <= 550)
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 100,
                                        vertical: 16,
                                      )
                                    : EdgeInsets.symmetric(
                                        horizontal: width * 0.2,
                                        vertical: 20,
                                      ),
                                textStyle: TextStyle(
                                  fontSize: (width <= 550) ? 13 : 17,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _controller.jumpToPage(3);
                                  },
                                  child: const Text(
                                    "Lewati",
                                    style: TextStyle(color: Color(0xFF28738B)),
                                  ),
                                  style: TextButton.styleFrom(
                                    elevation: 0,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: (width <= 550) ? 13 : 17,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _controller.nextPage(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  child: const Text(
                                    "Selanjutnya",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Palette.hijauButton,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    elevation: 0,
                                    padding: (width <= 550)
                                        ? const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 20,
                                          )
                                        : const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 20,
                                          ),
                                    textStyle: TextStyle(
                                      fontSize: (width <= 550) ? 13 : 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
}
