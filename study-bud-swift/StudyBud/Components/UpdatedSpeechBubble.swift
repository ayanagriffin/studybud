import SwiftUI
struct UpdatedSpeechBubble: Shape {
    var tailPosition: CGFloat = 0.5  // 0 = left, 0.5 = center, 1 = right

    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 16
        let tailWidth: CGFloat = 20
        let tailHeight: CGFloat = 25

        var path = Path()

        // Top and right side
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius - tailHeight))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius - tailHeight),
                    radius: cornerRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)

        // Tail position (normalized)
        let tailMidX = rect.minX + rect.width * tailPosition

        // Tail
        path.addLine(to: CGPoint(x: tailMidX + tailWidth / 2, y: rect.height - tailHeight))
        path.addLine(to: CGPoint(x: tailMidX, y: rect.height))
        path.addLine(to: CGPoint(x: tailMidX - tailWidth / 2, y: rect.height - tailHeight))

        // Bottom-left corner
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height - tailHeight))
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius - tailHeight),
                    radius: cornerRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)

        // Left side
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)

        return path
    }
}


struct ChatBubbleView: View {
    var text: String
    var tailPosition: CGFloat = 0.5 // Default is center

    var body: some View {
        Text(text)
            .font(.speechText).fontWeight(.bold)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 48, trailing: 16))
            .background(
                UpdatedSpeechBubble(tailPosition: tailPosition)
                    .fill(Color(white: 0.98))
            )
            .overlay(
                UpdatedSpeechBubble(tailPosition: tailPosition)
                    .stroke(Color.darkGray, lineWidth: 3)
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
