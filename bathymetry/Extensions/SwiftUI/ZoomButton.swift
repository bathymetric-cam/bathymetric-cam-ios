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
                Group {
                    if type == .zoomIn {
                        zoomIn
                    } else {
                        zoomOut
                    }
                }
            }
        )
            .frame(width: 64, height: 64)
    }
    
    var zoomIn: some View {
        Image(
            systemName: "plus"
        )
            .font(.title)
            .padding(.horizontal, 1)
            .padding(.top, 3)
            .padding(.bottom, 2)
    }
    
    var zoomOut: some View {
        Image(
            systemName: "minus"
        )
            .font(.title)
            .padding(.vertical, 12)
            .padding(.horizontal, 1)
            .padding(.top, 1)
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
