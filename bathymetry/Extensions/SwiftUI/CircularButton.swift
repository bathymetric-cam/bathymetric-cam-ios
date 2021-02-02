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
            .padding(20)
            .foregroundColor(foreground)
            .background(background)
            .cornerRadius(40)
            .shadow(radius: 2.0)
        }
    }
}

// MARK: - CircularButton_Previews
struct CircularButton_Previews: PreviewProvider {
    static var previews: some View {
        CircularButton(
            background: Color(.systemBackground),
            foreground: Color(.label),
            action: { },
            content: {
                Image(systemName: "plus")
                    .font(.title)
            }
        )
    }
}
