import SwiftUI

// MARK: - ContentView
struct ContentView: View {

    // MARK: - property
    
    var body: some View {
            ZStack {
                ARView()
                GeometryReader { metrics in
                    MapView()
                        .frame(
                            width: metrics.size.width,
                            height: metrics.size.width
                        )
                        .cornerRadius(metrics.size.width / 2.0)
                        .offset(y: metrics.size.height - metrics.size.width / 2.0)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
}

// MARK: - ContentView_Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
