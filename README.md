## **Admob Easy**

This documentation provides guidance on integrating ads into a Flutter application using the provided helper classes.

To integrate ads into your Flutter application, follow these steps:

### Android Manifest File (Android)
```
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

### iOS Info.plist File (iOS)
```
...
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
...
```

### Initialize MobileAds
To enable ad support, initialize MobileAds by providing the necessary ad unit IDs and test devices:
```
AdmobEasy.instance.initialize(
  androidRewardedAdID: 'ca-app-pub-3940256099942544/5224354917',
  androidInitAdID: 'ca-app-pub-3940256099942544/1033173712',
  androidBannerAdID: 'ca-app-pub-3940256099942544/6300978111',
  androidAppOpenAdID: 'ca-app-pub-3940256099942544/9257395921',
  testDevices: ['543E082C0B43E6BF17AF6D4F72541F51']
);
```

### Load Ads
Use the provided methods to create ad instances and load ads:
```
AdmobEasy.instance.createRewardedAd(context); // To load rewarded ad
AdmobEasy.instance.createInterstitialAd(context); // To load Interstitial ad
AdmobEasy.instance.loadAppOpenAd(); // To load open app ad it will show the ad automatically after load
```

### Show Ads
Once ads are loaded, show them using the respective methods:
```
AdmobEasy.instance.showRewardedAd(context);
AdmobEasy.instance.showInterstitialAd(context);
```
