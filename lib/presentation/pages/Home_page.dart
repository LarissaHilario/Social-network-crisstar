import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:red_social/presentation/components/Post_card.page.dart';
import 'package:red_social/presentation/pages/Init_page.dart';
import 'package:red_social/presentation/pages/choose_photo_page.dart';

import '../providers/post_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    var postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.getPosts('post');
  }



  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyInitPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var postProvider = context.watch<PostProvider>();
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 29, top: 50, right: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 70),
                    child: Text(
                      'Crisstar',
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Color(0xFF464646),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'FiraSansCondensed',
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/log_out.svg',
                      width: 33,
                      height: 33,
                    ),
                    onPressed: () {
                      _logout();
                    },
                  ),
                  const ProfilePicture(
                    name: 'Aditya Dharmawan Saputra',
                    radius: 20,
                    fontsize: 16,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: postProvider.postList.isNotEmpty
                ? PostCardPage(postProvider.postList)
                : postProvider.errorMessage.isNotEmpty
                ? Center(child: Text(postProvider.errorMessage))
                : const Center(child: CircularProgressIndicator()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFEEA1A3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/home.svg',
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/add.svg',
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChoosePhotoPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
