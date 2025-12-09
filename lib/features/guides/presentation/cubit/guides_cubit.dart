import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tools_app/features/guides/data/repositories/guides_repository.dart';
import 'package:smart_tools_app/features/guides/presentation/cubit/guides_state.dart';

class GuidesCubit extends Cubit<GuidesState> {
  final GuidesRepository _repository;

  GuidesCubit(this._repository) : super(GuidesInitial());

  Future<void> loadGuides() async {
    emit(GuidesLoading());
    try {
      final guides = await _repository.getGuides();
      emit(GuidesLoaded(guides));
    } catch (e) {
      emit(GuidesError(e.toString()));
    }
  }
}
