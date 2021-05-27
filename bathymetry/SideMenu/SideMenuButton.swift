import SwiftUI

// MARK: - SideMenuButton
struct SideMenuButton: View {
  
  // MARK: static constant
  
  let fontSize = CGFloat(40)
  
  // MARK: property
  
  @Environment(\.colorScheme) var colorScheme
  let action: () -> Void

  var body: some View {
    GeometryReader { _ in
      Image(systemName: "circle.fill")
        .font(.system(size: fontSize))
        .foregroundColor(colorScheme == .dark ? .white : .black)
      Button(action: action) {
        Image(systemName: "line.horizontal.3.circle.fill")
          .font(.system(size: fontSize))
          .foregroundColor(colorScheme == .dark ? .black : .white)
      }
    }
    .padding()
    .shadow(radius: 1.0)
  }
}

// MARK: - SideMenuButton_Previews
struct SideMenuButton_Previews: PreviewProvider {
  
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      SideMenuButton { }
        .colorScheme($0)
    }
  }
}
