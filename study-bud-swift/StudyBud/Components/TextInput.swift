// Views/TextInput.swift

import SwiftUI

/// A reusable text‐input style that shows an icon + rounded rectangle + text field.
/// You can optionally supply `onCommit` to be notified when the user taps Return.
struct TextInput: View {
    @Binding var text: String
    var placeholder: String
    var width: CGFloat?

    /// Called when user taps “Return” (Enter) on the keyboard.
    var onCommit: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "pencil")
                .foregroundColor(.gray)
                .font(.system(size: 20))

            TextField(placeholder, text: $text)
                .font(.buttonText)
                .foregroundColor(.black)
                // Make sure this TextField sends a “.submit” action
                .submitLabel(.done)
                .onSubmit {
                    // When Return is pressed, invoke the closure (if provided)
                    onCommit?()
                }
        }
        .padding(.horizontal, 12)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("ButtonFill"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color("ButtonOutline"), lineWidth: 4)
        )
        .frame(width: width ?? 280)
    }
}

#Preview {
    @State var customDurationText = ""
    return TextInput(
        text: $customDurationText,
        placeholder: "Say something else…",
        width: 280,
        onCommit: {
            print("User pressed Return with value: \(customDurationText)")
        }
    )
}
