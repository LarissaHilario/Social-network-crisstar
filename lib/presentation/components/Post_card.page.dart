import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:red_social/domain/models/Post_model.dart';

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
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 5, top: 8, bottom: 8),
                                child: SizedBox(
                                  width: 312,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image(
                                      image: NetworkImage(post.img),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
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
