import SwiftUI

struct WorkSessionView: View {
    @StateObject var vm: WorkSessionViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var isCompact = false
    @State private var showExitConfirm = false
    @State private var showPausedDialog = false

    var body: some View {
        ZStack(alignment: .top) {
            // ── 1) Full‑screen bedroom background ──
            Image("landing")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // ── 2) Main content (character + buttons) ──
            //    We do NOT give this VStack any top padding,
            //    because headerView will float on top of it.
            VStack {
                Spacer()

//                Image("blueAtDesk")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(maxHeight: 300)
//                    .padding(.horizontal)

                Spacer()

                HStack(spacing: 24) {
                    CircleButton(iconName: "xmark", label: "Exit") {
                        vm.pause()
                        withAnimation {
                            showExitConfirm = true
                        }
                    }
                    CircleButton(iconName: "pause.fill", label: "Pause") {
                        vm.pause()
                        withAnimation {
                            showPausedDialog = true
                        }
                    }
                }
                .padding(.bottom, 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // No top padding here: headerView will overlay.

            // ── 3) Header (either full or compact) ──
            headerView
                .fixedSize(horizontal: false, vertical: true)
                .zIndex(1)

            // ── 4) Exit confirmation overlay ──
            if showExitConfirm {
                VStack(spacing: 16) {
                    // A) ChatBubbleView for the “Are you sure…?” message
                    ChatBubbleView(
                        text: "Are you sure you want to exit?",
                        tailPosition: 0.85
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)

                    // B) Yes / No buttons
                    HStack(spacing: 24) {
                        Button("Yes") {
                            vm.exit()
                            dismiss()
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(minWidth: 120, minHeight: 44)
                        .background(Color.clear)

                        Button("No") {
                            vm.resume()
                            withAnimation {
                                showExitConfirm = false
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(minWidth: 120, minHeight: 44)
                        .background(
                            Color("ButtonFill")
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("ButtonOutline"), lineWidth: 3)
                        )
                    }
                }
                .padding(24)
                .background(
                    Color.white.opacity(0.95)
                        .cornerRadius(20)
                        .shadow(radius: 8)
                )
                .frame(maxWidth: 400)
                .padding(.horizontal, 24)
                .padding(.top, safeAreaTop() + 100)
                .zIndex(2)
            }

            // ── 5) Pause confirmation overlay ──
            if showPausedDialog {
                VStack(spacing: 16) {
                    // A) “Paused” title
                    Text("Paused")
                        .font(.mainHeader)
                        .bold()
                        .foregroundColor(.black)

                    // B) The pause ChatBubbleView
                    ChatBubbleView(
                        text: "Ok, but don’t take too long! Come back soon!",
                        tailPosition: 0.85
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)

                    // C) “Resume” button
                    Button("Resume") {
                        vm.resume()
                        withAnimation {
                            showPausedDialog = false
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 180, height: 44)
                    .background(
                        Color("ButtonFill")
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("ButtonOutline"), lineWidth: 3)
                    )
                }
                .padding(24)
                .background(
                    Color.white.opacity(0.95)
                        .cornerRadius(20)
                        .shadow(radius: 8)
                )
                .frame(maxWidth: 400)
                .padding(.horizontal, 24)
                .padding(.top, safeAreaTop() + 100)
                .zIndex(2)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // ── Header (full or compact) ──
    @ViewBuilder
    private var headerView: some View {
        if isCompact {
            // ── COMPACT version: a small capsule showing just the time ──
            HStack {
                Text(vm.formattedTime)
                    .font(.buttonText)
                    .bold()
                    .foregroundColor(.black)
            }
            .frame(maxWidth: 80)
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(
                Color("PanelFill")
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("ButtonOutline"), lineWidth: 4)
                    )
            )
            .onTapGesture {
                withAnimation(.easeInOut) {
                    isCompact = false
                }
            }
            .offset(y: safeAreaTop() + 16)

        } else {
            // ── FULL version: task, timer, “Time Remaining”, percent + progress bar ──
            VStack(spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Task: \(vm.taskName)")
                            .font(.subheadline)
                            .foregroundColor(.black)

                        Text(vm.formattedTime)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)

                        Text("Time Remaining")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.black)
                    }

                    Spacer()

                    Button {
                        withAnimation(.easeInOut) {
                            isCompact = true
                        }
                    } label: {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .offset(y: -2)
                    }
                }

                HStack(spacing: 0) {
                    Text("\(vm.percentComplete)%")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color("PanelAccent"))
                    Text(" Complete")
                        .font(.caption)
                        .foregroundColor(Color("PanelAccent"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                CustomProgressBar(progress: vm.progress)
                    .frame(height: 14)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(
                width: UIScreen.main.bounds.width - 32  // <–– force full banner to be screen.width – 32
            )
            .background(
                Color("PanelFill")
                    .cornerRadius(20)
            )
            .offset(y: safeAreaTop() + 16)

        }
    }


    // ── Custom progress bar remains unchanged ──
    struct CustomProgressBar: View {
        let progress: Double
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

    // ── Utility to read the top safe‑area inset ──
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

struct WorkSessionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSessionView(
            vm: WorkSessionViewModel(taskName: "Homework", durationMinutes: 50)
        )
    }
}
