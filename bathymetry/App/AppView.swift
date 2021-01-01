import ComposableArchitecture
import SwiftUI

// MARK: - AppView
struct AppView: View {

    // MARK: - property
    
    @Environment(\.colorScheme) var colorScheme
    let store: Store<AppState, AppAction>
    
    var body: some View {
        ZStack {
            ARView()
            GeometryReader { metrics in
                WithViewStore(store) { viewStore in
                    MapView(geoJSON: viewStore.binding(
                        get: { $0.geoJSON },
                        send: AppAction.geoJSONUpdated
                    ))
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
                        .onAppear {
                            viewStore.send(.loadGeoJSON)
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
}

// MARK: - AppView_Previews
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: Store(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                appClient: AppClient.live
            )
        ))
    }
}
