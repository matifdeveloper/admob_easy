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

    Created by Muhammad Atif on 04/01/2024 : 10:14 pm.
    Portfolio https://atifnoori.web.app.
    +923085690603

 ********************************************************************************
 */

import 'dart:developer';

import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/sources.dart';

/**
 *  create instance of AppLifecycleReactor in first screen
    late AppLifecycleReactor _appLifecycleReactor;

 * add these line in first screen in [initState]
    OpenAppAd.instance..loadOpenAppAd();
    // Create and listen to app lifecycle changes
    _appLifecycleReactor = AppLifecycleReactor();
    _appLifecycleReactor.listenToAppStateChanges();
 * */

/// Start the [OpenAppAd] class

mixin OpenAppAd {
  /// App open ads area
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  // Function to load an AppOpenAd.
  void loadAppOpenAd() {
    if (AdmobEasy.instance.appOpenAdID.isEmpty) return;

    AppOpenAd.load(
      adUnitId: AdmobEasy.instance.appOpenAdID,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          log('App open ad loaded');
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          log('App open ad failed');
        },
      ),
    );
  }

  // Function to show an AppOpenAd.
  void showOpenAppAd() {
    if (_appOpenAd == null || _isShowingAd) {
      return;
    }
    _isShowingAd = true;

    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        log('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        log('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }
}

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final AdmobEasy appOpenAdManager = AdmobEasy.instance;

  AppLifecycleReactor();

  // Listen to app state changes.
  void openAppAdListener() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  // Handle app state changes and show app open ads when the app is in the foreground.
  void _onAppStateChanged(AppState appState) {
    if (appState == AppState.foreground) {
      log('App in foreground');
      appOpenAdManager.showOpenAppAd();
    }
  }
}
