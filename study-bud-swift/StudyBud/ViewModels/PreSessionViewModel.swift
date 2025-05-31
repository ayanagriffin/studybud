// ViewModels/PreSessionViewModel.swift

import Combine
import SwiftUI

enum PreSessionStep {
    case chooseTask, chooseDuration, confirm
}

class PreSessionViewModel: ObservableObject {
    // MARK: — Published state

    @Published var step: PreSessionStep = .chooseTask {
        didSet {
            switch step {
            case .chooseTask:
                // As soon as we enter “chooseTask” step, pick one random task prompt
                taskPrompt = DialogueManager.randomTaskPrompt()

            case .chooseDuration:
                // As soon as we enter “chooseDuration” step, pick one random duration prompt
                durationPrompt = DialogueManager.randomDurationPrompt()

            case .confirm:
                // Nothing to do here—recapText drives UI in .confirm
                break
            }
        }
    }

    /// When the user is entering a task, show exactly this string (set only once per step)
    @Published private(set) var taskPrompt: String

    /// When the user is entering a duration, show exactly this string (set only once per step)
    @Published private(set) var durationPrompt: String = ""

    @Published var taskName: String = ""
    @Published var duration: Int?
    @Published var recapText: String?
    @Published var isLoadingRecap = false

    /// Controls navigation into WorkSessionView
    @Published var isSessionActive = false

    /// Holds the work session VM once the user confirms
    var workVM: WorkSessionViewModel?

    private let store = SessionStore()
    private var cancellables = Set<AnyCancellable>()

    // MARK: — Initializer

    init() {
        // 1) Preload last session if any
        if let last = store.loadLast() {
            taskName = last.taskName
            duration = last.durationMinutes
        }

        // 2) Since step starts at .chooseTask, initialize taskPrompt exactly once:
        self.taskPrompt = DialogueManager.randomTaskPrompt()
    }

    // MARK: — Computed property for “What to show in the speech bubble”

    var promptText: String {
        switch step {
        case .chooseTask:
            return taskPrompt

        case .chooseDuration:
            return durationPrompt

        case .confirm:
            // If recapText is nil, fall back to a generic string
            return recapText ?? "Ready to rock?"
        }
    }

    // MARK: — Helper to generate “recent tasks + presets” without duplicates

    var taskOptions: [String] {
        // 1) Grab & de‐dupe recents
        let recents = store
            .recentTasks
            .filter { !$0.isEmpty }
            .reduce(into: [String]()) { acc, task in
                if !acc.contains(task) {
                    acc.append(task)
                }
            }

        switch recents.count {
        case let n where n >= 2:
            return Array(recents.prefix(2))

        case 1:
            let first = recents[0]
            let fallback = (first == "Homework" ? "Chores" : "Homework")
            return [first, fallback]

        default:
            return ["Homework", "Chores"]
        }
    }

    // MARK: — User actions

    func selectTask(_ name: String) {
        taskName = name
        step = .chooseDuration
        // Setting step triggers didSet → sets durationPrompt once
    }

    func selectDuration(_ minutes: Int) {
        duration = minutes
        step = .confirm
        generateRecap()
    }

    private func generateRecap() {
//        guard let dur = duration else { return }
//        isLoadingRecap = true
//
//        // Example stubbed AI call—swap with your real AI client
//        AIClient.shared
//            .generateRecap(task: taskName, duration: dur)
//            .receive(on: DispatchQueue.main)
//            .sink { _ in }
//            receiveValue: { [weak self] text in
//                guard let self = self else { return }
//                self.recapText = text
//                self.isLoadingRecap = false
//            }
//            .store(in: &cancellables)
    }

    func confirmAndStart() {
        guard let dur = duration else { return }

        // 1) Persist the session
        let settings = SessionSettings(taskName: taskName, durationMinutes: dur)
        store.save(settings: settings)

        // 2) Kick off the WorkSessionViewModel
        let sessionVM = WorkSessionViewModel(taskName: taskName, durationMinutes: dur)
        self.workVM = sessionVM

        // 3) Trigger navigation in SwiftUI
        isSessionActive = true
    }
}
