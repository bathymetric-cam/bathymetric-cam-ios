import SwiftUI

struct SideMenu<MenuContent: View>: ViewModifier {
  
  // MARK: property
  
  @Binding var isOpen: Bool
  private let menuContent: () -> MenuContent
  
  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - isOpen: Bool if showing the sidemenu
  ///   - menuContent: View displayed in menu
  init(
    isOpen: Binding<Bool>,
    @ViewBuilder menuContent: @escaping () -> MenuContent
   ) {
    _isOpen = isOpen
    self.menuContent = menuContent
  }
  
  // MARK: View
  
  func body(content: Content) -> some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        content
          // .disabled(isShowing)
          .frame(width: geometry.size.width, height: geometry.size.height)
          .offset(x: isOpen ? geometry.size.width / 2 : 0)
        
        menuContent()
          .frame(width: geometry.size.width / 2)
          .transition(.move(edge: .leading))
          .offset(x: isOpen ? 0 : -geometry.size.width / 2)
      }
      .gesture(
        DragGesture().onEnded { event in
          if abs(event.translation.height) < 80 && abs(event.translation.width) > 80 {
            if isOpen || (!isOpen && event.startLocation.x < 200) {
              withAnimation { isOpen = event.translation.width > 0 }
            }
          }
        }
      )
    }
  }
}

// MARK: - View + SideMenu
extension View {
  
  /// Adds sidemenu to the view
  /// - Parameters:
  ///   - isOpen: Bool if showing the sidemenu
  ///   - menuContent: View displayed in menu
  /// - Returns: View
  func sideMenu<MenuContent: View>(
    isOpen: Binding<Bool>,
    @ViewBuilder menuContent: @escaping () -> MenuContent
  ) -> some View {
    self.modifier(SideMenu(isOpen: isOpen, menuContent: menuContent))
  }
}

// MARK: - SideMenu_Previews
struct SideMenu_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      Rectangle()
        .sideMenu(
          isOpen: Binding<Bool>(
            get: { true },
            set: { _ in }
          )
        ) {
          GeometryReader { metrics in
            VStack(alignment: .center) {
              Text("1")
              Text("2")
              Text("3")
              Text("4")
              Text("5")
            }
            .frame(
              width: metrics.size.width,
              height: metrics.size.height,
              alignment: .topLeading
            )
            .padding()
          }
        }
        .colorScheme($0)
    }
  }
}
