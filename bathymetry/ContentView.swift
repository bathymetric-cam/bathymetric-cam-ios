import SwiftUI

// MARK: - ContentView
struct ContentView: View {

    // MARK: - property
    
    var body: some View {
        GeometryReader { metrics in
            ZStack(alignment: .bottom) {
                ARView()
                    .edgesIgnoringSafeArea(.all)
                MapView()
                    .frame(
                        width: metrics.size.width,
                        height: metrics.size.width
                    )
                    .cornerRadius(metrics.size.width / 2.0)
                    .offset(y: metrics.size.width / 2.0)
            }
            .frame(height: metrics.size.height)
        }
    }
}

// MARK: - ContentView_Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
