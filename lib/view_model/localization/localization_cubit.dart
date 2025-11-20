import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/repositories/localization_repository.dart';
import 'package:movies_app/view_model/localization/localization_states.dart';

class LocalizationCubit extends Cubit<LocalizationStates> {
  LocalizationCubit() : super(LocalizationInitialState());

  final LocalizationRepository _localizationRepository =
      LocalizationRepository();

  String language = 'en';

  Future<void> getLocale() async {
    emit(LocalizationLoading());
    final langResult = await _localizationRepository.getLocale();
    langResult.fold((failure) => emit(LocalizationError()), (lang) {
      language = lang;
      emit(LocalizationSuccess());
    });
  }

  Future<void> setLocle(String lang) async {
    final result = await _localizationRepository.setLocale(lang);
    result.fold((failure) => emit(LocalizationError()), (_) {
      language = lang;
      emit(LocalizationSuccess());
    });
  }
}
