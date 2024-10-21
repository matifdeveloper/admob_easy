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

    Created by Muhammad Atif on 10/21/2024.
    Portfolio https://atifnoori.web.app.
    GAMICAN

 ********************************************************************************
 */

import 'package:flutter/foundation.dart';
import 'dart:developer';

mixin AdmobEasyLogger {
  void warning(Object message) {
    if (kDebugMode) {
      _logWithColor(message, '📢 Warning', 33);
    }
  }

  void error(Object message) {
    if (kDebugMode) {
      _logWithColor(message, '❌ Error', 31);
    }
  }

  void success(Object message) {
    if (kDebugMode) {
      _logWithColor(message, '✅ Success', 32);
    }
  }

  void info(Object message) {
    if (kDebugMode) {
      _logWithColor(message, 'ℹ️ Info', 34);
    }
  }

  void _logWithColor(Object message, String label, int colorCode) {
    final String separator =
        "\x1B[${colorCode}m==========================================================================================\x1B[0m";
    log(separator);
    log('\x1B[${colorCode}m[$label] $message\x1B[0m');
    log(separator);
  }
}
