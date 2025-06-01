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
            // ── 1) Full‐screen bedroom background ──
//            Image("bedroom")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()

            // ── 2) All other content lives in a VStack that respects safe areas ──
            VStack {
                headerView   // this will automatically be placed below the notch
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
            // No .ignoresSafeArea here, so headerView will sit below the status bar/notch

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
    }

    // ── Header that automatically sits below the notch ──
    @ViewBuilder
    private var headerView: some View {
        if isCompact {
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
                        .padding(.trailing, 12)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)    // small extra padding under status bar
        } else {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Task: \(vm.taskName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(vm.formattedTime)
                        .font(.title)
                        .bold()

                    Text("\(vm.percentComplete)% Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ProgressView(value: vm.progress)
                        .scaleEffect(x: 1, y: 4, anchor: .center)
                        .clipShape(Capsule())
                }

                Spacer()

                Button {
                    isCompact = true
                } label: {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                        .font(.title3)
                }
                .padding(.top, 4)
                .padding(.trailing, 12)
            }
            .padding()
            .background(Color.white.opacity(0.9))  // semi‑opaque white
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top, 8)   // small extra padding under status bar
        }
    }
}

struct WorkSessionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSessionView(
            vm: WorkSessionViewModel(taskName: "Read Chapter", durationMinutes: 1)
        )
    }
}
