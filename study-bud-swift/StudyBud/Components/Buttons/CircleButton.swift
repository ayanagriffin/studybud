import SwiftUI

/// A circular button with an SF icon (always black) and a bold label below it.
/// - White, fully opaque background
/// - 3 pt black stroke around the circle
/// - Icon is always black (no yellow)
/// - Use the outlined SF Symbol name ("pause", "play") if you want an outline
struct CircleButton: View {
    let iconName: String   // e.g. "xmark", "pause", "play"
    let label: String      // e.g. "Exit", "Pause", "Play"
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(.black)  // always black

                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .frame(width: 80, height: 80)
            .background(
                Color.white
                    .clipShape(Circle())
            )
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 3)
            )
        }
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            // A black "X" icon
            CircleButton(iconName: "xmark", label: "Exit") {
                // exit action
            }

            // A black outlined pause icon ("||")
            CircleButton(iconName: "pause", label: "Pause") {
                // pause action
            }

            // A black outlined play icon ("▶︎")
            CircleButton(iconName: "play", label: "Play") {
                // play action
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .previewLayout(.sizeThatFits)
    }
}
