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

    Created by Muhammad Atif on 04/01/2024 : 10:03 pm.
    Portfolio https://atifnoori.web.app.
    +923085690603

 ********************************************************************************
 */

import 'dart:developer';
import 'package:admob_easy/ads/admob_easy.dart';
import 'package:flutter/material.dart';
import 'package:admob_easy/ads/sources.dart';

mixin AppRewardedAd {
  RewardedAd? rewardedAd;
  // Counter for the number of load attempts for rewarded ads.
  int _numRewardedLoadAttempts = 0;
  final int _maxFailedLoadAttempts = 5;

  /// <------------------------ Load Rewarded Ad ------------------------>
  // Function to create a rewarded ad.
  Future<void> createRewardedAd(BuildContext context) async {

    await RewardedAd.load(
      adUnitId: AdmobEasy.instance.rewardedAdID,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          // Ad loaded successfully.
          log('$ad loaded.');
          rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Ad failed to load.
          log('RewardedAd failed to load: $error');
          rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          log(
            'Num Rewarded Load Attempts $_numRewardedLoadAttempts',
          );
          if (_numRewardedLoadAttempts < _maxFailedLoadAttempts) {
            createRewardedAd(context);
          } else {
            _numRewardedLoadAttempts = 0;
          }
        },
      ),
    );
  }

  /// <------------------------ Show Rewarded Ad ------------------------>
// Function to show a rewarded ad.
  Future<void> showRewardedAd(
    BuildContext context, {
    void Function(RewardedAd)? onAdShowedFullScreenContent,
    void Function(RewardedAd)? onAdDismissedFullScreenContent,
    void Function(RewardedAd, AdError)? onAdFailedToShowFullScreenContent,
    void Function(AdWithoutView, RewardItem)? onUserEarnedReward,
  }) async {

    // Check if the rewarded ad is loaded
    if (rewardedAd == null) {
      if (!context.mounted) return; // Return if the context is not mounted
      createRewardedAd(context); // Create the rewarded ad
      return;
    }

    // Set callbacks and show the rewarded ad
    rewardedAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: onAdShowedFullScreenContent,
      // Set callback for when ad is shown
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        // Call the callback function when ad is dismissed
        if (onAdDismissedFullScreenContent != null) {
          onAdDismissedFullScreenContent(ad);
        }
        rewardedAd == null; // Clear the reference to the ad
        ad.dispose(); // Dispose the ad object
        if (!context.mounted) return; // Return if the context is not mounted
        createRewardedAd(context); // Create a new rewarded ad
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        // Call the callback function when ad fails to show
        if (onAdFailedToShowFullScreenContent != null) {
          onAdFailedToShowFullScreenContent(ad, error);
        }
        ad.dispose(); // Dispose the ad object
      },
    );

    // Show the rewarded ad
    await rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        if (onUserEarnedReward != null) {
          onUserEarnedReward(ad, reward);
        }
        // User earned a reward.
        log('Earn with reward $RewardItem(${reward.amount}, ${reward.type})');
      },
    );
  }
}
