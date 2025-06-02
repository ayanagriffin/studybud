import SwiftUI

struct LandingHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                VStack(alignment: .trailing, spacing: 1) {
                    Text("TUESDAY")
                        .font(.dateHeader)
                    Text("MAY 21ST")
                        .font(.buttonText)
                }

                HStack(spacing: 8) {
                    ShopButton(title: "Shop") { print("Shop tapped") }
                    StatsButton(title: "Stats") { print("Stats tapped") }
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
