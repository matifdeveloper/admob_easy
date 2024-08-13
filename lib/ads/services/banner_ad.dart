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

    Created by Muhammad Atif on 05/01/2024 : 11:51 pm.
    Portfolio https://atifnoori.web.app.
    +923085690603

 ********************************************************************************
 */

import 'dart:developer';
import 'package:admob_easy/ads/admob_easy.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

enum CollapseGravity {
  top,
  bottom,
}

class AdMobEasyBanner extends StatefulWidget {
  final AdSize adSize;
  final bool isCollapsible;
  final CollapseGravity collapseGravity;

  const AdMobEasyBanner({
    super.key,
    this.adSize = AdSize.banner,
    this.isCollapsible = false,
    this.collapseGravity = CollapseGravity.bottom,
  });

  @override
  State<AdMobEasyBanner> createState() => _AdMobEasyBannerState();
}

class _AdMobEasyBannerState extends State<AdMobEasyBanner> {
  BannerAd? _admobBannerAd;
  final ValueNotifier<bool> _isAdLoading = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (!AdmobEasy.instance.isConnected.value ||
        AdmobEasy.instance.bannerAdID.isEmpty) {
      log('Banner ad cannot load');
      _isAdLoading.value = false; // Set loading to false if ad cannot load
      return;
    }

    _loadBannerAd();
  }

  void _loadBannerAd() {
    _isAdLoading.value = true;

    _admobBannerAd?.dispose();
    _admobBannerAd = BannerAd(
      adUnitId: AdmobEasy.instance.bannerAdID,
      request: AdRequest(
        extras: widget.isCollapsible
            ? {"collapsible": widget.collapseGravity.name}
            : null,
      ),
      size: widget.adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            _admobBannerAd = ad as BannerAd;
            _isAdLoading.value = false;
          }
        },
        onAdFailedToLoad: (ad, error) {
          log("Failed to load ad ${error.message}");
          ad.dispose();
          _admobBannerAd = null;
          _isAdLoading.value = false;
          // Retry loading the ad after some delay
          Future.delayed(const Duration(seconds: 10), _loadBannerAd);
        },
      ),
    );

    _admobBannerAd!.load();
  }

  @override
  void dispose() {
    _admobBannerAd?.dispose();
    _isAdLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isAdLoading,
      builder: (context, isAdLoading, child) {
        if (isAdLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: widget.adSize.width.toDouble(),
              height: widget.adSize.height.toDouble(),
              color: Colors.white,
              child: Center(
                child: Text(
                  'Ad',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        }

        if (_admobBannerAd == null) {
          // Return empty container if ad failed to load and is not available
          return const SizedBox.shrink();
        }

        return SizedBox(
          width: _admobBannerAd!.size.width.toDouble(),
          height: _admobBannerAd!.size.height.toDouble(),
          child: AdWidget(
            ad: _admobBannerAd!,
            key: ValueKey(
              _admobBannerAd!.hashCode,
            ), // Ensure the widget is unique
          ),
        );
      },
    );
  }
}
