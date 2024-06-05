import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:red_social/presentation/pages/Login_page.dart';

class MyInitPage extends StatefulWidget {
  const MyInitPage({super.key});
  @override
  State<MyInitPage> createState() => _MyInitPageState();
}

class _MyInitPageState extends State<MyInitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/init.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 600),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF706B69).withOpacity(0.34),
                minimumSize: const Size(100, 60),
                maximumSize: const Size(300, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Empezar',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'FiraSansCondensed',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset(
                    'assets/images/arrow.svg',
                    width: 30,
                    height: 30,
                  ),
                  SvgPicture.asset(
                    'assets/images/arrow.svg',
                    width: 30,
                    height: 30,
                  ),
                  SvgPicture.asset(
                    'assets/images/arrow.svg',
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
