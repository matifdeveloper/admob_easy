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

    Created by Muhammad Atif on 3/13/2024.
    Portfolio https://atifnoori.web.app.
    IsloAI

 *********************************************************************************/

import 'package:admob_easy/ads/controllers/connectivity_controller.dart';
import 'package:admob_easy/ads/helper/admob_helper.dart';
import 'package:admob_easy/ads/services/init_ad.dart';
import 'package:admob_easy/ads/services/open_app_ad.dart';
import 'package:admob_easy/ads/services/rewarded_ad.dart';

/// [AdmobEasy] class combines functionality from InitAd, AppRewardedAd, and OpenAppAd
class AdmobEasy
    with InitAd, AppRewardedAd, OpenAppAd, AdmobHelper, ConnectivityController {
  // Singleton instance of AdmobEasy, using a private constructor
  static final AdmobEasy _instance = AdmobEasy._privateConstructor();

  // Private named constructor for singleton pattern
  AdmobEasy._privateConstructor();

  // Getter to access the singleton instance
  static AdmobEasy get instance => _instance;

// Additional methods and properties can be added here as needed
}
