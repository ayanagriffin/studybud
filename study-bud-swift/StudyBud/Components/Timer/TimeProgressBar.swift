import SwiftUI

struct TimeProgressBar: View {
    var currentTime: CGFloat
    var totalTime: CGFloat
    var label: String = "Time"

    private var progress: CGFloat {
        min(currentTime / totalTime, 1.0)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 350, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.pink, lineWidth: 3)
                )

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.pink)
                .frame(width: progressWidth(), height: 30)
                .padding(.leading, 5)
        }
        .frame(height: 40)
        .padding(.horizontal, 16)
    }

    private func progressWidth() -> CGFloat {
        return 340 * progress
    }
}
