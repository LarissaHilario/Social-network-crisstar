import 'package:red_social/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<bool> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }

  Future<bool> register(String email, String password) async {
    return await _authRepository.register(email, password);
  }
}
