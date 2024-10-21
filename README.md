## **Admob Easy**

This documentation guides integrating ads into a Flutter application using the provided helper classes. AdMob Easy automatically handles the User Messaging Platform (UMP) for you, ensuring compliance with privacy regulations.

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
To enable ad support, In the Splash Screen initialize the AdmobEasy by providing the necessary ad unit IDs and test devices:
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
AdmobEasy.instance.loadAppOpenAd(); // To load an open app ad it will show the ad automatically after load
```

### Show Ads
Once ads are loaded, show them using the respective methods:
```
AdmobEasy.instance.showRewardedAd(context);
AdmobEasy.instance.showInterstitialAd(context);
```


## **AdmobEasyNative Widget**

The `AdmobEasyNative` widget provides a simple way to display native ads in your Flutter application using Admob. It allows for two types of ad templates, `small` and `medium`, which are ideal for different ad placements within the UI.

### Usage

You can integrate `AdmobEasyNative` as either a small or medium template by specifying the relevant constructor:

#### Example (Small Native Ad):
```
AdmobEasyNative.smallTemplate(
  minWidth: 320,
  minHeight: 90,
  maxWidth: 400,
  maxHeight: 200,
  onAdClicked: (ad) => print("Ad Clicked"),
  onAdImpression: (ad) => print("Ad Impression Logged"),
  onAdClosed: (ad) => print("Ad Closed"),
);
```

#### Example (Medium Native Ad):
```
AdmobEasyNative.mediumTemplate(
  minWidth: 320,
  minHeight: 320,
  maxWidth: 400,
  maxHeight: 400,
  onAdOpened: (ad) => print("Ad Opened"),
  onAdClosed: (ad) => print("Ad Closed"),
  onPaidEvent: (ad, value, precision, currencyCode) {
    print("Paid event: $value $currencyCode with precision: $precision");
  },
);
```

### Parameters:

- `minWidth`: Minimum width of the native ad.
- `minHeight`: Minimum height of the native ad.
- `maxWidth`: Maximum width of the native ad.
- `maxHeight`: Maximum height of the native ad.
- `onAdClicked`: Callback when the ad is clicked.
- `onAdImpression`: Callback when the ad impression is logged.
- `onAdClosed`: Callback when the ad is closed.
- `onAdOpened`: Callback when the ad is opened.
- `onAdWillDismissScreen`: Callback when the ad is about to dismiss the screen.
- `onPaidEvent`: Callback for handling paid events from the ad.

### Example Implementation:
```
class NativeAdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Native Ad Example')),
      body: Center(
        child: AdmobEasyNative.smallTemplate(
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

By incorporating `AdmobEasyNative`, you can easily display native ads to users, customize their size, and handle ad events like clicks and impressions for improved engagement and monetization.


### Internet Connectivity
Admob Easy now automatically checks if the device is connected to mobile data or Wi-Fi before loading ads. Additionally, users can check internet connectivity status using the following methods:<br/>
`AdmobEasy.instance.isConnected.value; // Returns true if connected, false otherwise`

or

```
ValueListenableBuilder(
  valueListenable: ConnectivityController.instance.isConnected,
  builder: (_, value, child) {
    return Text(value ? "Connected" : "No Internet");
  },
);
```
You can also initialize connectivity checking using:<br />
`AdmobEasy.instance.initConnectivity(onOnline(){}, onOffline(){});`

## Support

If you find this package useful and want to support its development, you can buy me a coffee:

[![Buy Me a Coffee](https://www.buymeacoffee.com/assets/img/custom_images/black_img.png)](https://www.paypal.com/ncp/payment/D56UA3TJ5LQ7G)

Thank you for your support!

### Contributions are welcome! Feel free to submit bug reports, feature requests, or pull requests on <a href="https://github.com/matifdeveloper/admob_easy">GitHub</a>.
