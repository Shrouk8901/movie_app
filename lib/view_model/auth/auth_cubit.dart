import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/models/auth/login_request.dart';
import 'package:movies_app/data/models/auth/register_request.dart';
import 'package:movies_app/data/models/auth/reset_password_request.dart';
import 'package:movies_app/data/repositories/auth_repository.dart';
import 'package:movies_app/view_model/auth/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final AuthRepository _repository = AuthRepository();

  Future<void> register(RegisterRequest request) async {
    emit(RegisterLoading());
    final result = await _repository.register(request);
    result.fold((faliure) => emit(RegisterError(faliure.errorMessage)), (_) {
      emit(RegisterSuccess());
    });
  }

  Future<void> login(LoginRequest request) async {
    emit(LoginLoading());

    final result = await _repository.login(request);
    result.fold(
      (faliure) => emit(LoginError(faliure.errorMessage)),
      (_) => emit(LoginSuccess()),
    );
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    emit(ResetPasswordLoading());
    final result = await _repository.resetPasssword(request);
    result.fold((faliure) => emit(ResetPasswordError(faliure.errorMessage)),
        (data) {
      emit(ResetPasswordSuccess(data));
    });
  }
}
