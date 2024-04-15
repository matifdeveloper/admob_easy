/*
********************************************************************************

    _____/\\\\\\\\\_____/\\\\\\\\\\\\\\\__/\\\\\\\\\\\__/\\\\\\\\\\\\\\\_
    ___/\\\\\\\\\\\\\__\///////\\\/////__\/////\\\///__\/\\\///////////__
    __/\\\/////////\\\_______\/\\\___________\/\\\_____\/\\\_____________
    _\/\\\_______\/\\\_______\/\\\___________\/\\\_____\/\\\\\\\\\\\_____
    _\/\\\\\\\\\\\\\\\_______\/\\\___________\/\\\_____\/\\\///////______
    _\/\\\/////////\\\_______\/\\\___________\/\\\_____\/\\\_____________
    _\/\\\_______\/\\\_______\/\\\___________\/\\\_____\/\\\_____________
    _\/\\\_______\/\\\_______\/\\\________/\\\\\\\\\\\_\/\\\_____________
    _\///________\///________\///________\///////////__\///______________

    Created by Muhammad Atif on 4/1/2024.
    Portfolio https://atifnoori.web.app.
    IsloAI
 *********************************************************************************/

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// A mixin for managing connectivity state
mixin ConnectivityController {
  /// Notifier for tracking connectivity status
  ValueNotifier<bool> isConnected = ValueNotifier(false);

  /// Initializes connectivity and sets up listeners for changes
  Future<void> initConnectivity({
    VoidCallback? onOnline,
    VoidCallback? onOffline,
  }) async {
    // Check current connectivity status
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    _isInternetConnected(result);

    // Listen for changes in connectivity
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult>? result) {
      if (kDebugMode) {
        print(result);
      }

      _isInternetConnected(result);
    });
  }

  /// Checks if internet is connected based on the given connectivity result
  bool _isInternetConnected(List<ConnectivityResult>? result) {
    final modifiedResult = result?.last;

    if (modifiedResult == ConnectivityResult.none) {
      isConnected.value = false;
      return false;
    } else if (modifiedResult == ConnectivityResult.mobile ||
        modifiedResult == ConnectivityResult.wifi) {
      isConnected.value = true;
      return true;
    }
    return false;
  }
}
