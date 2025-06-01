import SwiftUI

struct SpeechBubble: View {
    let text: String

    var body: some View {
        VStack(spacing: 0) {
            // Rounded rectangle for bubble body
            Text(text)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )

            // Downward "tail"
            Triangle()
                .fill(Color.white)
                .frame(width: 20, height: 12)
                .overlay(
                    Triangle().stroke(Color.black, lineWidth: 2)
                )
                .rotationEffect(.degrees(180))
                .offset(y: -1)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Top middle → bottom right → bottom left → close
        path.move(to:    CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

