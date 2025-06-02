import SwiftUI

// 1) A simple enum to track which tab is selected
enum SettingsTab: String, CaseIterable {
    case today = "Today"
    case allTime = "All Time"
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: SettingsTab = .today

    var body: some View {
        VStack(spacing: 16) {
            // ── Header with back arrow + “Settings” title ──
            HStack {
                BackArrow {
                    dismiss()  // pop/dismiss the view
                }

                Spacer()

                Text("Settings")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                // dummy spacer so title stays centered
                Spacer()
                    .frame(width: 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, safeAreaTop() + 8)

            // ── Tab bar (“Today” / “All Time”) ──
            HStack(spacing: 32) {
                ForEach(SettingsTab.allCases, id: \.self) { tab in
                    VStack(spacing: 4) {
                        Text(tab.rawValue)
                            .font(.system(size: 16, weight: selectedTab == tab ? .bold : .regular))
                            .foregroundColor(selectedTab == tab ? .black : .gray)
                            .onTapGesture {
                                withAnimation {
                                    selectedTab = tab
                                }
                            }

                        // underline indicator if this tab is selected
                        Rectangle()
                            .fill(selectedTab == tab ? Color.black : Color.clear)
                            .frame(height: 2)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            ScrollView {
                VStack(spacing: 24) {
                    // ── 3) Character Illustration ──
                    Image("blue")                     // replace with your “blue” asset name
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .padding(.top, 8)

                    // ── 4) Total Time Worked ──
                    VStack(spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            // “1 hr 50 min” broken into pieces to get baseline alignment
                            Text("1")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.black)
                            Text("hr")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                            Text("50")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.black)
                            Text("min")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                        }

                        Text("Total Time Worked")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }

                    // ── 5) Four Stat Boxes ──
                    HStack(spacing: 16) {
                        StatBox(primaryText: "2h 30m", secondaryText: "Focus")
                        StatBox(primaryText: "2h 30m", secondaryText: "Break")
                        StatBox(primaryText: "5", secondaryText: "Sessions")
                        StatBox(primaryText: "75%", secondaryText: "Focus %")
                    }
                    .padding(.horizontal, 16)

                    // ── 6) Awards Section ──
                    VStack(spacing: 0) {
                        // “Awards” pill‐shaped label
                        Text("Awards")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            .background(Color(red: 0.8, green: 0.95, blue: 0.8))
                            .clipShape(Capsule())
                            .offset(y: 12)

                        // Horizontal row of trophy icons
                        HStack(spacing: 24) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "trophy.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.green)
                            }
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.9, green: 1.0, blue: 0.9))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
    }

    // Pull the top safe‐area inset (e.g. notch height)
    private func safeAreaTop() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }?
            .safeAreaInsets
            .top ?? 0
    }
}


// A reusable “StatBox” view for each of the four stats at the top.
struct StatBox: View {
    var primaryText: String
    var secondaryText: String

    var body: some View {
        VStack(spacing: 8) {
            Text(primaryText)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            Text(secondaryText)
                .font(.system(size: 12))
                .foregroundColor(.black)
        }
        .frame(width: (UIScreen.main.bounds.width - 64) / 4)
        .padding(.vertical, 12)
        .background(Color(red: 1.0, green: 0.94, blue: 0.88)) // light peach
        .cornerRadius(12)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

