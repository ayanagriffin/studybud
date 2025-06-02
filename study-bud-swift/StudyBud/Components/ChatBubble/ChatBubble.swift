import SwiftUI

struct ChatBubbleView: View {
    var text: String
    var tailPosition: CGFloat = 0.5 // Default is center

    var body: some View {
        Text(text)
            .font(.speechText)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 48, trailing: 16))
            .background(
                UpdatedSpeechBubble(tailPosition: tailPosition)
                    .fill(Color(white: 0.98))
            )
            .overlay(
                UpdatedSpeechBubble(tailPosition: tailPosition)
                    .stroke(Color.black, lineWidth: 4)
            )
            .fixedSize(horizontal: false, vertical: true)
            .padding()
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
