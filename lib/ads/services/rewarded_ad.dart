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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admob_easy/ads/sources.dart';

class AppRewardedAd {
  // Create instance
  static final AppRewardedAd instance = AppRewardedAd._privateConstructor();

  AppRewardedAd._privateConstructor();

  // Counter for the number of load attempts for rewarded ads.
  int _numRewardedLoadAttempts = 0;
  final int _maxFailedLoadAttempts = 5;

  /// <------------------------ Load Rewarded Ad ------------------------>
  // Function to create a rewarded ad.
  Future<void> createRewardedAd(BuildContext context) async {
    final adsProvider = Provider.of<AdsState>(context, listen: false);

    await RewardedAd.load(
      adUnitId: AdmobHelper.instance.rewardedAdID,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          // Ad loaded successfully.
          log('$ad loaded.');
          adsProvider.rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Ad failed to load.
          log('RewardedAd failed to load: $error');
          adsProvider.rewardedAd = null;
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
  Future<void> showRewardedAd(BuildContext context) async {
    final adsProvider = Provider.of<AdsState>(context, listen: false);
    if (adsProvider.rewardedAd == null) {
      if(!context.mounted) return;
      createRewardedAd(context);
      return;
    }
    adsProvider.rewardedAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          log('Reward ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        adsProvider.rewardedAd == null;
        ad.dispose();
        if(!context.mounted) return;
        createRewardedAd(context);
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
      },
    );

    await adsProvider.rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      // User earned a reward.
      log('Earn with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
  }
}
