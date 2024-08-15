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

import 'dart:developer';
import 'package:admob_easy/admob_easy.dart';
import 'package:flutter/material.dart';

///  A widget that displays a native ad from AdMob.
class AdmobEasyNative extends StatefulWidget {
  /// The minimum width of the ad.
  final double minWidth;

  /// The minimum height of the ad.
  final double minHeight;

  /// The maximum width of the ad.
  final double maxWidth;

  /// The maximum height of the ad.
  final double maxHeight;

  /// Called when the ad is clicked.
  final void Function(Ad)? onAdClicked;

  /// Called when the ad is impression.
  final void Function(Ad)? onAdImpression;

  /// Called when the ad is closed.
  final void Function(Ad)? onAdClosed;

  /// Called when the ad is opened.
  final void Function(Ad)? onAdOpened;

  /// Called when the ad will dismiss the screen.
  final void Function(Ad)? onAdWillDismissScreen;

  /// Called when the ad receives a paid event.
  final void Function(Ad, double, PrecisionType, String)? onPaidEvent;

  /// A small template for the native ad.
  const AdmobEasyNative.smallTemplate({
    this.minWidth = 320,
    this.minHeight = 90,
    this.maxWidth = 400,
    this.maxHeight = 200,
    super.key,
    this.onAdClicked,
    this.onAdClosed,
    this.onAdImpression,
    this.onAdOpened,
    this.onAdWillDismissScreen,
    this.onPaidEvent,
  });

  /// A medium template for the native ad.
  const AdmobEasyNative.mediumTemplate({
    this.minWidth = 320,
    this.minHeight = 320,
    this.maxWidth = 400,
    this.maxHeight = 400,
    super.key,
    this.onAdClicked,
    this.onAdClosed,
    this.onAdImpression,
    this.onAdOpened,
    this.onAdWillDismissScreen,
    this.onPaidEvent,
  });

  @override
  State<AdmobEasyNative> createState() => _AdmobEasyNativeState();
}

class _AdmobEasyNativeState extends State<AdmobEasyNative> {
  final _nativeAd = ValueNotifier<NativeAd?>(null);
  final _nativeAdIsLoaded = ValueNotifier<bool>(false);

  final _admobEasy = AdmobEasy.instance;

  /// Initializes the native ad.
  Future<void> _init() async {
    if (!_admobEasy.isConnected.value || _admobEasy.nativeAdID.isEmpty) {
      log('Banner ad cannot load');
      _nativeAdIsLoaded.value = false; // Set loading to false if ad cannot load
      return;
    }

    _loadAd();
  }

  /// Loads a native ad.
  void _loadAd() {
    _nativeAd.value = NativeAd(
        adUnitId: _admobEasy.nativeAdID,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            _nativeAdIsLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            log('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          // Called when a click is recorded for a NativeAd.
          onAdClicked: widget.onAdClicked,
          // Called when an impression occurs on the ad.
          onAdImpression: widget.onAdImpression,
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: widget.onAdClosed,
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: widget.onAdOpened,
          // For iOS only. Called before dismissing a full screen view
          onAdWillDismissScreen: widget.onAdWillDismissScreen,
          // Called when an ad receives revenue value.
          onPaidEvent: widget.onPaidEvent,
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.purple,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)));
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _nativeAd.value?.dispose();
    _nativeAdIsLoaded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _nativeAdIsLoaded,
      builder: (context, isAdLoading, child) {
        if (_nativeAd.value == null) {
          // Return empty container if ad failed to load and is not available
          return const SizedBox.shrink();
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: widget.minWidth,
            minHeight: widget.minHeight,
            maxWidth: widget.maxWidth,
            maxHeight: widget.maxHeight,
          ),
          child: AdWidget(
            ad: _nativeAd.value!,
            key: ValueKey(
              _nativeAd.value!.hashCode,
            ), // Ensure the widget is unique
          ),
        );
      },
    );
  }
}
