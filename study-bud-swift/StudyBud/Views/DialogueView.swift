import SwiftUI

/// A reusable, centered modal “card” with a dimmed backdrop.
/// - `isPresented`: Binding<Bool> that shows/hides the modal.
/// - `title`: Optional title at the top of the card.
/// - `message`: Main speech‑bubble message string.
/// - `characterImageName`: The name of the avatar image to show on the card’s right side of the bubble.
/// - `onClose`: An optional closure that will be invoked if the user taps the “X”.
/// - `actions`: A trailing closure containing buttons (e.g. “Yes/No” or “Resume”) that appear at the bottom.
struct DialogView<Actions: View>: View {
    @Binding var isPresented: Bool
    var title: String? = nil
    var message: String
    var characterImageName: String
    
    /// This closure is called whenever the user taps the “X” to close the dialog.
    /// If you pass `nil`, then only `isPresented = false` will happen.
    var onClose: (() -> Void)? = nil
    
    let actions: () -> Actions

    var body: some View {
        // Only render when isPresented == true
        if isPresented {
            ZStack {
                // 1) Dimmed black backdrop
                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                // 2) Centered card
                VStack(spacing: 12) {
                    // a) Top “X” close button (aligned top leading)
                    HStack {
                        Button(action: {
                            // FIRST, notify any onClose logic:
                            onClose?()
                            // THEN hide the dialog
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(6)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 4)

                    // b) Optional title (e.g. “Paused” or “Are you sure?”)
                    if let title = title {
                        Text(title)
                            .font(.mainHeader)
                            .foregroundColor(.black)
                    }

                    // c) Speech bubble containing the message + avatar, centered
                    HStack(alignment: .center, spacing: 0) {
                        // Make the bubble wider by capping its maxWidth
                        ChatBubbleView(text: message, tailPosition: 0.85)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.85)

                        Image(characterImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                    }
                    .padding(.horizontal, 4)

                    // d) Action buttons passed in by the caller, centered
                    HStack(spacing: 16) {
                        actions()
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                .background(Color.white)
                .cornerRadius(12)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
