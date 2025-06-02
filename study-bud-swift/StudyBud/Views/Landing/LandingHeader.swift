import SwiftUI

struct LandingHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("MONDAY")
                        .font(.dateHeader)
                    Text("JUN 2ND")
                        .font(.normalText)
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
