import 'package:bloc/bloc.dart';
import 'package:present/cubits/tagread/tagread_state.dart';

class TagreadCubit extends Cubit<TagreadState> {
  TagreadCubit() : super(TagreadState.initial());

  emitNewState(bool newState) {
    emit(state.copyWith(tagread: newState));
  }
}
