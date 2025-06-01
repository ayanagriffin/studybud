// Views/WorkSessionView.swift

import SwiftUI

struct WorkSessionView: View {
    @StateObject var vm: WorkSessionViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var isCompact = false
    @State private var showExitConfirm = false
    @State private var showPausedDialog = false

    var body: some View {
        ZStack(alignment: .top) {
            // ── (Optional) Full‑screen bedroom background ──
//            Image("bedroom")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()

            // ── 1) Main content goes here ──
            //   This VStack holds the character and buttons. Because
            //   the header is overlaid, this content will never move
            //   when the header expands or collapses.
            VStack {
                Spacer()

                Image("blueAtDesk")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding(.horizontal)

                Spacer()

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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // We do NOT add any top padding here—header will layer over it.

            // ── 2) Header overlay (either full or compact) ──
            headerView
                .zIndex(1)   // Make sure the header is always on top

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

    // ── Header: either full (expanded) or compact (minimized) ──
    @ViewBuilder
    private var headerView: some View {
        if isCompact {
            // ── COMPACT HEADER: small capsule on the right that does not shift anything below ──
            HStack {
                Spacer()

                HStack(spacing: 8) {
                    // Only the current time (no “Task:” text here)
                    Text(vm.formattedTime)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    Color("PanelFill")
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("ButtonOutline"), lineWidth: 3)
                        )
                )
                .fixedSize() // hug just its content + padding
                .onTapGesture {
                    // Tapping this capsule expands to full mode
                    withAnimation(.easeInOut) {
                        isCompact = false
                    }
                }
            }
            .padding(.horizontal)                   // a bit of inset from screen edges
            .padding(.top, safeAreaTop() + 8)       // position under the notch

        } else {
            // ── FULL HEADER (expanded): covers top area, overlays main content ──
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

                        // 3) “Time Remaining” label
                        Text("Time Remaining")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.black)
                    }

                    Spacer()

                    // 4) Collapse icon (tap to minimize)
                    Button {
                        withAnimation(.easeInOut) {
                            isCompact = true
                        }
                    } label: {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .font(.title2)
                            .foregroundColor(.black)
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
            // This full header will float above main content without shifting it
        }
    }

    // ── Utility: grab the top safe‑area inset (notch height) ──
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

// ── Custom Progress Bar ──
struct CustomProgressBar: View {
    let progress: Double  // [0, 1]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.9))
                    .overlay(
                        Capsule()
                            .stroke(Color("PanelAccent"), lineWidth: 3)
                    )
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
