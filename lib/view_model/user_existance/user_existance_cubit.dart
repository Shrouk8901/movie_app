import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/repositories/user_existance_repository.dart';
import 'package:movies_app/view_model/user_existance/user_existance_states.dart';

class UserExistanceCubit extends Cubit<UserExistanceStates> {
  UserExistanceCubit() : super(UserExistanceInitial());

  final UserExistanceRepository _existanceRepository =
      UserExistanceRepository();

  late bool seen;
  late bool userLogged;

  Future<void> loadUserLoogedAndOnboardState() async {
    emit(UserLoogedAndOnboardStateLoading());
    final result = await _existanceRepository.checkAlreadySeenOnboarding();
    result.fold((failure) => emit(UserLoogedAndOnboardStateError()),
        (result) async {
      seen = result;
      final userState = await _existanceRepository.alreadyLogged();
      userState.fold((failure) => emit(UserLoogedAndOnboardStateError()),
          (result) {
        userLogged = result;
        emit(UserLoogedAndOnboardStateSuccess());
      });
    });
  }

  Future<void> finishOnboarding() async {
    final result = await _existanceRepository.finishOnboarding();
    result.fold((failure) => emit(UserLoogedAndOnboardStateError()), (result) {
      seen = true;
    });
  }
}
