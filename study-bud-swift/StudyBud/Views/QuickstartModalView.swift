import SwiftUI

struct QuickstartModalView: View {
    // Callback to trigger navigation from parent
    var onSelectPreset: (Int) -> Void
    
    @Environment(\.dismiss) private var dismiss

    let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Centered Header
                HStack {
                    Spacer()
                    Text("Session Quickstart")
                        .font(.mainHeader)
                        .bold()
                    Spacer()
                }
                .padding(.top, 20)

                // Grid of Session Cards
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(sessionPresets, id: \.title) { preset in
                        SessionCard(
                            title: preset.title,
                            subtitle: preset.subtitle,
                            color: preset.color.opacity(0.2),
                            borderColor: preset.borderColor,
                            actionTitle: "Start"
                        ) {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onSelectPreset(preset.workDuration)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // Save Custom Session Button
                HStack {
                    Image(systemName: "plus")
                    Text("Save a Custom Session")
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .background(
            Color(.systemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        )
    }

    // Session presets
    let sessionPresets: [SessionPreset] = [
        SessionPreset(title: "Your Last Session", subtitle: "90 min work / 10 min break", workDuration: 90, color: .orange),
        SessionPreset(title: "Pomodoro Session", subtitle: "25 min work / 5 min break", workDuration: 25, color: .green),
        SessionPreset(title: "Focus Sprint", subtitle: "45 min work / no break", workDuration: 45, color: .blue),
        SessionPreset(title: "Deep Work", subtitle: "60 min work / 15 min break", workDuration: 60, color: .purple)
    ]
}

// Model for each preset
struct SessionPreset {
    let title: String
    let subtitle: String
    let workDuration: Int
    let color: Color
    var borderColor: Color { color }
}
