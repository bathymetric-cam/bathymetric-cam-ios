import SwiftUI

// MARK: - ARToggle
struct ARToggle: View {
  
  // MARK: static constant
  
  static let width = CGFloat(80)
  
  // MARK: property
  
  @Binding var isOn: Bool

  var body: some View {
    HStack {
      Text("AR")
      Toggle(isOn: $isOn) {
        Text("AR")
      }
      .labelsHidden()
      .toggleStyle(SwitchToggleStyle(tint: .blue))
    }
    .frame(width: ARToggle.width)
  }
}

// MARK: - ARToggle_Previews
struct ARToggle_Previews: PreviewProvider {
  
  static var previews: some View {
    ARToggle(
      isOn: Binding<Bool>(
        get: { true },
        set: { _ in }
      )
    )
  }
}
