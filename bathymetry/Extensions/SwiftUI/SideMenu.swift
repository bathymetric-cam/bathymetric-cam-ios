import SwiftUI

// MARK: - SideMenu
struct SideMenu<MenuContent: View>: ViewModifier {
  
  // MARK: property
  
  @Binding var isShowing: Bool
  private let menuContent: () -> MenuContent
  
  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - isShowing: Bool if showing the sidemenu
  ///   - menuContent: View displayed in menu
  init(
     isShowing: Binding<Bool>,
     @ViewBuilder menuContent: @escaping () -> MenuContent
   ) {
    _isShowing = isShowing
    self.menuContent = menuContent
  }
  
  // MARK: View
  
  func body(content: Content) -> some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        content
          .disabled(isShowing)
          .frame(width: geometry.size.width, height: geometry.size.height)
          .offset(x: isShowing ? geometry.size.width / 2 : 0)
        
        menuContent()
          .frame(width: geometry.size.width / 2)
          .transition(.move(edge: .leading))
          .offset(x: isShowing ? 0 : -geometry.size.width / 2)
      }
      .gesture(
        DragGesture().onEnded { event in
          logger.debug("""
            \(event.startLocation.x), \(event.startLocation.y)
            \(event.predictedEndLocation.x), \(event.predictedEndLocation.y)
          """)
          if abs(event.translation.height) < 50 && abs(event.translation.width) > 50 {
            if isShowing || (!isShowing && event.startLocation.x < 120) {
              withAnimation { isShowing = event.translation.width > 0 }
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
  ///   - isShowing: Bool if showing the sidemenu
  ///   - menuContent: View displayed in menu
  /// - Returns: View
  func sideMenu<MenuContent: View>(
    isShowing: Binding<Bool>,
    @ViewBuilder menuContent: @escaping () -> MenuContent
  ) -> some View {
    self.modifier(SideMenu(isShowing: isShowing, menuContent: menuContent))
  }
}
