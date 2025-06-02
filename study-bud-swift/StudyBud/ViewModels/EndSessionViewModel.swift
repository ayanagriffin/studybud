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
    
    enum SessionStep {
        case initial, chooseWorkDuration, chooseBreakDuration, confirmWorkStart
    }

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
    
    var bubbleText: String {
        switch step {
        case .initial:
            return "Wow! Great work, whaddya wanna do next?"
        case .chooseWorkDuration:
            return "Okay! How long do you wanna keep working?"
        case .chooseBreakDuration:
            return "Cool! How long do you wanna rest?"
        case .confirmWorkStart:
            return "Got it! Ready when you are."
        }
    }

}
