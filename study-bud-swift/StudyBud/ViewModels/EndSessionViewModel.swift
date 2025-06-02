import SwiftUI
import Combine

enum EndSessionStep {
    case initial, chooseWorkDuration, chooseBreakDuration, confirmWorkStart // ✅ Added confirm step
}


class EndSessionViewModel: ObservableObject {
    @Published var step: EndSessionStep = .initial
    @Published var isWorkSessionActive = false
    @Published var isBreakActive = false
    @Published var duration: Int?
    @Published var isSessionComplete = false

    var workSessionVM: WorkSessionViewModel?
    var breakDuration: Int?

    func selectNext(_ choice: String) {
        switch choice {
        case "Keep Going":
            step = .chooseWorkDuration
        case "Take a Break":
            step = .chooseBreakDuration
        case "End Session":
            // Will dismiss from the View
            break
        default:
            break
        }
    }

    func selectDuration(_ minutes: Int) {
        duration = minutes
        switch step {
        case .chooseWorkDuration:
            workSessionVM = WorkSessionViewModel(taskName: "New Task", durationMinutes: minutes)
            step = .confirmWorkStart // ✅ Show "Let's go!" screen
        case .chooseBreakDuration:
            breakDuration = minutes
            isBreakActive = true
        default:
            break
        }
    }

    // ✅ Call this when user taps "Let's go!"
    func startWorkSession() {
        isWorkSessionActive = true
    }
}
