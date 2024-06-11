import 'dart:io';

import 'package:red_social/domain/models/Post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPostsCollection(String collectionName);
  Future<void> addPostToCollection(String collectionName, PostModel post);
  Future<String> uploadFile(File file, bool isVideo);
  Future<List<String>> getSongUrls();

}