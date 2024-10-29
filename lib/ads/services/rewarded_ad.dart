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

import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/utils/admob_easy_logger.dart';
import 'package:flutter/material.dart';
import 'package:admob_easy/ads/sources.dart';

mixin AppRewardedAd {
  RewardedAd? rewardedAd;
  int _numRewardedLoadAttempts = 0;
  final admobEasy = AdmobEasy.instance;

  /// <------------------------ Load Rewarded Ad with Exponential Backoff ------------------------>
  Future<void> createRewardedAd(
    BuildContext context, {
    int maxFailedLoadAttempts = 5,
    int attemptDelayFactorMs = 500, // Delay factor for exponential backoff
  }) async {
    if (!admobEasy.isConnected.value || admobEasy.rewardedAdID.isEmpty) {
      AdmobEasyLogger.error('Rewarded ad cannot load');
      return;
    }

    await RewardedAd.load(
      adUnitId: admobEasy.rewardedAdID,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          AdmobEasyLogger.success('$ad loaded.');
          rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) async {
          AdmobEasyLogger.error('RewardedAd failed to load: $error');
          rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          AdmobEasyLogger.warning(
            'Num Rewarded Load Attempts $_numRewardedLoadAttempts',
          );

          // Apply exponential backoff if failed to load
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            int delayMs = attemptDelayFactorMs * _numRewardedLoadAttempts;
            await Future.delayed(Duration(milliseconds: delayMs));
            if (!context.mounted) return;
            createRewardedAd(context);
          } else {
            _numRewardedLoadAttempts = 0;
          }
        },
      ),
    );
  }

  /// <------------------------ Show Rewarded Ad with User Engagement Tracking ------------------------>
  Future<void> showRewardedAd(
    BuildContext context, {
    void Function(RewardedAd)? onAdShowedFullScreenContent,
    void Function(RewardedAd)? onAdDismissedFullScreenContent,
    void Function(RewardedAd, AdError)? onAdFailedToShowFullScreenContent,
    void Function(AdWithoutView, RewardItem)? onUserEarnedReward,
  }) async {
    if (rewardedAd == null) {
      if (!context.mounted) return;
      AdmobEasyLogger.info("Ad not ready, attempting to load...");
      await createRewardedAd(context); // Preload before showing again
      return;
    }

    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        if (onAdShowedFullScreenContent != null) {
          onAdShowedFullScreenContent(ad);
        }
        AdmobEasyLogger.success('Rewarded ad shown successfully.');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        if (onAdDismissedFullScreenContent != null) {
          onAdDismissedFullScreenContent(ad);
        }
        ad.dispose();
        rewardedAd = null; // Set to null after disposal
        AdmobEasyLogger.info('Ad dismissed by user. Preloading the next ad...');
        if (context.mounted) {
          createRewardedAd(context); // Preload next ad after dismissal
        }
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        if (onAdFailedToShowFullScreenContent != null) {
          onAdFailedToShowFullScreenContent(ad, error);
        }
        ad.dispose();
        rewardedAd = null;
        AdmobEasyLogger.error('Failed to show rewarded ad: $error');
      },
    );

    await rewardedAd!.show(
      onUserEarnedReward: (adWithoutView, rewardItem) {
        AdmobEasyLogger.success(
            'User earned reward: ${rewardItem.amount} ${rewardItem.type}');
        if (onUserEarnedReward != null) {
          onUserEarnedReward(adWithoutView, rewardItem);
        }
      },
    );
  }
}
