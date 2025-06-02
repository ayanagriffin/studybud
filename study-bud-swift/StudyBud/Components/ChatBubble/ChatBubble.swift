import SwiftUI
import Combine

struct ChatBubbleView: View {
    /// 1) The full string we want to display in the bubble.
    let text: String
    
    /// 2) Where we stand in our typing animation.
    @State private var displayedText: String = ""
    
    /// 3) The interval between each character. Tweak as desired.
    private let typingInterval: TimeInterval = 0.04
    
    /// 4) If the caller changes `text`, we want to restart typing from scratch.
    @State private var typingCancellable: Cancellable?
    
    /// 5) How far along the bubble’s tail is (0 = left, 1 = right).
    var tailPosition: CGFloat = 0.5
    
    var body: some View {
        Text(displayedText)
            .font(.speechText)               // Your custom font
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 48, trailing: 16))
            .background(
                UpdatedSpeechBubble(tailPosition: tailPosition)
                    .fill(Color(white: 0.98))
            )
            .overlay(
                UpdatedSpeechBubble(tailPosition: tailPosition)
                    .stroke(Color.darkGray, lineWidth: 4)
            )
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            // Whenever the text changes, restart the typing animation
            .onChange(of: text) { newValue in
                restartTyping(with: newValue)
            }
            // Also start typing the very first time it appears
            .onAppear {
                restartTyping(with: text)
            }
            // Cancel the timer if the view disappears
            .onDisappear {
                typingCancellable?.cancel()
            }
    }
    
    private func restartTyping(with text: String) {
        // 1) Cancel any previous timer
        typingCancellable?.cancel()
        // 2) Clear out displayedText
        displayedText = ""
        
        // 3) If text is empty, do nothing
        guard !text.isEmpty else { return }
        
        // 4) Set up a Combine timer that fires every `typingInterval` seconds
        let publisher = Timer.publish(every: typingInterval, on: .main, in: .common).autoconnect()
        
        // 5) Keep an index into our string
        var currentIndex = text.startIndex
        
        typingCancellable = publisher.sink { _ in
            if currentIndex < text.endIndex {
                // Append the next character
                displayedText.append(text[currentIndex])
                currentIndex = text.index(after: currentIndex)
            } else {
                // Once we’ve finished, cancel the timer
                typingCancellable?.cancel()
            }
        }
    }
}

#Preview("Tail in Center") {
    ChatBubbleView(text: "Hey John! I’ve been itching to do some work.", tailPosition: 0.5)
}

#Preview("Tail on Left") {
    ChatBubbleView(text: "This one’s aligned left.", tailPosition: 0.2)
}

#Preview("Tail on Right") {
    ChatBubbleView(text: "Right-side bubble here.", tailPosition: 0.85)
}
