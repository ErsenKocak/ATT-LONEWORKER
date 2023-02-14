import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

import '../../../core/init/locator.dart';
import '../network_connection/network_connection_helper.dart';

class ConnectivityHelper {
  late StreamSubscription<ConnectivityResult> connectivityStreamSub;
  final _logger = getIt<Logger>();
  final _networkConnectionHelper = getIt<NetworkConnectionHelper>();

  initializeStream() {
    connectivityStreamSub = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _logger.wtf('ConnectivityHelper -- ConnectivityResult -- ${result} ');
    });
  }

  Future<bool> checkDeviceConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    _logger.i('checkConnectivity $connectivityResult ${DateTime.now()}');

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      await _networkConnectionHelper.checkNetworkConnectivity();
      return true;
    }
  }

  disposeStream() async => await connectivityStreamSub.cancel();
}
