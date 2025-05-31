import SwiftUI

/// A reusable, centered modal “card” with a dimmed backdrop.
/// - `isPresented`: Binding<Bool> that shows/hides the modal.
/// - `title`: Optional title at the top of the card.
/// - `message`: Main speech‑bubble message string.
/// - `characterImageName`: The name of the avatar image to show on the card’s right side of the bubble.
/// - `actions`: A trailing closure containing buttons (e.g. “Yes/No” or “Resume”) that appear at the bottom.
struct DialogView<Actions: View>: View {
    @Binding var isPresented: Bool
    var title: String? = nil
    var message: String
    var characterImageName: String
    let actions: () -> Actions

    var body: some View {
        // Only render when isPresented == true
        if isPresented {
            ZStack {
                // 1) Dimmed black backdrop
                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                // 2) Centered card
                VStack(spacing: 16) {
                    // a) Top “X” close button (aligned top leading)
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(8)
                        }
                        Spacer()
                    }

                    // b) Optional title (e.g. “Paused” or “Are you sure?”)
                    if let title = title {
                        Text(title)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                    }

                    // c) Speech bubble containing the message + avatar
                    HStack(alignment: .top, spacing: 12) {
                        SpeechBubble(text: message)
                            .fixedSize(horizontal: false, vertical: true)

                        Image(characterImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.horizontal, 8)

                    // d) Action buttons passed in by the caller
                    HStack(spacing: 16) {
                        actions()
                    }
                    .padding(.bottom, 12)
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(20)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

