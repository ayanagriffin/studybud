import SwiftUI

struct HoursProgressBar: View {
    var currentHours: CGFloat
    var goalHours: CGFloat
    
    private var progress: CGFloat {
        min(currentHours / goalHours, 1.0)
    }

    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .leading) {
                // Background Bar
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.pink, lineWidth: 2)
                    )

                // Progress Fill
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.pink)
                    .frame(width: progressWidth(), height: 40)

                // Text
                Text("\(Int(currentHours))/\(Int(goalHours)) Hours")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.leading, 16)
            }

            // Gift Icon
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.7))
                    .frame(width: 50, height: 50)

                Image(systemName: "gift.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            .padding(.leading, 8)
        }
        .padding(.horizontal, 16)
        .background(Color.gray) // Page background color
    }

    private func progressWidth() -> CGFloat {
        // Assuming full bar width is 300 for consistent rendering
        return 300 * progress
    }
}

struct ContentView: View {
    var body: some View {
        HoursProgressBar(currentHours: 10, goalHours: 15)
    }
}
