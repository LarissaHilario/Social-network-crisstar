import 'package:red_social/domain/models/Post_model.dart';
import 'package:red_social/domain/repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _postRepository;

  CreatePostUseCase(this._postRepository);

  Future<void> execute(String collectionName, PostModel post) async {
    try {
      await _postRepository.addPostToCollection(collectionName, post);
    } catch (e) {
      throw Exception("Error al crear el post: $e");
    }
  }
}

