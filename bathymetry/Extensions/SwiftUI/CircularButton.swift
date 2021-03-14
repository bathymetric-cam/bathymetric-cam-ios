import SwiftUI

// MARK: - CircularButton
struct CircularButton<Content: View>: View {

  // MARK: property
  
  let background: Color
  let foreground: Color
  let action: () -> Void
  let content: () -> Content
  
  var body: some View {
    Button(
      action: action
    ) {
      HStack {
        content()
      }
      .padding(16)
      .foregroundColor(foreground)
      .background(background)
      .cornerRadius(48)
      .shadow(radius: 2.0)
    }
  }
}

// MARK: - CircularButtonZoomIn_Previews
struct CircularButtonZoomIn_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      CircularButton(
        background: Color(.systemBackground),
        foreground: Color(.label),
        action: { },
        content: {
          Image(systemName: "plus")
            .font(.title)
            .padding(.horizontal, 1)
            .padding(.top, 3)
            .padding(.bottom, 2)
        }
      )
      .colorScheme($0)
    }
  }
}
