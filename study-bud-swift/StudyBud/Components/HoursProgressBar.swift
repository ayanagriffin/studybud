import SwiftUI

struct HoursProgressBar: View {
    var currentHours: CGFloat
    var goalHours: CGFloat

    private var progress: CGFloat {
        min(currentHours / goalHours, 1.0)
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            // Progress Bar
            ZStack(alignment: .leading) {
                // Background Bar
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 350, height: 40)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.pink, lineWidth: 3)
                    )

                // Progress Fill
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.pink)
                    .frame(width: progressWidth(), height: 30)
                    .padding(.leading, 5)

                // Text
                Text("\(Int(currentHours))/\(Int(goalHours)) Hours")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.leading, 16)
            }
            .offset(x: -5) // Adjust overlap


            // Gift Icon – overlapping right side
            ZStack {
                Circle()
                    .fill(Color(.darkGray))
                    .frame(width: 80, height: 76)
                Circle()
                    .fill(Color(.gray))
                    .frame(width: 70, height: 70)
                Image(systemName: "gift.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(.lightGray))
            }
            .offset(x: 15) // Adjust overlap
        }
        .frame(height: 80) // To make space for the gift icon
        .padding(.leading, 16) // Reduced from 16
        .padding(.trailing, 32) // No right padding
    }

    private func progressWidth() -> CGFloat {
        return 300 * progress
    }
}


#Preview {
    HoursProgressBar(currentHours: 10, goalHours: 15)
}
