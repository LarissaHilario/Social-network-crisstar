import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:red_social/domain/models/Post_model.dart';
import 'package:red_social/domain/repositories/post_repository.dart';
import 'package:red_social/infraestructure/repositories/Firebase_db.dart';

class PostRepositoryImpl extends PostRepository {
  final FirebaseConnection _postFirestore;

  PostRepositoryImpl(this._postFirestore)
      : assert(_postFirestore != null);

  @override
  Future<List<PostModel>> getPostsCollection(String collectionName) async {
    var postList = await _postFirestore.getPostsByCollection(collectionName);
    print(postList);
    return postList;
  }

  @override
  Future<void> addPostToCollection(String collectionName,
      PostModel post) async {
    try {
      await _postFirestore.addPostToCollection(collectionName, post);
    } catch (e) {
      throw Exception("Error al agregar el post a la colección: $e");
    }
  }

  @override
  Future<String> uploadFile(File file, bool isVideo) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child(
          '${isVideo ? 'videos' : 'images'}/${DateTime.now().toString()}');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error al cargar el archivo: $e');
      return '';
    }
  }


  @override
  Future<List<String>> getSongUrls() async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    final Reference directory = _storage.ref('music');
    List<String> songUrls = [];

    try {
      final ListResult result = await directory.listAll();

      print('Total de elementos en el directorio de música: ${result.items
          .length}');

      await Future.forEach(result.items, (Reference ref) async {
        try {
          final String downloadUrl = await ref.getDownloadURL();
          songUrls.add(downloadUrl);
        } catch (e) {
          print('Error al obtener la URL de descarga para ${ref.name}: $e');
        }
      });
    } catch (e) {
      print('Error al listar elementos en el directorio de música: $e');
    }

    print('URLs de canciones encontradas: $songUrls');
    return songUrls;
  }
}



