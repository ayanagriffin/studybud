import SwiftUI
import Combine

enum EndSessionStep {
    case initial, chooseWorkDuration, chooseBreakDuration, confirmWorkStart
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
            step = .confirmWorkStart
        case .chooseBreakDuration:
            breakDuration = minutes
            isBreakActive = true
        default:
            break
        }
    }

    func startWorkSession() {
        isWorkSessionActive = true
    }
}
