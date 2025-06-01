// Views/WorkSessionView.swift

import SwiftUI

struct WorkSessionView: View {
    @StateObject var vm: WorkSessionViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var isCompact = false
    @State private var showExitConfirm = false
    @State private var showPausedDialog = false

    var body: some View {
        ZStack {
            // ── 1) Full‑screen bedroom background if desired ──
//            Image("bedroom")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()

            // ── 2) All other content in a VStack that respects safe areas ──
            VStack {
                headerView    // “Yellow header” with custom progress bar
                Spacer()

                // Character at desk
                Image("blueAtDesk")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding(.horizontal)

                Spacer()

                // Exit / Pause buttons
                HStack(spacing: 40) {
                    CircleButton(iconName: "xmark", label: "Exit") {
                        showExitConfirm = true
                    }
                    CircleButton(
                        iconName: vm.isPaused ? "play.fill" : "pause.fill",
                        label: vm.isPaused ? "Resume" : "Pause"
                    ) {
                        vm.pause()
                        showPausedDialog = true
                    }
                }
                .padding(.bottom, 30)
            }

            // ── 3) Exit confirmation dialog ──
            DialogView(
                isPresented: $showExitConfirm,
                message: "Are you sure you want to exit?",
                characterImageName: "blue"
            ) {
                HStack(spacing: 24) {
                    Button("Yes") {
                        vm.exit()
                        dismiss()
                    }
                    .font(.headline)

                    Button("No") {
                        showExitConfirm = false
                    }
                    .buttonStyle(YellowOutlinedButtonStyle())
                }
            }

            // ── 4) Pause confirmation dialog ──
            DialogView(
                isPresented: $showPausedDialog,
                title: "Paused",
                message: "Ok, but don’t take too long! Come back soon!",
                characterImageName: "blue"
            ) {
                Button("Resume") {
                    vm.resume()
                    showPausedDialog = false
                }
                .buttonStyle(YellowOutlinedButtonStyle())
            }
        }
        // Hide the default back button if inside a NavigationStack
        .navigationBarBackButtonHidden(true)
    }

    // ── Header: Yellow card with task, time remaining, percent, and custom progress bar ──
    @ViewBuilder
    private var headerView: some View {
        if isCompact {
            // ── Compact mode: show only the time pill + expand arrow ──
            HStack {
                Spacer()

                Text(vm.formattedTime)
                    .font(.headline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)

                Button {
                    isCompact = false
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(.trailing, 12)
                }
            }
            .padding(.horizontal)
            .padding(.top, safeAreaTop() + 8)

        } else {
            // ── Full header: yellow background with all elements ──
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        // 1) Task name
                        Text("Task: \(vm.taskName)")
                            .font(.subheadline)
                            .foregroundColor(.black)

                        // 2) Large timer on its own line
                        Text(vm.formattedTime)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)

                        // 3) “Time Remaining” label (slightly smaller)
                        Text("Time Remaining")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.black)
                    }

                    Spacer()

                    // 4) Fullscreen/collapse toggle button
                    Button {
                        isCompact = true
                    } label: {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.trailing, 12)
                    }
                }

                // 5) Percent Complete in bold red
                HStack(spacing: 0) {
                    Text("\(vm.percentComplete)%")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.red)
                    Text(" Complete")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // 6) Custom pink‐bordered progress bar
                CustomProgressBar(progress: vm.progress)
                    .frame(height: 14)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                Color("PanelFill")
                    .cornerRadius(20)
            )
            .padding(.horizontal)
            .padding(.top, safeAreaTop() + 8)
        }
    }

    // ── Utility to grab the top safe‑area inset (notch height) ──
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

// MARK: – A small view that draws a custom pink‐bordered progress bar
struct CustomProgressBar: View {
    // Expect progress in [0, 1]
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            // Outer capsule track (white background + pink border)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.9))
                    .overlay(
                        Capsule()
                            .stroke(Color.red.opacity(0.8), lineWidth: 3)
                    )

                // Inner filled capsule (pink)
                Capsule()
                    .fill(Color.red.opacity(0.8))
                    .frame(width: max(CGFloat(progress) * geo.size.width, 0))
            }
        }
    }
}

struct WorkSessionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSessionView(
            vm: WorkSessionViewModel(taskName: "Homework", durationMinutes: 50)
        )
    }
}
