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

    Created by Muhammad Atif on 05/01/2024 : 11:40 pm.
    Portfolio https://atifnoori.web.app.
    +923085690603

 ********************************************************************************
 */

import 'dart:async';
import 'dart:developer';
import 'package:async_preferences/async_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobUmp {
  // Singleton instance for AdmobHelper.
  static AdmobUmp instance = AdmobUmp._privateConstructor();

  // Private constructor for singleton pattern.
  AdmobUmp._privateConstructor();

  /// Initializes Admob and handles consent forms if applicable.
  /// Returns a Future<FormError?> indicating the result of the initialization.
  Future<FormError?> initializeUMP(List<String>? testDeviceIds) async {
    final completer = Completer<FormError?>();
    final params = ConsentRequestParameters(
        consentDebugSettings: ConsentDebugSettings(
      debugGeography: DebugGeography.debugGeographyEea,
    ));

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          // Load Consent form if available.
          await _loadConsentForm(testDeviceIds);
        } else {
          // Continue with regular initialization.
          await _initialize(testDeviceIds);
        }
        completer.complete();
      },
      (error) {
        // Handle error during consent info update.
        completer.complete(error);
      },
    );
    return completer.future;
  }

  /// Opens the privacy preferences screen for the user to manage consent.
  /// Returns a Future<bool> indicating whether the user successfully updated their preferences.
  Future<bool> changePrivacyPreferences(List<String>? testDeviceIds) async {
    final completer = Completer<bool>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          ConsentForm.loadConsentForm(
            (consentForm) {
              consentForm.show((formError) async {
                // Continue with initialization after consent form is shown.
                await _initialize(testDeviceIds);
                completer.complete(true);
                log('');
              });
            },
            (formError) {
              // Handle error loading consent form.
              completer.complete(false);
            },
          );
        } else {
          completer.complete(false);
        }
      },
      (error) {
        // Handle error during consent info update.
        completer.complete(false);
      },
    );
    return completer.future;
  }

  /// Loads and displays the consent form if user consent is required.
  /// Returns a Future<FormError?> indicating the result of the operation.
  Future<FormError?> _loadConsentForm(List<String>? testDeviceIds) async {
    final completer = Completer<FormError?>();

    ConsentForm.loadConsentForm(
      (consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          // Show consent form if consent is required.
          consentForm.show((formError) {
            // Reload consent form if an error occurs during showing.
            completer.complete(_loadConsentForm(testDeviceIds));
          });
        } else {
          // Continue with initialization if consent is not required.
          await _initialize(testDeviceIds);
          completer.complete();
        }
      },
      (formError) {
        // Handle error loading consent form.
        completer.complete(formError);
      },
    );
    return completer.future;
  }

  /// Initializes MobileAds for ad support.
  Future<void> _initialize(List<String>? testDeviceIds) async {
    MobileAds.instance
      ..initialize()
      ..updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: []),
      );
  }

  /// Checks whether the user is under the jurisdiction of the General Data Protection Regulation (GDPR).
  /// Returns a Future<bool> indicating whether GDPR applies to the user.
  /// call [isUnderGPR] where you needed like [late final Future<bool> isUnderGPR]
  /// then [isUnderGPR = isUnderGPR();]
  Future<bool> isUnderGPR() async {
    final preferences = AsyncPreferences();
    // Check if the 'IABTCF_gdprApplies' preference is set to 1 (indicating GDPR applies).
    return await preferences.getInt('IABTCF_gdprApplies') == 1;
  }
}
