<p align="center">
  <img src="https://avatars.githubusercontent.com/u/77539627?u=f07a00cbf7503ce555bdf8848cdacb31705e801c" width="120" alt="App Icon" />
</p>

# bathymetric-cam-ios

[![CircleCI](https://circleci.com/gh/bathymetric-cam/bathymetric-cam-ios/tree/main.svg?style=svg)](https://circleci.com/gh/bathymetric-cam/bathymetric-cam-ios/tree/main)

bathymetric-cam is an AR app visualizing depth contour of water for anglers.

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

bathymetric-cam uses [Mapbox](https://github.com/mapbox/mapbox-gl-native-ios/tree/main/platform/ios) and [map tile server](https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Tile_servers).
Each service has the configuration.

Here is how to set them up.

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

`TileAPI-Info.plist`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>baseUrl</key>
    <string>YOUR_API_BASE_URL</string>
</dict>
</plist>
```

The plist files above go to `bathymetry/` folder.

### Dependency

bathymetric-cam depends on [Mapbox](https://github.com/mapbox/mapbox-gl-native-ios/tree/main/platform/ios) and [map tile server](https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Tile_servers).
If your application needs to support other map frameworks like [GoogleMaps](https://developers.google.com/maps/documentation/ios-sdk/overview) and other map tile client, you can make your own implementation that conforms to MapView's protocol and BathymetryTileClient's protocol.
