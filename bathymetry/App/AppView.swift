import ComposableArchitecture
import SwiftUI

// MARK: - AppView
struct AppView: View {
  
  // MARK: static constant
  
  static let padding = CGFloat(16)

  // MARK: property
  
  let store: Store<AppState, AppAction>
  
  var body: some View {
    ZStack {
      ZStack {
        arView
        mapView
      }
      .edgesIgnoringSafeArea(.all)
      
      mapZoomButtons
      waterSurfaceSlider
    }
  }
  
  var arView: some View {
    WithViewStore(store) { viewStore in
      ARView(
        isOn: viewStore.binding(
          get: { $0.arIsOn },
          send: AppAction.arIsOnToggled
        ),
        bathymetryTiles: viewStore.binding(
          get: { $0.bathymetryTiles },
          send: AppAction.bathymetryTilesUpdated
        ),
        bathymetryColors: viewStore.binding(
          get: { $0.bathymetryColors },
          send: AppAction.bathymetryColorsUpdated
        ),
        waterSurface: viewStore.binding(
          get: { $0.waterSurface },
          send: AppAction.waterSurfaceUpdated
        )
      )
    }
  }
  
  var mapView: some View {
    GeometryReader { metrics in
      WithViewStore(store) { viewStore in
        MapView(
          internalMapView: .mapbox,
          bathymetryTiles: viewStore.binding(
            get: { $0.bathymetryTiles },
            send: AppAction.bathymetryTilesUpdated
          ),
          bathymetryColors: viewStore.binding(
            get: { $0.bathymetryColors },
            send: AppAction.bathymetryColorsUpdated
          ),
          zoomLevel: viewStore.binding(
            get: { $0.zoomLevel },
            send: AppAction.zoomLevelUpdated
          )
        )
        .regionDidChange {
          viewStore.send(.loadBathymetries($0))
        }
        .modifier(MapViewModifier(metrics: metrics))
      }
    }
  }
  
  var mapZoomButtons: some View {
    GeometryReader { metrics in
      VStack {
        WithViewStore(store) { viewStore in
          MapZoomButton(
            type: .zoomIn,
            zoomLevel: viewStore.binding(
              get: { $0.zoomLevel },
              send: AppAction.zoomLevelUpdated
            )
          )
          .onTap {
            viewStore.send(.zoomIn)
          }
          MapZoomButton(
            type: .zoomOut,
            zoomLevel: viewStore.binding(
              get: { $0.zoomLevel },
              send: AppAction.zoomLevelUpdated
            )
          )
          .onTap {
            viewStore.send(.zoomOut)
          }
        }
      }
      .offset(
        x: metrics.size.width - MapZoomButton.width - AppView.padding,
        y: metrics.size.height - MapZoomButton.height * 2
      )
    }
  }
  
  var waterSurfaceSlider: some View {
    GeometryReader { metrics in
      VStack {
        WithViewStore(store) { viewStore in
          BathymetryWaterSurfaceSlider(
            waterSurface: viewStore.binding(
              get: { $0.waterSurface },
              send: AppAction.waterSurfaceUpdated
            )
          )
        }
      }
      .offset(
        x: metrics.size.width - BathymetryWaterSurfaceSlider.width - AppView.padding,
        y: metrics.size.height - MapZoomButton.height * 2 - BathymetryWaterSurfaceSlider.height
      )
    }
  }
  
}

// MARK: - AppView_Previews
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      AppView(store: Store(
        initialState: AppState(bathymetryColors: .defaultColors),
        reducer: appReducer,
        environment: AppEnvironment(
          mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
          bathymetryClient: BathymetryContentfulClient()
        )
      ))
      .colorScheme($0)
    }
  }
}
