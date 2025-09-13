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

    Created by Muhammad Atif on 15/08/2024.
    Portfolio https://atifnoori.web.app.
    Islo-AI

 ********************************************************************************
 */

import 'package:admob_easy/admob_easy.dart';
import 'package:flutter/material.dart';

mixin EasyNativeAd {
  NativeAd? _preloadedAd;

  /// Preload the ad once
  void loadNativeAd({
    required TemplateType templateType,
    required double minWidth,
    required double minHeight,
    required double maxWidth,
    required double maxHeight,
    String? adID,
    void Function(Ad)? onAdClicked,
    void Function(Ad)? onAdImpression,
    void Function(Ad)? onAdClosed,
    void Function(Ad)? onAdOpened,
    void Function(Ad)? onAdWillDismissScreen,
    void Function(Ad, double, PrecisionType, String)? onPaidEvent,
  }) {
    if (_preloadedAd != null) return; // Already preloaded

    final adUnit = adID ?? AdmobEasy.instance.nativeAdID;

    if (adUnit.isEmpty) {
      AdmobEasyLogger.error("Native Ad ID is empty");
      return;
    }

    final ad = NativeAd(
      adUnitId: adUnit,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _preloadedAd = ad as NativeAd;
          AdmobEasyLogger.success("Preloaded Native Ad (ID: $adUnit)");
        },
        onAdFailedToLoad: (ad, error) {
          _preloadedAd = null;
          ad.dispose();
          AdmobEasyLogger.error("Failed to preload Native Ad: $error");
        },
        onAdClicked: onAdClicked,
        onAdImpression: onAdImpression,
        onAdClosed: onAdClosed,
        onAdOpened: onAdOpened,
        onAdWillDismissScreen: onAdWillDismissScreen,
        onPaidEvent: onPaidEvent,
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(templateType: templateType),
    );

    ad.load();
  }

  /// Show the preloaded ad
  Widget showNativeAd({
    required double minWidth,
    required double minHeight,
    required double maxWidth,
    required double maxHeight,
  }) {
    if (_preloadedAd == null) {
      return Container(
        width: minWidth,
        height: minHeight,
        color: Colors.white,
        alignment: Alignment.topLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFFE88F1A),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            child: Text(
              'Ad',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth,
        minHeight: minHeight,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      child: AdWidget(ad: _preloadedAd!),
    );
  }

  /// Dispose the preloaded ad
  void disposeNative() {
    _preloadedAd?.dispose();
    _preloadedAd = null;
    debugPrint("🗑️ Preloaded Native Ad disposed");
  }
}
