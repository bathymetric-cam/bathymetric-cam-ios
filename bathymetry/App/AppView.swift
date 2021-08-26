import ComposableArchitecture
import SwiftUI

// MARK: - AppView
struct AppView: View {

  // MARK: property
  
  let store: Store<AppState, AppAction>
  
  @State private var sideMenuIsOpen = false
  let padding = CGFloat(16)
  let space = CGFloat(16)
  
  var body: some View {
    ZStack {
      ZStack {
        arView
        mapView
      }
      .edgesIgnoringSafeArea(.all)
      
      SettingsButton {
        sideMenuIsOpen.toggle()
      }
      mapZoomButtons
      waterSurfaceSlider
    }
    .sideMenu(isOpen: $sideMenuIsOpen) {
      sideMenuContent
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
          )
        )
        /*
        .regionDidChange {
          viewStore.send(.loadBathymetries($0))
        }
        */
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
        x: metrics.size.width - MapZoomButton.width - padding,
        y: metrics.size.height - MapZoomButton.height * 2 - space
      )
    }
  }
  
  var waterSurfaceSlider: some View {
    GeometryReader { metrics in
      VStack {
        WithViewStore(store) { viewStore in
          BathymetrySlider(
            waterSurface: viewStore.binding(
              get: { $0.waterSurface },
              send: AppAction.waterSurfaceUpdated
            ),
            depthUnit: viewStore.binding(
              get: { $0.depthUnit },
              send: AppAction.depthUnitUpdated
            )
          )
        }
      }
      .offset(
        x: metrics.size.width - BathymetrySlider.width - padding,
        y: metrics.size.height - MapZoomButton.height * 2 - BathymetrySlider.height - space * 2
      )
    }
  }
  
  var sideMenuContent: some View {
    GeometryReader { metrics in
      VStack {
        WithViewStore(store) { viewStore in
          ARToggle(
            isOn: viewStore.binding(
              get: { $0.arIsOn },
              send: AppAction.arIsOnToggled
            )
          )
          BathymetryDepthUnitView(
            depthUnit: viewStore.binding(
              get: { $0.depthUnit },
              send: AppAction.depthUnitUpdated
            )
          )
        }
      }
      .frame(
        width: metrics.size.width,
        height: metrics.size.height,
        alignment: .topLeading
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
          mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
      ))
      .colorScheme($0)
    }
  }
}
