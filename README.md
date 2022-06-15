# Share Whatsapp Plugin

[![pub package](https://img.shields.io/pub/v/share_whatsapp.svg)](https://pub.dartlang.org/packages/share_whatsapp)

A Flutter plugin to share content from your Flutter app to the WhatsApp share dialog.

## Installation

Add to your flutter project :
```
flutter pub add share_whatsapp
```

### iOS Specific Installation
Add this to your `Info.plist` file within `Runner` folder :
```
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>whatsapp</string>
</array>
```
This will ensure that iOS app can use url scheme `whatsapp://`.

## Compatibility

|                                                | Web | Android | iOS | MacOS | Windows | Linux |
|------------------------------------------------|:---:|:-------:|:---:|:-----:|:-------:|:-----:|
| Share Text                                     |  ✅  |    ✅    |  ✅  |   ✅   |    ✅    |   ✅   |
| Share Image                                    |  ❌  |    ✅    |  ✅  |   ❌   |    ❌    |   ❌   |
| Share Text+Image                               |  ❌  |    ✅    |  ❌  |   ❌   |    ❌    |   ❌   |
| Share to Number ⚠️                              |  ✅  |    ✅    |  ❌  |   ✅   |    ✅    |   ✅   |
| Native                                         |     |    ✅    |  ✅  |       |         |       |
| Using [wa.me](https://wa.me) on `url_launcher` |  ✅  |         |     |   ✅   |    ✅    |   ✅   |

> ⚠️ Notes :
> - Mandatory for `Web`, `MacOS`, `Windows` and `Linux`
> - Optional for `Android` only.

## Author
Alann Maulana ([alann-maulana](https://github.com/alann-maulana))