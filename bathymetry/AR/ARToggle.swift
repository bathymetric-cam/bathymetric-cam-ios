import SwiftUI

// MARK: - ARToggle
struct ARToggle: View {
  
  // MARK: static constant
  
  // MARK: property
  
  @Binding var isOn: Bool

  var body: some View {
    HStack {
      Text("Use AR")
        .font(.system(size: 13))
      Toggle(isOn: $isOn) {
        Text("Use AR")
      }
      .labelsHidden()
      .toggleStyle(SwitchToggleStyle(tint: .blue))
    }
    .padding()
  }
}

// MARK: - ARToggle_Previews
struct ARToggle_Previews: PreviewProvider {
  
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      ARToggle(
        isOn: Binding<Bool>(
          get: { true },
          set: { _ in }
        )
      )
      .colorScheme($0)
    }
  }
}
