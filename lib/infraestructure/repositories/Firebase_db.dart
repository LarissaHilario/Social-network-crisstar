import 'package:cloud_firestore/cloud_firestore.dart';
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
    print("hola $posts");
    return posts;
  }
  Future<void> addPostToCollection(String collectionName, PostModel post) async {
    try {
      await db.collection(collectionName).add(post.toMap());
    } catch (e) {
      throw Exception("Error al agregar el post a la colección: $e");
    }
  }
}
