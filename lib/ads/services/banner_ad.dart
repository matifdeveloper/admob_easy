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

import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/utils/admob_easy_logger.dart';
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
      AdmobEasyLogger.error('Banner ad cannot load');
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
          AdmobEasyLogger.error("Failed to load ad ${error.message}");
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
            ),
          );
        }

        // if (_admobBannerAd == null) {
        //   // Return empty container if ad failed to load and is not available
        //   return const SizedBox.shrink();
        // }

        if (_admobBannerAd == null) {
          // Return container with respective ad size when ad fails to load
          switch (widget.adSize) {
            case AdSize.banner:
              return Container(
                width: 320,
                height: 50,
                color: Colors.grey[300],
                child: const Center(child: Text('Banner Ad')),
              );
            case AdSize.largeBanner:
              return Container(
                width: 320,
                height: 100,
                color: Colors.grey[300],
                child: const Center(child: Text('Large Banner Ad')),
              );
            case AdSize.mediumRectangle:
              return Container(
                width: 300,
                height: 250,
                color: Colors.grey[300],
                child: const Center(child: Text('Medium Rectangle Ad')),
              );
            case AdSize.fullBanner:
              return Container(
                width: 468,
                height: 60,
                color: Colors.grey[300],
                child: const Center(child: Text('Full Banner Ad')),
              );
            case AdSize.leaderboard:
              return Container(
                width: 728,
                height: 90,
                color: Colors.grey[300],
                child: const Center(child: Text('Leaderboard Ad')),
              );
            default:
              return Container(
                width: widget.adSize.width.toDouble(),
                height: widget.adSize.height.toDouble(),
                color: Colors.grey[300],
                child: const Center(child: Text('Ad Placeholder')),
              );
          }
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
