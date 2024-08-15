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

    Created by Muhammad Atif on 04/01/2024 : 9:40 pm.
    Portfolio https://atifnoori.web.app.
    +923085690603

 ********************************************************************************
 */

import 'dart:io';
import 'package:admob_easy/admob_easy.dart';
import 'package:admob_easy/ads/helper/admob_ump_helper.dart';

/**
 * Testing ids
 * app id = ca-app-pub-3940256099942544~3347511713
 * rewarded = ca-app-pub-3940256099942544/5224354917
 * init = ca-app-pub-3940256099942544/1033173712
 * banner = ca-app-pub-3940256099942544/6300978111
 * app open = ca-app-pub-3940256099942544/9257395921
 * native ad = ca-app-pub-3940256099942544/2247696110
 */

///

// Class to handle Admob configuration and IDs.
mixin AdmobHelper {
  // Map to store Admob IDs for different ad types and platforms.
  Map<String, String?> _adIds = {};

  // Method to initialize Admob IDs based on the platform.
  void initialize({
    String? androidRewardedAdID,
    String? androidInitAdID,
    String? androidBannerAdID,
    String? androidNativeAdID,
    String? androidAppOpenAdID,
    String? iosRewardedAdID,
    String? iosInitAdID,
    String? iosBannerAdID,
    String? iosNativeAdID,
    String? iosAppOpenAdID,
    List<String>? testDevices,
  }) {
    try {
      _adIds = {
        // Setting rewarded ad ID based on the platform (Android or iOS).
        'rewarded': Platform.isAndroid ? androidRewardedAdID : iosRewardedAdID,
        // Setting initialization ad ID based on the platform (Android or iOS).
        'init': Platform.isAndroid ? androidInitAdID : iosInitAdID,
        // Setting banner ad ID based on the platform (Android or iOS).
        'banner': Platform.isAndroid ? androidBannerAdID : iosBannerAdID,
        // Setting native ad ID based on the platform (Android or iOS).
        'native': Platform.isAndroid ? androidNativeAdID : iosNativeAdID,
        // Setting app open ad ID based on the platform (Android or iOS).
        'appOpen': Platform.isAndroid ? androidAppOpenAdID : iosAppOpenAdID,
      };

      /// Add the listener for internet connection
      AdmobEasy.instance.initConnectivity();

      /// Initializing Mobile Ads and updating request configuration with test IDs with UMP.
      AdmobUmp.instance.initializeUMP();
    } catch (e) {
      // Throwing an exception if an error occurs during initialization.
      throw Exception("Error initializing Admob: $e");
    }
  }

  // Getter method to retrieve rewarded ad ID.
  String get rewardedAdID => _adIds['rewarded'] ?? '';

  // Getter method to retrieve initialization ad ID.
  String get initAdID => _adIds['init'] ?? '';

  // Getter method to retrieve banner ad ID.
  String get bannerAdID => _adIds['banner'] ?? '';

  // Getter method to retrieve native ad ID.
  String get nativeAdID => _adIds['native'] ?? '';

  // Getter method to retrieve app open ad ID.
  String get appOpenAdID => _adIds['appOpen'] ?? '';
}
