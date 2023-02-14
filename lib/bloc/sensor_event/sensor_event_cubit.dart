import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorEventCubit extends Cubit<AccelerometerEvent> {
  SensorEventCubit() : super(AccelerometerEvent(0, 0, 0));

  changeTheState({required AccelerometerEvent event}) {
    emit(AccelerometerEvent(event.x, event.y, event.z));
  }
}
