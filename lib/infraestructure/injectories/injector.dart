import 'package:get_it/get_it.dart';
import 'package:red_social/domain/repositories/post_repository.dart';
import 'package:red_social/domain/uses_cases/get_all_posts_usecase.dart';
import 'package:red_social/infraestructure/repositories/Firebase_db.dart';
import 'package:red_social/infraestructure/repositories/post_repositoryimpl.dart';

import '../../presentation/providers/post_provider.dart';

final _injector = GetIt.instance;

void setUp() {
  _injector.registerLazySingleton<FirebaseConnection>(() => FirebaseConnection());
  _injector.registerLazySingleton<PostRepository>(
          () => PostRepositoryImpl(_injector<FirebaseConnection>()));

  // Providers
  _injector.registerLazySingleton<PostProvider>(
          () => PostProvider(_injector<GetAllPostsUseCase>()));

  // Use Cases
  _injector.registerLazySingleton<GetAllPostsUseCase>(
          () => GetAllPostsUseCase(_injector<PostRepository>()));
}