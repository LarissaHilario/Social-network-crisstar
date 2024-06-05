import 'package:red_social/domain/models/Post_model.dart';
import 'package:red_social/domain/repositories/post_repository.dart';

class GetAllPostsUseCase {
  final PostRepository _postsRepository;

  GetAllPostsUseCase(this._postsRepository) : assert(_postsRepository != null);

  Future<List<PostModel>> call(String collectionName) async {
    var posts = await _postsRepository.getPostsCollection(collectionName);
    return posts;
  }
}