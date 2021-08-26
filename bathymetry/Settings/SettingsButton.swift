import SwiftUI

// MARK: - SettingsButton
struct SettingsButton: View {
  
  // MARK: static constant
  
  let fontSize = CGFloat(40)
  
  // MARK: property
  
  @Environment(\.colorScheme) var colorScheme
  let action: () -> Void

  var body: some View {
    GeometryReader { _ in
      Image(systemName: "circle.fill")
        .font(.system(size: fontSize))
        .foregroundColor(colorScheme == .dark ? .black : .white)
      Button(action: action) {
        Image(systemName: "gearshape.fill")
          .font(.system(size: fontSize / 2))
          .foregroundColor(colorScheme == .dark ? .white : .black)
          .offset(x: 11, y: 11)
      }
    }
    .padding()
    .shadow(radius: 1.0)
  }
}

// MARK: - SettingsButton_Previews
struct SettingsButton_Previews: PreviewProvider {
  
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      SettingsButton { }
        .colorScheme($0)
    }
  }
}
