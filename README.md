# bathymetric-cam-ios

bathymetric-cam is an iOS AR app visualizing depth contour of water.

Depth contour represents a line connecting points of equal depth on ocean floors or lake floors.
If the contour lines spaced narrowly between one and another, it indicates that the area has the steep transition.
This kind of spots is called drop-offs by anglers when targeting a certain type of species like largemouth bass.
The species are also known as the habit preferring to stay at deeper water when the temperature is cold in winter.
bathymetric-cam visualizes the depth contour by the intuitive AR view in order to help you find a better fishing spot.

## Installation

### Embedded Frameworks

As of January 2021, [Mapbox](https://github.com/mapbox/mapbox-gl-native-ios) hasn't done the [Swift Package Manager](https://github.com/apple/swift-package-manager) support yet.
Therefore, [download the SDK manually](https://docs.mapbox.com/ios/maps/guides/install/).
Then drag the frameworks into `Frameworks/` folder.

### Plist Settings

bathymetric-cam uses [Mapbox](https://github.com/mapbox/mapbox-gl-native-ios/tree/main/platform/ios), [Contentful](https://github.com/contentful/contentful.swift), and [Firebase](https://github.com/firebase/firebase-ios-sdk) SDKs.
Each service has the configuration.

Here is how to set them up.

`GoogleService-Info.plist` is a Firebase configuration file for iOS apps. You can download from the Firebase online dashboard.

`Mapbox-Info.plist`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>MGLMapboxAccessToken</key>
    <string>YOUR_ACCESS_TOKEN</string>
</dict>
</plist>
```

`Contentful-Info.plist`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>spaceId</key>
    <string>YOUR_SPACE_ID</string>
    <key>accessToken</key>
    <string>YOUR_ACCESS_TOKEN</string>
</dict>
</plist>
```

The plist files above go to `bathymetry/` folder.

### Contentful

Depth contour data is stored on [Contentful](https://www.contentful.com/).
How to import the data is mentioned [here](https://github.com/bathymetric-cam/bathymetric-cam-contentful).

### Dependency

bathymetric-cam depends on [Mapbox](https://github.com/mapbox/mapbox-gl-native-ios/tree/main/platform/ios) and [Contentful](https://github.com/contentful/contentful.swift).
If your application needs to support other map frameworks like [GoogleMaps](https://developers.google.com/maps/documentation/ios-sdk/overview) or other API clients, you can make your own implementation that conforms to MapView and BathymetryClient's protocol.
