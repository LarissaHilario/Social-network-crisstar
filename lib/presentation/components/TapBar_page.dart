import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TapBarPage extends StatefulWidget {
  const TapBarPage({super.key});
  @override
  State<TapBarPage> createState() => _TapBarPageState();
}

class _TapBarPageState extends State<TapBarPage> {
  int _currentIndex = 0;
  List<Widget> body = const [

  ];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: body[ _currentIndex],
     ),
     bottomNavigationBar: BottomNavigationBar(
       backgroundColor: const Color(0xFFEEA1A3),
       landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
       currentIndex: _currentIndex,
       onTap: (int newIndex) {
         setState(() {
           _currentIndex = newIndex;
         });
       },
       items: [
         BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/home.svg')),
         BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/add.svg')),

       ],
     ),
   );
  }
}