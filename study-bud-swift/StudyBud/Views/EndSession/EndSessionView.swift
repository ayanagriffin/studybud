import SwiftUI

struct EndSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = EndSessionViewModel()
    @State private var customDurationText = ""
    @State private var showExitConfirm = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("empty-bedroom")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                Image("blue")

                if showExitConfirm {
                    ConfirmExitDialog {
                        vm.isSessionComplete = true
                    } onCancel: {
                        showExitConfirm = false
                    }
                    .zIndex(2)
                }

                VStack(spacing: 0) {
                    // Always reserve space for the back arrow
                    HStack {
                        if vm.step != .initial {
                            BackArrow { vm.step = .initial }
                        } else {
                            Color.clear.frame(width: 24, height: 24) // Invisible placeholder
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.top, safeAreaTop() + 8)

                    ChatBubbleView(text: vm.bubbleText, tailPosition: 0.5)
                        .padding(.horizontal, 32)
                        .padding(.top, 8)


                    Spacer()

                    EndSessionStepViews(vm: vm, customDurationText: $customDurationText, showExitConfirm: $showExitConfirm)
                        .padding(.bottom, safeAreaBottom() + 120)
                }

                // Navigation to next views
                NavigationLink("", isActive: $vm.isWorkSessionActive) {
                    WorkSessionView(vm: vm.workSessionVM!)
                }
                NavigationLink("", isActive: $vm.isBreakActive) {
                    BreakView(duration: CGFloat(vm.breakDuration ?? 5), isActive: $vm.isBreakActive)
                }
                NavigationLink("", isActive: $vm.isSessionComplete) {
                    SessionResultsView()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private func safeAreaTop() -> CGFloat {
        UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    }

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
}


#Preview{
    EndSessionView()
}

