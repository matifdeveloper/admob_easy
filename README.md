# Admob Easy

This documentation guides integrating ads into a Flutter application using the provided helper classes.  
AdMob Easy automatically handles the User Messaging Platform (UMP) for you, ensuring compliance with privacy regulations.

---

## Android Manifest File (Android)
```xml
<manifest>
    ...
    <application>
       ...
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-3940256099942544~3347511713"/>
    </application>
</manifest>
```

---

## iOS Info.plist File (iOS)
```xml
...
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
...
```

---

## Initialize MobileAds
To enable ad support, initialize **AdmobEasy** in the Splash Screen by providing the necessary ad unit IDs and test devices:

```dart
AdmobEasy.instance.initialize(
  androidRewardedAdID: 'ca-app-pub-3940256099942544/5224354917',
  androidInitAdID: 'ca-app-pub-3940256099942544/1033173712',
  androidBannerAdID: 'ca-app-pub-3940256099942544/6300978111',
  androidAppOpenAdID: 'ca-app-pub-3940256099942544/9257395921',
  testDevices: ['543E082C0B43E6BF17AF6D4F72541F51'],
);
```

---

## Load Ads
Use the provided methods to load ads:

```dart
AdmobEasy.instance.createRewardedAd(context);    // Load rewarded ad
AdmobEasy.instance.createInterstitialAd(context); // Load Interstitial ad
AdmobEasy.instance.loadAppOpenAd();              // Load App Open Ad (shows automatically after load)
```

---

## Show Ads
Once ads are loaded, show them using:

```dart
AdmobEasy.instance.showRewardedAd(context);
AdmobEasy.instance.showInterstitialAd(context);
```

---

# Native Ads (New API)

Native ads are now handled via methods mixed directly into `AdmobEasy`.  
You can **preload**, **show**, and **dispose** native ads with full control.

---

## Load a Native Ad
```dart
AdmobEasy.instance.loadNativeAd(
  templateType: TemplateType.medium,
  minWidth: 320,
  minHeight: 90,
  maxWidth: 400,
  maxHeight: 200,
  adID: "ca-app-pub-3940256099942544/2247696110", // optional custom ID
  onAdClicked: (ad) => print("Ad Clicked"),
  onAdImpression: (ad) => print("Ad Impression Logged"),
  onAdClosed: (ad) => print("Ad Closed"),
  onAdOpened: (ad) => print("Ad Opened"),
  onAdWillDismissScreen: (ad) => print("Ad will dismiss screen"),
  onPaidEvent: (ad, value, precision, currencyCode) {
    print("Paid event: $value $currencyCode (precision: $precision)");
  },
);
```

---

## Show a Native Ad
Once preloaded, show it anywhere in the widget tree:

```dart
class NativeAdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Native Ad Example')),
      body: Center(
        child: AdmobEasy.instance.showNativeAd(
          minWidth: 320,
          minHeight: 90,
          maxWidth: 400,
          maxHeight: 200,
        ),
      ),
    );
  }
}
```

---

## Dispose a Native Ad
When you no longer need the preloaded ad:

```dart
@override
void dispose() {
  AdmobEasy.instance.disposeNative();
  super.dispose();
}
```

---

## Parameters

- **`adID`** → Custom AdMob Unit ID (if null, defaults to `AdmobEasy.instance.nativeAdID`).
- **`templateType`** → Choose between `TemplateType.small` or `TemplateType.medium`.
- **`minWidth`, `minHeight`, `maxWidth`, `maxHeight`** → Controls the size of the ad container.
- **`onAdClicked`** → Callback when the ad is clicked.
- **`onAdImpression`** → Callback when an ad impression is logged.
- **`onAdClosed`** → Callback when the ad is closed.
- **`onAdOpened`** → Callback when the ad is opened.
- **`onAdWillDismissScreen`** → Callback when the ad is about to dismiss the screen.
- **`onPaidEvent`** → Callback for handling paid events from the ad.

---

# Best Practices for Native Ads

✅ **Preload early** – Call `loadNativeAd()` on your splash screen or just before the screen where the ad will be shown.  
✅ **Dispose when unused** – Always call `disposeNative()` when leaving the screen to free memory.  
✅ **Avoid multiple preload calls** – The mixin ensures only one native ad is preloaded at a time.  
✅ **Handle callbacks** – Use `onAdClicked`, `onAdImpression`, and `onPaidEvent` to track engagement and revenue.  
✅ **Fallback UI** – If no ad is preloaded, `showNativeAd()` automatically shows a loading placeholder.

---

# Internet Connectivity

Admob Easy automatically checks if the device is online before loading ads.

You can check connectivity manually:

```dart
AdmobEasy.instance.isConnected.value; // true if connected
```

Or use a listener:

```dart
ValueListenableBuilder(
  valueListenable: ConnectivityController.instance.isConnected,
  builder: (_, value, child) {
    return Text(value ? "Connected" : "No Internet");
  },
);
```

You can also initialize connectivity monitoring:

```dart
AdmobEasy.instance.initConnectivity(
  onOnline: () => print("Online"),
  onOffline: () => print("Offline"),
);
```

---

# Support

If you find this package useful and want to support its development, you can buy me a coffee:

[![Buy Me a Coffee](https://www.buymeacoffee.com/assets/img/custom_images/black_img.png)](https://www.paypal.com/ncp/payment/D56UA3TJ5LQ7G)

Thank you for your support!

---

### Contributions are welcome!
Feel free to submit **bug reports, feature requests, or pull requests** on [GitHub](https://github.com/matifdeveloper/admob_easy).
