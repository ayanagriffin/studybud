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

