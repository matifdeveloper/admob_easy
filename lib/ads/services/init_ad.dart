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

import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/utils/admob_easy_logger.dart';
import 'package:flutter/material.dart';
import 'package:admob_easy/ads/sources.dart';

mixin InitAd {
  InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  /// <------------------------ Load Interstitial Ad with Exponential Backoff ------------------------>
  Future<void> createInterstitialAd(
    BuildContext context, {
    bool load = true,
    int maxLoadAttempts = 5,
    int attemptDelayFactorMs = 500, // Delay factor for exponential backoff
  }) async {
    if (!AdmobEasy.instance.isConnected.value ||
        !load ||
        AdmobEasy.instance.initAdID.isEmpty) {
      AdmobEasyLogger.error('Interstitial ad cannot load');
      return;
    }

    // Dispose existing ad if present to prevent memory leaks
    if (interstitialAd != null) {
      interstitialAd!.dispose();
      interstitialAd = null;
    }

    await InterstitialAd.load(
      adUnitId: AdmobEasy.instance.initAdID,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          AdmobEasyLogger.success('$ad loaded');
          interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          interstitialAd!.setImmersiveMode(true); // Enable immersive mode
        },
        onAdFailedToLoad: (LoadAdError error) async {
          AdmobEasyLogger.error('InterstitialAd failed to load: $error');
          _numInterstitialLoadAttempts += 1;
          interstitialAd = null;

          // Retry with exponential backoff if attempts are less than maxLoadAttempts
          if (_numInterstitialLoadAttempts < maxLoadAttempts) {
            int delayMs = attemptDelayFactorMs * _numInterstitialLoadAttempts;
            await Future.delayed(Duration(milliseconds: delayMs));
            if (!context.mounted) return;
            createInterstitialAd(context, load: true);
          } else {
            _numInterstitialLoadAttempts = 0; // Reset after max attempts
          }
        },
      ),
    );
  }

  /// <------------------------ Show Interstitial Ad ------------------------>
  void showInterstitialAd(
    BuildContext context, {
    void Function(InterstitialAd)? onAdShowedFullScreenContent,
    void Function(InterstitialAd)? onAdDismissedFullScreenContent,
    void Function(InterstitialAd, AdError)? onAdFailedToShowFullScreenContent,
  }) {
    // Check if the interstitial ad is loaded
    if (interstitialAd == null) {
      AdmobEasyLogger.info('Interstitial ad not loaded, attempting to load...');
      if (!context.mounted) return;
      createInterstitialAd(context); // Load ad if not already loaded
      return;
    }

    // Set callbacks for full-screen content events and show the interstitial ad
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        if (onAdShowedFullScreenContent != null) {
          onAdShowedFullScreenContent(ad);
        }
        AdmobEasyLogger.success('Interstitial ad displayed.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        if (onAdDismissedFullScreenContent != null) {
          onAdDismissedFullScreenContent(ad);
        }
        AdmobEasyLogger.info('$ad dismissed.');
        interstitialAd = null; // Clear the reference to the ad
        ad.dispose(); // Dispose the ad object to free resources

        if (context.mounted) {
          createInterstitialAd(context); // Preload the next ad after dismissal
        }
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        if (onAdFailedToShowFullScreenContent != null) {
          onAdFailedToShowFullScreenContent(ad, error);
        }
        AdmobEasyLogger.error('Failed to show interstitial ad: $error');
        ad.dispose();
        interstitialAd = null; // Clear the reference to the failed ad
      },
    );

    interstitialAd!.show(); // Show the interstitial ad
  }
}
