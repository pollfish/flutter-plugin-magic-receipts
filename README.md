# magic_receipts

Magic Receipts Flutter plugin, allows integration of Magic Receipts into Flutter Android and iOS apps.

# Prerequisites

* Android SDK 21 or higher using Google Play Services 
* iOS version 11.0 or higher 
* Flutter version 1.20.0 or higher 
* Dart SDK version 2.12.0 or higher 
* CocoaPods version 1.10.0 or higher

<br/>

# Quick Guide

1. [Create a Pollfish Developer Account](#1-create-a-pollfish-developer-account)
2. [Register a new App on Pollfish Developer Dashboard and copy the given API Key](#2-register-a-new-app-for-each-targeting-platform-on-pollfish-developer-dashboard-and-copy-the-given-api-keys)
3. [Enable Magic Receipts in your account](#3-enable-magic-receipts-in-your-account)
4. [Download and import Magic Receipts library into your project](#4-download-and-import-magic-receipts-package-into-your-project)
5. [Import Magic Receipts classes](#5-import-magic-receipts-package)
6. [Configure and initialize Magic Receipts SDK](#6-configure-and-initialize-magic-receipts-sdk)

Optional

7. [Listen for Magic Receipts lifecycle events](#7-listen-for-magic-receipts-lifecycle-events)
8. [Control the SDK](#8-control-the-sdk)
9. [Configure postbacks](#postbacks)

<br/>

# Detailed Steps

## 1. Create a Pollfish Developer Account

Register as a Publisher at [pollfish.com](https://pollfish.com/login/publisher)

<br/>

## 2. Register a new App for each targeting platform on Pollfish Developer Dashboard and copy the given API Keys

Login at [www.pollfish.com](https://pollfish.com/login/publisher) and click "Add a new app" on Pollfish Developer Dashboard. Copy then the given API key for this app in order to use later on, when initializing Pollfish within your code.

<br/>

## 3. Enable Magic Receipts in your account

In your App setting scroll till you find the **Ads in survey end pages** and enable the feature switch.

<img style="margin: 0 auto; display: block;" src="resources/enable.png"/>

<br/>

## 4. Download and import Magic Receipts package into your project

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  ...
  magic_receipts: ^1.0.0
```

Execute the following command

```
flutter packages get
```

<br/>

## 5. Import Magic Receipts package

Import Magic Receipts package:

```dart
import 'package:magic_receipts/magic_receipts.dart';
```

<br/>

## 6. Configure and initialize Magic Receipts SDK

The Magic Receipts plugin must be initialized with one or two api keys depending on which platforms are you targeting. You can retrieve an API key from Pollfish Dashboard when you sign up and create a new app.

```dart
MagicReceipts.initialize(androidApiKey: 'ANDROID_API_KEY', iOSApiKey: 'IOS_API_KEY', rewardMode: true); // Android and iOS
```

```dart
MagicReceipts.initialize(androidApiKey: 'ANDROID_API_KEY', iOSApiKey: null, rewardMode: true); // Android only
```

```dart
MagicReceipts.initialize(androidApiKey: null, iOSApiKey: 'IOS_API_KEY', rewardMode: true); // iOS only
```

<br/>

You can set several params to control the behaviour of Magic Receipts survey panel within your app wih the use of the various optional arguments of the initialization function. Below you can see all the available options.

| No  |                          | Description                                                                                                               |
|-----|--------------------------|---------------------------------------------------------------------------------------------------------------------------|
| 6.1 | **`String userId`**      | A unique id to identify the user.                                                                                         |
| 6.2 | **`bool incentiveMode`** | Control the visibility of the Magic Receipts indicator.                                                                   |
| 6.3 | **`String clickId`**     | A pass throught parameter that will be passed back through server-to-server [postback](#postbacks) to identify the click. |

<br/>

### **6.1 `String userId`**

A unique id to identify the user.

<span style="color: red">You can pass the id of a user as identified on your system. Magic Receipts will use this id to identify the user across sessions instead of an ad id/idfa as advised by the stores. You are solely responsible for aligning with store regulations by providing this id and getting relevant consent by the user when necessary. Magic Receipts takes no responsibility for the usage of this id. In any request from your users on resetting/deleting this id and/or profile created, you should be solely liable for those requests.</span>

<br/>

<span style="text-decoration: underline">Kotlin:</span>

```dart
MagicReceipts.initialize(
  ...
  userId: "USER_ID"
);
```

<br/>

By skipping providing a `userId` value, the SDK will try to retrieve the Advertising ID of the device and use that in order to identify the user. In that case depending on your platform you should include the corresponding Advertising framework into your project in order to access the device's advertising id.

**iOS 14+**

In iOS 14+ you should request for IDFA Permission using the AppTrackingTransparency framework prior to SDK initialization.

<br/>

**Android**

Further details regarding integration with the Google Play services library can be found [here](https://developers.google.com/android/guides/setup).

If you are using gradle you can easily add in your dependencies:

```groovy
dependencies {
    ...
    implementation 'com.google.android.gms:play-services-ads-identifier:18.0.1'
}
```

<br/>

**Android 12**

Apps updating their target API level to 31 (Android 12) or higher will need to declare a Google Play services normal permission in the AndroidManifest.xml file.

```xml
<uses-permission android:name="com.google.android.gms.permission.AD_ID" />
```

You can read more about Google Advertising ID changes [here](https://support.google.com/googleplay/android-developer/answer/6048248).

<br/>

### **6.2. `bool incentiveMode`**

Initializes Magic Receipts SDK in incentivised mode. This means that Magic Receipts Indicator will not be shown and the Magic Receipts offer wall will be automatically hidden until the publisher explicitly calls `.show()` function (The publisher should wait for the `wallLoadedListener` callback). This behaviour enables the option for the publisher, to show a custom prompt to incentivize the user to participate.

<br/>

<span style="text-decoration: underline">Kotlin:</span>

```dart
MagicReceipts.initialize(
  ...
  incentiveMode: true
);
```

<br/>

### **6.3. `String clickId`**

A pass through param that will be passed back through server-to-server [postbacks](#postbacks) in order to identify the click.

<br/>

span style="text-decoration: underline">Kotlin:</span>

```dart
MagicReceipts.initialize(
  ...
  clickId: "CLICK_ID"
);
```

<br/>

# Optional section

## 7. Listen for Magic Receipts lifecycle events

In order to get notified for Magic Receipts lifecycle events you will have to register and listen to the appropriate listeners.

<br/>

### 7.1. Get notified when the SDK has loaded

You can get notified when the SDK has loaded by setting the `MagicReceiptsWallLoadedListener`.

```dart
MagicReceipts.setMagicReceiptsWallLoadedListener(_onMagicReceiptsWallLoaded);

_onMagicReceiptsWallLoaded() {
  ...
}
```

<br/>

### 7.2. Get notified when the Magic Receipts has failed to load

You can get notified when the Magic Receipts has failed to load by setting the `MagicReceiptsWallFailedToLoadListener`.

```dart
 MagicReceipts.setMagicReceiptsWallLoadFailedListener(_onMagicReceiptsWallLoadFailed);

_onMagicReceiptsWallLoadFailed(MagicReceiptsLoadError error) {
  ...
}
```

<br/>

### 7.3. Get notified when the Magic Receipts wall has opened

You can get notified when the Magic Receipts wall has opened by setting the `MagicReceiptsWallShowedListener`.

```dart
MagicReceipts.setMagicReceiptsWallShowedListener(_onMagicReceiptsWallShowed);

_onMagicReceiptsWallShowed() {
  ...
}
```

<br/>

### 7.4. Get notified when the Magic Receipts wall has failed to show

You can get notified when the Magic Receipts wall has failed to show by setting the `MagicReceiptsWallShowFailedListener`.

```dart
MagicReceipts.setMagicReceiptsWallShowFailedListener(_onMagicReceiptsWallShowFailed);

_onMagicReceiptsWallShowFailed(MagicReceiptsShowError error) {
  ...
}
```

<br/>

### 7.5. Get notified when the Magic Receipts wall has closed

You can get notified when the Magic Receipts wall has closed by setting the `MagicReceiptsWallHiddenListener`.

```dart
MagicReceipts.setMagicReceiptsWallHiddenListener(_onMagicReceiptsWallHid);

_onMagicReceiptsWallHid() {
  ...
}
```

<br/>

## 8. Control the SDK

### 8.1. Manually show/hide Magic Receipts views

You can manually hide or show Magic Receipts offer wall or indicator by calling the following methods after initialization:

#### 8.1.1. Show

```dart
MagicReceipts.show()
```

#### 8.1.2. Hide

```dart
MagicReceipts.hide()
```

<br/>

### 8.2. Check if Magic Receipts SDK is ready

At anytime you can check whether the Magic Receipts SDK is ready to show the wall or not.

```dart
MagicReceipts.isReady().then((isReady) => {
  ...
});
```

# Postbacks

You can easily setup postbacks in order to receive a notifications when a conversion has happened.

## 9.1. Configure your Postback URL

You can set a Server-to-Server webhook URL through Pollfish developer dashboard, in your app's page. On every conversion we will perform a HTTP GET request to this URL.

<img style="margin: 0 auto; display: block;" src="resources/postbacks.png"/>

<br/>

> **Note:** You should use this call to verify a conversion if you reward your users for their action. This is the only 100% accurate and secure way to monitor conversions through your app.

<br/>

Server-to-server callbacks can be used to retrieve several information regarding a conversion. Below there is a list of all the available tempate params you can use to configure your Postback URL.

Parameter name | Type | Description
---------------|------|------------
click_id       |String| The pass-through parameter used to identify the click
cpa            |Int   | Money earned from conversion in USD
device_id      |String| User/Device identifier
timestamp      |Long  | Transaction timestamp
tx_id          |String| Unique transaction identifier
signature      |String| A Base64 Url encoded string securing the above parameters

<br/>

## 9.2. Uniquely identify a conversion and avoiding duplicates

Mistakes may happen, and you may receive multiple callbacks for the same conversion. You can avoid those duplicates by checking the tx_id param. This identifier is unique per conversion transaction.

<br/>

## 9.3. Secure your postbacks

You can secure your callback by adding the signature template parameter in your callback URL. In addition you will have to include at least one of the rest supported template parameters because signing is happening on the parameters and not on the url.

```
http://www.example.com/callback?tx_id=[[tx_id]]&time=[[timestamp]]&cpa=[[cpa]]&device=[[device_id]]&click_id=[[click_id]]&sig=[[signature]]
```

<br/>

### 9.3.1 How signatures are produced

The signature of the callback URLs is the result of appling the HMAC-SHA1 hash function to the [[parameters]] that are included in the URL using your account's secret_key.

We only sign the values that are substituted using the parameters placeholders `[[click_id]]`, `[[cpa]]`, `[[device_id]]`, `[[timestamp]]` and `[[tx_id]]`. We do not sign any other part of the URL including any other URL parameters that the publisher might specify.

Your secret_key is an auto-generated key by Pollfish that serves as a shared secret between the publisher and Pollfish. You can find out more about your secret_key at the Account Information page.

To sign the parameters they are assembled in alphabetical order using the parameter placeholder names in a string by concatenating them using the colon `:` character. For example if you have the follwing URL template:

```
https://www.example.com?device_id=[[device_id]]&cpa=[[cpa]]&timestamp=[[timespamp]]&tx_id=[[tx_id]]&click_id=[[click_id]]&signature=[[signature]]
```

with this as a secret key

```
4dd95289-3961-4a1f-a216-26fa0f99ca87
```

Then the produced string, that will be the input to HMAC-SHA1, will have the pattern:

```
click_id:cpa:device_id:timestamp:tx_id
```

Furthermore if we have the following values: `device_id=my-device-id`, `cpa=30`, `timestamp=1463152452308`, `click_id=a-unique-click-id` and `tx_id=123456789` the string that will be the input to HMAC-SHA1 will be:

```
a-unique-click-id:30:my-device-id:1463152452308:123456789
```

and the produced callback URL will be:

```
https://www.example.com?device_id=my-device-id&cpa=30&timestamp=1463152452308&tx_id=123456789&click_id=a-unique-click-id&signature=h4utQ%2Fi9u7VGTyf9BGi37A08cIE%3D
```

Please note that the string is created using the parameter values before they are URL encoded.

Additionally since `click_id` is an optional parameter that might be skipped during the SDK initialization and you have defined the corresponding template parameter in your callback URL, then it should be included in the signature calculation with an empty value, So your signing payload should match the following

```
:30:my-device-id:1463152452308:123456789
```

<br/>

### 9.3.2 How to verify signatures

To verify the signature in server-to-server postback calls follow the below proceedure:

1. Extract the value of the signature parameter from the URL.
2. URL decode the value you extracted in (1) using Percent encoding
3. Extract the values of the rest of the parameters URL.
4. URL decode the values you extracted in (3) using Percent encoding.
5. Sort the values from (4) alphabeticaly using the names of the template parameters. The names of the template parameters in sorted order are: click_id, cpa, device_id, timestamp, tx_id and not the names of any URL parameters your URL may contain.
6. Produce a string by concatenating all non-empty parameter values as sorted in the previous step using the `:` character. The only parameter that when specified in the URL template can be empty is `click_id`. There is a special handling for term_reason: If the user is non-eligible then it has one of the values described in section 6 and with that value is included in the callback url and the signature calculation. If however the user is eligible the term is included but with an empty value and must participate in the signature calculation. An example of a callback url for an eligible user is https://mybaseurl.com?device_id=my-device-id&term_reason=&cpa=30 which gives the string 30:my-device-id: for signature calculation. The trailing : is because of the empty term_reason
7. Sign the string produced in (6) using the HMAC-SHA1 algorithm and your account's secret_key that can be retrieved from the Account Information page.
8. Encode the value produced in (7) using Base64. Please note that the input to the Base64 function must be the raw byte array output of HMAC-SHA1 and not a string representation of it.
9. Compare the values produced in (2) and (8). If they are equal then the signature is valid.

<br/>

## 9.4. Check postback logs

You can check logs from your s2s callbacks history simply by navigating to End Page Ads -> Monitoring page on your Dashboard.

<img style="margin: 0 auto; display: block;" src="resources/logs.png"/>

In this page you will find all callbacks generated from Pollfish servers for your app, sorted by date. You can easily track the status of each call and response from you server side. Each call in the logs is clickable and you can also search for a specific callback based on specific params of your url structure.