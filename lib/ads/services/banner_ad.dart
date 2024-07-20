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
import 'package:admob_easy/ads/sources.dart';
import 'package:flutter/material.dart';

class AdMobEasyBanner extends StatefulWidget {
  final AdSize adSize;

  const AdMobEasyBanner({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<AdMobEasyBanner> createState() => _AdMobEasyBannerState();
}

class _AdMobEasyBannerState extends State<AdMobEasyBanner> {
  BannerAd? _admobBannerAd;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (!AdmobEasy.instance.isConnected.value) {
      log('No Internet! Banner ad cannot load');
      return;
    }

    BannerAd(
      adUnitId: AdmobEasy.instance.bannerAdID,
      request: const AdRequest(),
      size: widget.adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _admobBannerAd = ad as BannerAd;
            });
          }
        },
        onAdFailedToLoad: (ads, error) {
          log("Failed to load ad ${error.message}");
          ads.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _admobBannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (_, setState) {
      return _admobBannerAd == null
          ? const SizedBox
              .shrink() // Return an empty SizedBox if banner ad is null
          : SizedBox(
              width: _admobBannerAd!.size.width.toDouble(),
              height: _admobBannerAd!.size.height.toDouble(),
              child: AdWidget(
                ad: _admobBannerAd!,
                key: UniqueKey(),
              ),
            );
    });
  }
}
