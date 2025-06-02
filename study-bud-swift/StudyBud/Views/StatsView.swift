import SwiftUI

// 1) A simple enum to track which tab is selected
enum SettingsTab: String, CaseIterable {
    case today = "Today"
    case allTime = "All Time"
}

struct StatsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: SettingsTab = .today

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                BackArrow {
                    dismiss()
                }

                Spacer()

                Text("Statistics")
                    .font(.mainHeader)
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
                            .font(.normalText)
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
                    HStack {
                        Image("blueHappy")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .padding(.top, 8)
                        
                        // ── 4) Total Time Worked ──
                        VStack(spacing: 4) {
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                // “1 hr 50 min” broken into pieces to get baseline alignment
                                Text("1")
                                    .font(.mainHeader)
                                Text("hr")
                                    .font(.smallDescription)
                                    .foregroundColor(.black)
                                Text("50")
                                    .font(.mainHeader)
                                Text("min")
                                    .font(.smallDescription)
                                    .foregroundColor(.black)
                            }
                            
                            Text("Total Time Worked")
                                .font(.normalText)
                                .foregroundColor(.gray)
                        }
                        
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
                            .background(Color("QuickstartOption2Outline"))
                            .clipShape(Capsule())
                            .offset(y: 12)
                            .zIndex(2)

                        // Horizontal row of trophy icons
                        HStack(spacing: 24) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "trophy.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color("QuickstartOption2Button"))
                            }
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color("QuickstartOption2Fill"))
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
        .background(Color("QuickstartOption1Fill"))
        .cornerRadius(12)
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}

