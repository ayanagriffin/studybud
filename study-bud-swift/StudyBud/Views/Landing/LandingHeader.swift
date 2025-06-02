import SwiftUI

struct LandingHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("Monday, June 2nd")
                        .font(.buttonText)
                }
                .padding(.top, 10)
                Spacer()
                HStack(spacing: 8) {
                    ShopButton()
                    StatsButton()
                    SettingsButton()
                }
            }
            .padding(.horizontal, 20)

            HoursProgressBar(currentHours: 10, goalHours: 15)
        }
    }
}

#Preview {
    LandingHeader()
        .previewLayout(.sizeThatFits)
}
