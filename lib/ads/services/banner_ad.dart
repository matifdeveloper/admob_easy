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
  bool _isAdLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (!AdmobEasy.instance.isConnected.value ||
        AdmobEasy.instance.bannerAdID.isEmpty) {
      log('Banner ad cannot load');
      return;
    }

    _loadBannerAd();
  }

  void _loadBannerAd() {
    setState(() {
      _isAdLoading = true;
    });

    _admobBannerAd?.dispose();
    _admobBannerAd = BannerAd(
      adUnitId: AdmobEasy.instance.bannerAdID,
      request: const AdRequest(),
      size: widget.adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _admobBannerAd = ad as BannerAd;
              _isAdLoading = false;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          log("Failed to load ad ${error.message}");
          ad.dispose();
          setState(() {
            _isAdLoading = false;
          });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: widget.adSize.width.toDouble(),
              height: widget.adSize.height.toDouble(),
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Text(
                      'Ad',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox(
            width: _admobBannerAd!.size.width.toDouble(),
            height: _admobBannerAd!.size.height.toDouble(),
            child: AdWidget(
              ad: _admobBannerAd!,
              key: ValueKey(
                  _admobBannerAd!.hashCode), // Ensure the widget is unique
            ),
          );
  }
}
