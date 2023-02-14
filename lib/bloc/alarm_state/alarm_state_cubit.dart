import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class AlarmStateCubit extends Cubit<bool> {
  AlarmStateCubit() : super(false);

  emitState({required bool value}) => emit(value);
}
