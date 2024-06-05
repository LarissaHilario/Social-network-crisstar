import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../domain/models/Post_model.dart';

class FirebaseConnection {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<PostModel>> getPostsByCollection(String collectionName) async {
    var posts = <PostModel>[];
    await db.collection(collectionName).get().then(
          (querySnapshot) => querySnapshot.docs.forEach(
            (element) {
          posts.add(
            PostModel.fromMap(element.data()),
          );
        },
      ),
    );
    print(posts);
    return posts;
  }
}
