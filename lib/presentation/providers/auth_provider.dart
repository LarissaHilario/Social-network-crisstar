import 'package:flutter/material.dart';
import 'package:red_social/domain/uses_cases/Auth_use_case.dart';
import 'package:red_social/infraestructure/repositories/firebase_auth_repository.dart';


class Auth1Provider extends ChangeNotifier {
  final AuthUseCase _authUseCase ;

  Auth1Provider(this._authUseCase);

  Future<bool> login(String email, String password) async {
    return await _authUseCase.login(email, password);
  }

  Future<bool> register(String email, String password) async {
    return await _authUseCase.register(email, password);
  }
}
