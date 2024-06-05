import 'package:flutter/material.dart';
import 'package:red_social/domain/models/Post_model.dart';
import 'package:red_social/domain/uses_cases/get_all_posts_usecase.dart';

class PostProvider with ChangeNotifier {
  final GetAllPostsUseCase _getPostUC;

  PostProvider(this._getPostUC) : assert(_getPostUC != null);

// fields
  late List<PostModel> _postList = [];
  late String _errorMessage = '';

// getters
  List<PostModel> get postList => _postList;

  String get errorMessage => _errorMessage;

  void getPosts(String collectionName) async {
    try {
      _postList = await _getPostUC(collectionName);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
