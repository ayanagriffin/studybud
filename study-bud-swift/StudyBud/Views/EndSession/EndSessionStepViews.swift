import SwiftUI

struct EndSessionStepViews: View {
    @ObservedObject var vm: EndSessionViewModel
    @Binding var customDurationText: String
    @Binding var showExitConfirm: Bool

    var body: some View {
        switch vm.step {
        case .initial:
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    ChoiceButton(title: "Keep going!", width: 160) {
                        vm.selectNext("Keep Going")
                    }
                    ChoiceButton(title: "Take a break", width: 160) {
                        vm.selectNext("Take a Break")
                    }
                }
                ChoiceButton(title: "End session", width: 160) {
                    showExitConfirm = true
                }
            }

        case .chooseWorkDuration, .chooseBreakDuration:
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    if vm.step == .chooseBreakDuration {
                        ChoiceButton(title: "5 Minutes", width: 130) { vm.selectDuration(5) }
                        ChoiceButton(title: "10 Minutes", width: 130) { vm.selectDuration(10) }
                    } else {
                        ChoiceButton(title: "30 Minutes", width: 130) { vm.selectDuration(30) }
                        ChoiceButton(title: "45 Minutes", width: 130) { vm.selectDuration(45) }
                    }
                }
                TextInput(
                    text: $customDurationText,
                    placeholder: "Say something else...",
                    width: 240
                ) {
                    // User pressed return — try to parse input
                    let trimmed = customDurationText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if let minutes = Int(trimmed), minutes > 0 {
                        vm.selectDuration(minutes)
                    } else {
                        // Optional: provide feedback to the user here
                        print("Invalid duration input: \(customDurationText)")
                    }
                }
            }

        case .confirmWorkStart:
            VStack(spacing: 24) {
                StartButton(title: "Let’s go!") {
                    vm.startWorkSession()
                }
                .frame(maxWidth: 250)
            }
        }
    }
}
