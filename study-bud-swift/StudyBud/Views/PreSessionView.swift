//
//  PreSessionView.swift
//  StudyBud
//
//  Created by You on 6/1/2025.
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
                // ── 1) Full‐screen landing background ──
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
                        .fixedSize()          // never stretch beyond its content
                        .position(x: UIScreen.main.bounds.width * 0.55, // roughly centered under “Session Setup”
                                  y: safeAreaTop() + 100)              // adjust 100 to taste

                    Spacer().frame(height: 16)

                    // ── 2C) Main below‐the‐bubble area ──
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
                // Make sure the nav bar background is clear so the bedroom image shows through
                UINavigationBar.appearance().barTintColor = .clear

                // Ensure the “Say something else…” field is blank when this screen first appears
                customTaskText = ""
            }
        }
    }

    // MARK: – Subview for Step 1: Choose Task
    private var chooseTaskSection: some View {
        VStack(spacing: 16) {
            // A) Two side‑by‑side yellow‑outlined ChoiceButton(s)
            HStack(spacing: 16) {
                // “Homework” button on the left
                ChoiceButton(
                    title: vm.taskOptions[0],
                    width: (UIScreen.main.bounds.width - 64) * 0.44
                ) {
                    // If the user taps “Homework,” write directly into vm.taskName
                    vm.taskName = vm.taskOptions[0]
                    customTaskText = ""     // clear the custom field
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
            TextInput(text: $customTaskText, placeholder: "Say something else...")
        }
    }

    // MARK: – Subview for Step 2: Choose Duration
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
            TextInput(text: $customDurationText, placeholder: "Other", width: 150)
        }
    }

    // MARK: – Subview for Step 3: Confirm & Start
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
