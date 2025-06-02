import SwiftUI

struct EndSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = EndSessionViewModel()
    @State private var customDurationText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Image("empty-bedroom")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                Image("blue")

                VStack(spacing: 0) {
                    HStack {
                        BackArrow {
                            if vm.step != .initial {
                                vm.step = .initial
                            } else {
                                dismiss()
                            }
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.top, safeAreaTop() + 8)


                    ChatBubbleView(text: bubbleText, tailPosition: 0.5)
                        .padding(.horizontal, 32)
                        .padding(.top, 8)

                    Spacer()

                    Group {
                        switch vm.step {
                        case .initial:
                            nextOptions
                        case .chooseWorkDuration, .chooseBreakDuration:
                            durationSelection
                        case .confirmWorkStart:
                            confirmWorkStartView // <— create this in your view
                        }
                    }
                    .padding(.bottom, safeAreaBottom() + 64)
                }

                NavigationLink("", isActive: $vm.isWorkSessionActive) {
                    WorkSessionView(vm: vm.workSessionVM!)
                }

                NavigationLink("", isActive: $vm.isBreakActive) {
                    BreakView(duration: CGFloat(vm.breakDuration ?? 5))
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private var nextOptions: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ChoiceButton(title: "Keep Going", width: 160) {
                    vm.selectNext("Keep Going")
                }
                ChoiceButton(title: "Take a Break", width: 160) {
                    vm.selectNext("Take a Break")
                }
            }
            ChoiceButton(title: "End Session", width: 160) {
                dismiss()
            }
        }
    }

    private var durationSelection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                if vm.step == .chooseBreakDuration {
                    ChoiceButton(title: "5 Minutes", width: 130) {
                        vm.selectDuration(5)
                    }
                    ChoiceButton(title: "10 Minutes", width: 130) {
                        vm.selectDuration(10)
                    }
                } else if vm.step == .chooseWorkDuration {
                    ChoiceButton(title: "30 Minutes", width: 130) {
                        vm.selectDuration(30)
                    }
                    ChoiceButton(title: "45 Minutes", width: 130) {
                        vm.selectDuration(45)
                    }
                }
            }

            TextInput(text: $customDurationText, placeholder: "Say something else...", width: 240)

        }
    }
    
    private var confirmWorkStartView: some View {
        VStack(spacing: 24) {
            StartButton(title: "Let’s go!") {
                vm.startWorkSession()
            }.frame(maxWidth: 250)
        }
        .frame(maxWidth: .infinity)
    }



    private var bubbleText: String {
        switch vm.step {
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

    private func safeAreaTop() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }?
            .safeAreaInsets.top ?? 0
    }

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom ?? 0
    }
}

#Preview {
    EndSessionView()
}
