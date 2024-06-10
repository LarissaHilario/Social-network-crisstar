import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:red_social/domain/models/Post_model.dart';
import 'package:video_player/video_player.dart';

class PostCardPage extends StatelessWidget {
  PostCardPage(this._postList, {Key? key}) : super(key: key);

  final List<PostModel> _postList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: _postList != null && _postList.isNotEmpty
          ? Column(children: [
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _postList.length,
                      itemBuilder: (context, index) {
                        var post = _postList[index];
                        return Column(
                          children: [
                            Row(children: [
                              ProfilePicture(
                                name: post.name,
                                radius: 20,
                                fontsize: 16,
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.name,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      post.ubicacion,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xFF706B69),
                                      ),
                                    ),
                                  ]),
                            ]),
                            post.isVideo
                                ? _DisplayVideo(videoUrl: post.img)
                                : Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5, top: 8, bottom: 8),
                                      child: SizedBox(
                                        width: 312,
                                        height: 200,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Image(
                                            image: NetworkImage(post.img),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 14, top: 8, bottom: 8, left: 14),
                              child: Text(
                                post.descripcion,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFF706B69),
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      }))
            ])
          : CircularProgressIndicator(),
    );
  }
}

class _DisplayVideo extends StatefulWidget {
  final String videoUrl;
  const _DisplayVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<_DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<_DisplayVideo> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;



  @override
  void initState() {
    super.initState();
    var url = Uri.parse(widget.videoUrl);
    controller = VideoPlayerController.networkUrl(url);
    initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
              width: 312,
              height: 200,
              child:
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
        child:
            Stack(
            alignment: Alignment.center,
            children: [
          AspectRatio(
          aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    });
                  },
                  child: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),
          ]
        )
            )
            );

        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
