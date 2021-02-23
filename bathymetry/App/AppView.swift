import ComposableArchitecture
import SwiftUI

// MARK: - AppView
struct AppView: View {

  // MARK: property
  
  let store: Store<AppState, AppAction>
  
  // swiftlint:disable closure_body_length
  var body: some View {
    ZStack {
      GeometryReader { metrics in
        WithViewStore(store) { viewStore in
          ARView(
            isOn: viewStore.binding(
              get: { $0.arIsOn },
              send: AppAction.arIsOnChanged
            ),
            bathymetryTiles: viewStore.binding(
              get: { $0.bathymetryTiles },
              send: AppAction.bathymetryTilesUpdated
            ),
            bathymetryColors: viewStore.binding(
              get: { $0.bathymetryColors },
              send: AppAction.bathymetryColorsUpdated
            )
          )
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
      .edgesIgnoringSafeArea(.all)
  
      GeometryReader { metrics in
        WithViewStore(store) { viewStore in
          BathymetryColorsView(
            bathymetryColors: viewStore.binding(
              get: { $0.bathymetryColors },
              send: AppAction.bathymetryColorsUpdated
            )
          )
          .offset(x: 16)
  
          ARToggle(
            isOn: viewStore.binding(
              get: { $0.arIsOn },
              send: AppAction.arIsOnChanged
            )
          )
          .offset(x: metrics.size.width - ARToggle.width - 16)
        }
  
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
          .offset(x: 16, y: metrics.size.height - metrics.size.width / 2.0)
      }
    }
  }
  // swiftlint:enable closure_body_length

  // MARK: MapViewModifier
  
  struct MapViewModifier: ViewModifier {
    // MARK: property
  
    let metrics: GeometryProxy
  
    // MARK: public api
  
    func body(content: Content) -> some View {
      content
        .frame(
          width: metrics.size.width,
          height: metrics.size.width
        )
        .cornerRadius(metrics.size.width / 2.0)
        .offset(y: metrics.size.height - metrics.size.width / 2.0)
        .overlay(
          RoundedRectangle(cornerRadius: metrics.size.width / 2.0)
            .stroke(Color.gray, lineWidth: 4)
            .offset(y: metrics.size.height - metrics.size.width / 2.0)
        )
    }
  }
  
}

// MARK: - AppView_Previews
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store(
      initialState: AppState(bathymetryColors: .defaultColors),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        bathymetryClient: .contentful
      )
    ))
  }
}
