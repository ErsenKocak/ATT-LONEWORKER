import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';

import '../../../core/init/locator.dart';

class NetworkConnectionHelper {
  final _logger = getIt<Logger>();

  Future<bool> checkNetworkConnectivity() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    _logger.w(
        'NetworkConnectionHelper -- checkNetworkConnectivity -- $isConnected');
    return isConnected;
  }
}
