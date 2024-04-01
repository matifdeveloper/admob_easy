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

    Created by Muhammad Atif on 04/01/2024 : 9:48 pm.
    Portfolio https://atifnoori.web.app.
    +923085690603

 ********************************************************************************
 */

import 'dart:developer';
import 'package:admob_easy/ads/admob_easy.dart';
import 'package:flutter/material.dart';
import 'package:admob_easy/ads/sources.dart';

mixin InitAd {
  InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  /// Asynchronously creates and loads an [interstitial] ad.
  Future<void> createInterstitialAd(BuildContext context,
      {bool load = true}) async {

    if(!AdmobEasy.instance.isConnected.value || !load){
      return;
    }

    // Dispose existing ad if present
    if (interstitialAd != null) {
      interstitialAd!.dispose();
    }

    // Load new interstitial ad
    await InterstitialAd.load(
      adUnitId: AdmobEasy.instance.initAdID,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          log('$ad loaded');
          interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          interstitialAd = null;

          // Retry loading if attempts are less than 5
          if (_numInterstitialLoadAttempts < 5) {
            createInterstitialAd(context);
          }
        },
      ),
    );
  }

  /// Displays the loaded [interstitial] ad.
  void showInterstitialAd(
      BuildContext context, {
        void Function(InterstitialAd)? onAdShowedFullScreenContent,
        void Function(InterstitialAd)? onAdDismissedFullScreenContent,
        void Function(InterstitialAd, AdError)? onAdFailedToShowFullScreenContent,
      }) {
    // Check if the interstitial ad is loaded
    if (interstitialAd == null) {
      // If ad is not loaded, create a new one
      if (!context.mounted) return; // Return if the context is not mounted
      createInterstitialAd(context); // Create the interstitial ad
      return;
    }

    // Set callbacks and show the interstitial ad
    interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdShowedFullScreenContent: onAdShowedFullScreenContent,
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            // Call the callback function when ad is dismissed
            if (onAdDismissedFullScreenContent != null) {
              onAdDismissedFullScreenContent(ad);
            }
            debugPrint('$ad onAdDismissedFullScreenContent.');
            interstitialAd = null; // Set ad to null after it's dismissed
            ad.dispose(); // Dispose the ad object
            if (!context.mounted) return; // Return if the context is not mounted
            createInterstitialAd(context); // Create a new interstitial ad
          },
          onAdFailedToShowFullScreenContent:
              (InterstitialAd ad, AdError error) {
            // Call the callback function when ad fails to show
            if (onAdFailedToShowFullScreenContent != null) {
              onAdFailedToShowFullScreenContent(ad, error);
            }
            debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose(); // Dispose the ad object
          },
        );

    interstitialAd!.show(); // Show the interstitial ad
  }
}
