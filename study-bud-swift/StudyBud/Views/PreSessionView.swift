//
//  PreSessionView.swift
//  StudyBud
//
//  Updated 6/2/2025 to support “onCommit” via Return key.
//

import SwiftUI

struct PreSessionView: View {
    @StateObject private var vm = PreSessionViewModel()
    @Environment(\.dismiss) private var dismiss

    // Local state for a custom task string (so placeholder shows immediately)
    @State private var customTaskText: String = ""
    // Local state for a custom duration string
    @State private var customDurationText: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // ── 1) Full‑screen landing background ──
                Image("landing")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // ── 2) All other content in a VStack that respects safe areas ──
                VStack(spacing: 0) {

                    // ── 2A) Custom back arrow + “Session Setup” title ──
                    HStack {
                        BackArrow {
                            dismiss() // Pop or dismiss
                        }
                        Spacer().frame(width: 80)

                        Text("Session Setup")
                            .font(.mainHeader)
                            .foregroundColor(.black)

                        Spacer()
                    }
                    .padding(.leading, 8)
                    .padding(.top, safeAreaTop() + 8)

                    Spacer().frame(height: 16)

                    // ── 2B) Speech bubble under the title ──
                    ChatBubbleView(text: vm.promptText, tailPosition: 0.7)
                        .frame(maxWidth: 300)
                        .fixedSize()
                        .position(
                            x: UIScreen.main.bounds.width * 0.55,
                            y: safeAreaTop() + 100
                        )

                    Spacer().frame(height: 16)

                    // ── 2C) Main below‑the‑bubble area ──
                    Group {
                        switch vm.step {
                        case .chooseTask:
                            chooseTaskSection

                        case .chooseDuration:
                            chooseDurationSection

                        case .confirm:
                            confirmSection
                        }
                    }
                    // Push this group downward so it sits above the home indicator
                    .padding(.bottom, safeAreaBottom() + 120)
                }
            }
            // Hide SwiftUI’s default back button so only our custom BackArrow shows
            .navigationBarBackButtonHidden(true)

            // When vm.isSessionActive becomes true, push into WorkSessionView
            .navigationDestination(isPresented: $vm.isSessionActive) {
                WorkSessionView(vm: vm.workVM!)
            }
            .onAppear {
                // Make sure the nav bar background is clear so the landing image shows through
                UINavigationBar.appearance().barTintColor = .clear

                // Ensure the “Say something else…” field is blank on first appear
                customTaskText = ""
            }
        }
    }

    // MARK: – Step 1: Choose Task
    private var chooseTaskSection: some View {
        VStack(spacing: 16) {
            // A) Two side‑by‑side yellow‑outlined ChoiceButton(s)
            HStack(spacing: 16) {
                // “Homework” button on the left
                ChoiceButton(
                    title: vm.taskOptions[0],
                    width: (UIScreen.main.bounds.width - 64) * 0.44
                ) {
                    vm.taskName = vm.taskOptions[0]
                    customTaskText = ""
                    vm.selectTask(vm.taskName)
                }

                // “Chores” button on the right
                ChoiceButton(
                    title: vm.taskOptions[1],
                    width: (UIScreen.main.bounds.width - 64) * 0.44
                ) {
                    vm.taskName = vm.taskOptions[1]
                    customTaskText = ""
                    vm.selectTask(vm.taskName)
                }
            }
            .padding(.horizontal, 24)

            // B) “Say something else…” text field with pencil icon
            TextInput(
                text: $customTaskText,
                placeholder: "Say something else…",
                width: (UIScreen.main.bounds.width - 64) * 0.85,
                onCommit: {
                    // Trim whitespace; if not empty, set as vm.taskName and advance
                    let trimmed = customTaskText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    vm.taskName = trimmed
                    vm.selectTask(vm.taskName)
                }
            )
        }
    }

    // MARK: – Step 2: Choose Duration
    private var chooseDurationSection: some View {
        VStack(spacing: 16) {
            // A) Two side‑by‑side yellow‑outlined buttons for preset durations
            HStack(spacing: 16) {
                ChoiceButton(
                    title: "30 Minutes",
                    width: (UIScreen.main.bounds.width - 64) * 0.44,
                    fontWeight: .semibold
                ) {
                    vm.selectDuration(30)
                }

                ChoiceButton(
                    title: "45 Minutes",
                    width: (UIScreen.main.bounds.width - 64) * 0.44,
                    fontWeight: .semibold
                ) {
                    vm.selectDuration(45)
                }
            }
            .padding(.horizontal, 24)

            // B) “Other amount…” text field with clock icon for custom duration
            TextInput(
                text: $customDurationText,
                placeholder: "Other (min)…",
                width: (UIScreen.main.bounds.width - 64) * 0.6,
                onCommit: {
                    // Convert to Int; if valid, call selectDuration(_:)
                    let filtered = customDurationText
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    if let minutes = Int(filtered), minutes > 0 {
                        vm.selectDuration(minutes)
                    }
                }
            )
            // Force number pad so the user sees digits only:
            .keyboardType(.numberPad)
        }
    }

    // MARK: – Step 3: Confirm & Start
    private var confirmSection: some View {
        VStack(spacing: 16) {
            if vm.isLoadingRecap {
                ProgressView("Generating…")
                    .frame(width: (UIScreen.main.bounds.width - 64) * 0.44)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
            } else {
                ChoiceButton(
                    title: "Let's Go!",
                    width: (UIScreen.main.bounds.width) * 0.5,
                    fontWeight: .semibold
                ) {
                    vm.confirmAndStart()
                }
            }
        }
    }

    // MARK: – Helpers to read the safe‑area insets
    private func safeAreaTop() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }?
            .safeAreaInsets
            .top ?? 0
    }

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }?
            .safeAreaInsets
            .bottom ?? 0
    }
}

// MARK: – Preview
struct PreSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PreSessionView()
    }
}
