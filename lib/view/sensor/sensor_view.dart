import 'dart:developer';

import 'package:att_loneworker/core/constants/localization/localization_keys_constants.dart';
import 'package:att_loneworker/core/init/locator.dart';
import 'package:att_loneworker/helpers/dialog/dialog_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../bloc/sensor_event/sensor_event_cubit.dart';

class SensorView extends StatefulWidget {
  const SensorView({super.key});

  @override
  State<SensorView> createState() => _SensorViewState();
}

final _dialogHelper = getIt<DialogHelper>();

class _SensorViewState extends State<SensorView> {
  @override
  void initState() {
    super.initState();

    // TODO: initState bind ile async taskların çalıştırılması için gerekli kod
    // SchedulerBinding.instance?.addPostFrameCallback((_ {
    //   _dialogHelper.showDialog(context, title: 'Title', body: Text('Ersen'));
    // });
    accelerometerEvents.listen((AccelerometerEvent event) async {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
      log('accelerometerEvents ${event.toString()}    -- ${dateFormat.format(DateTime.now())}');
      // FlutterLogs.logToFile(
      //     logFileName: "Sensor",
      //     overwrite: false,
      //     logMessage:
      //         'accelerometerEvents ${event.toString()}    -- ${dateFormat.format(DateTime.now())}');
      context.read<SensorEventCubit>().changeTheState(event: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocalizationKeys.HOME_APPBAR_TITLE)),
      ),
      body: Center(
        child: BlocBuilder<SensorEventCubit, AccelerometerEvent>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('X --> ${state.x}'),
                Text('Y --> ${state.y}'),
                Text('Z --> ${state.z}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
