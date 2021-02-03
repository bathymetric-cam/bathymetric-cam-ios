import SwiftUI

// MARK: - ZoomButton
struct ZoomButton: View {

    // MARK: enum
    
    enum ZoomType {
        case zoomIn
        case zoomOut
    }
    
    // MARK: property
    
    let type: ZoomType
    let action: () -> Void
    
    var body: some View {
        CircularButton(
            background: Color(.systemBackground),
            foreground: Color(.label),
            action: { },
            content: {
                Image(systemName: type == .zoomIn ? "plus" : "minus")
                    .font(.title)
                    .padding(
                        type == .zoomIn ? .top : .vertical,
                        type == .zoomIn ? 2 : 12
                    )
            }
        )
    }
}

// MARK: - ZoomButtonZoomIn_Previews
struct ZoomButtonZoomIn_Previews: PreviewProvider {
    static var previews: some View {
        ZoomButton(type: .zoomIn) { }
    }
}

// MARK: - ZoomButtonZoomOut_Previews
struct ZoomButtonZoomOut_Previews: PreviewProvider {
    static var previews: some View {
        ZoomButton(type: .zoomOut) { }
    }
}
