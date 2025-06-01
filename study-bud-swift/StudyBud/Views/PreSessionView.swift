// Views/PreSessionView.swift

import SwiftUI

struct PreSessionView: View {
    @StateObject private var vm = PreSessionViewModel()
    @Environment(\.dismiss) private var dismiss

    // Local state for a custom duration string
    @State private var customDurationText: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // ── 1) Full‑screen bedroom background ──
                Image("landing")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // ── 2) All other content in a VStack that respects safe areas ──
                VStack(spacing: 0) {

                    // ── 2A) Custom back arrow + title ──
                    HStack {
                        BackArrow {
                            dismiss() // Pop or dismiss
                        }
                        Spacer()
                    }
                    // Push down just below the notch
                    .padding(.leading, 16)
                    .padding(.top, safeAreaTop() + 8)

                    Text("Session Setup")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.top, 4)

                    // ── 2B) Speech bubble under the title ──
                    SpeechBubble(text: vm.promptText)
                        .padding(.horizontal, 32)
                        .padding(.top, 8)

                    Spacer()

        
                    // ── 2D) Bottom controls for whichever step we’re in ──
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
                    // Ensure bottom controls are above the home indicator
                    .padding(.bottom, safeAreaBottom() + 16)
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
            }
        }
    }

    // MARK: – Subview for Step 1: Choose Task
    private var chooseTaskSection: some View {
        VStack(spacing: 16) {
            // A) Two side‑by‑side yellow‑outlined buttons
            HStack(spacing: 16) {
                // “Homework” button on the left
                Button(action: {
                    vm.selectTask(vm.taskOptions[1]) // index 1 == “Homework”
                }) {
                    Text(vm.taskOptions[1])
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: (UIScreen.main.bounds.width - 64) * 0.44)
                        .padding(.vertical, 12)
                }
                .buttonStyle(YellowOutlinedButtonStyle())

                // “Chores” button on the right
                Button(action: {
                    vm.selectTask(vm.taskOptions[0]) // index 0 == “Chores”
                }) {
                    Text(vm.taskOptions[0])
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: (UIScreen.main.bounds.width - 64) * 0.44)
                        .padding(.vertical, 12)
                }
                .buttonStyle(YellowOutlinedButtonStyle())
            }
            .padding(.horizontal, 24)

            // B) “Say something else…” text field with pencil icon
            HStack(spacing: 12) {
                Image(systemName: "pencil")
                    .foregroundColor(.gray)

                TextField("Say something else…", text: $vm.taskName)
                    .autocapitalization(.sentences)
                    .disableAutocorrection(false)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.8))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("InputButtonOutline"), lineWidth: 6)
            )
            .cornerRadius(20)
            // Same width as each button above
            .frame(width: (UIScreen.main.bounds.width - 64) * 0.44)
        }
    }

    // MARK: – Subview for Step 2: Choose Duration
    private var chooseDurationSection: some View {
        VStack(spacing: 16) {
            // A) Two side‑by‑side yellow‑outlined buttons for preset durations
            HStack(spacing: 16) {
                Button(action: { vm.selectDuration(30) }) {
                    Text("30 Minutes")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: (UIScreen.main.bounds.width - 64) * 0.44)
                        .padding(.vertical, 12)
                }
                .buttonStyle(YellowOutlinedButtonStyle())

                Button(action: { vm.selectDuration(45) }) {
                    Text("45 Minutes")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: (UIScreen.main.bounds.width - 64) * 0.44)
                        .padding(.vertical, 12)
                }
                .buttonStyle(YellowOutlinedButtonStyle())
            }
            .padding(.horizontal, 24)

            // B) “Other amount…” text field with clock icon for custom duration
            HStack(spacing: 12) {
                Image(systemName: "clock")
                    .foregroundColor(.gray)

                TextField("Other (min)…", text: $customDurationText)
                    .keyboardType(.numberPad)
                    .foregroundColor(.black)
                    .onChange(of: customDurationText) { newValue in
                        // Strip non‑digits
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            customDurationText = filtered
                        }
                    }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.8))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("InputButtonOutline"), lineWidth: 6)
            )
            .cornerRadius(20)
            .frame(width: (UIScreen.main.bounds.width - 64) * 0.44)

        }
    }

    // MARK: – Subview for Step 3: Confirm & Start
    private var confirmSection: some View {
        VStack(spacing: 16) {
            if vm.isLoadingRecap {
                ProgressView("Generating…")
                    .frame(width: (UIScreen.main.bounds.width - 64) * 0.44)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
            } else {
                Button(action: {
                    vm.confirmAndStart()
                }) {
                    Text("Start \(vm.duration!)-Minute Session")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: (UIScreen.main.bounds.width - 64) * 0.75)
                        .padding(.vertical, 12)
                }
                .buttonStyle(YellowOutlinedButtonStyle())
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
