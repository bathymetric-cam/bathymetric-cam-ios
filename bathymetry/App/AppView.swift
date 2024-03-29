import ComposableArchitecture
import SwiftUI

// MARK: - AppView
struct AppView: View {

  // MARK: property
  
  let store: Store<AppState, AppAction>
  
  let padding = CGFloat(16)
  let space = CGFloat(16)
  
  var body: some View {
    ZStack {
      ZStack {
        arView
        mapView
      }
      .edgesIgnoringSafeArea(.all)
      
      arWaterSurfaceView
      mapZoomView
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
        bathymetries: viewStore.binding(
          get: { $0.bathymetries },
          send: AppAction.bathymetriesUpdated
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
          bathymetries: viewStore.binding(
            get: { $0.bathymetries },
            send: AppAction.bathymetriesUpdated
          ),
          zoomLevel: viewStore.binding(
            get: { $0.zoomLevel },
            send: AppAction.zoomLevelUpdated
          ),
          region: viewStore.binding(
            get: { $0.region },
            send: { AppAction.loadBathymetryTile(region: $0) }
          )
        )
        .modifier(MapViewModifier(metrics: metrics))
      }
    }
  }
  
  var mapZoomView: some View {
    GeometryReader { metrics in
      WithViewStore(store) { viewStore in
        MapZoomView(
          zoomLevel: viewStore.binding(
            get: { $0.zoomLevel },
            send: AppAction.zoomLevelUpdated
          )
        )
        .onTap {
          switch $0 {
          case .zoomIn:
            viewStore.send(.zoomIn)
          case .zoomOut:
            viewStore.send(.zoomOut)
          }
        }
        .offset(
          x: metrics.size.width - MapZoomButton.width - padding,
          y: metrics.size.height - MapZoomButton.height * 2 - space
        )
      }
    }
  }
  
  var arWaterSurfaceView: some View {
    GeometryReader { metrics in
      VStack {
        WithViewStore(store) { viewStore in
          ARWaterSurfaceView(
            waterSurface: viewStore.binding(
              get: { $0.waterSurface },
              send: AppAction.waterSurfaceUpdated
            ),
            depthUnit: viewStore.binding(
              get: { $0.depthUnit },
              send: AppAction.depthUnitUpdated
            ),
            top: viewStore.waterSurfaceTop,
            bottom: viewStore.waterSurfaceBottom
          )
        }
      }
      .offset(
        x: metrics.size.width - ARWaterSurfaceView.width - padding,
        y: metrics.size.height - MapZoomButton.height * 2 - ARWaterSurfaceView.height - space * 2
      )
    }
  }
}

// MARK: - AppView_Previews
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      AppView(store: Store(
        initialState: AppState(bathymetries: .default),
        reducer: appReducer,
        environment: AppEnvironment(
          mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
          bathymetryTileClient: BathymetryTileAPIClient()
        )
      ))
      .colorScheme($0)
    }
  }
}
