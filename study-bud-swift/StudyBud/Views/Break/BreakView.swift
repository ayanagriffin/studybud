import SwiftUI

struct BreakView: View {
    let duration: CGFloat
    @Binding var isActive: Bool
    @Environment(\.dismiss) private var dismiss

    var onResume: (() -> Void)? = nil
    var onExit: (() -> Void)? = nil

    @State private var showExitConfirm = false
    @State private var currentAffirmation: String = ""
    @State private var isBubbleVisible: Bool = false
    @State private var navigateToEnd = false

    private let affirmations = [
        "What a well-earned break!",
        "I love relaxing in the sun.",
        "You're doing great!",
        "Time to breathe and reset.",
        "So proud of your progress!",
        "This chill time is powerful."
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Image("grass")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    BreakHeader(totalTime: duration)
                    Spacer()

                    ZStack {
                        Image("blue")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .scaleEffect(x: -1, y: 1)
                            .rotationEffect(.degrees(-40))
                            .onTapGesture {
                                showRandomAffirmation()
                            }

                        if isBubbleVisible {
                            ChatBubbleView(text: currentAffirmation)
                                .offset(y: -180)
                                .transition(.opacity)
                        }
                    }
                    .padding(.bottom, 110)
                }

                VStack {
                    Spacer()
                    CircleButton(iconName: "xmark", label: "End") {
                        showExitConfirm = true
                    }
                    .padding(.bottom, 30)
                }

                DialogView(
                    isPresented: $showExitConfirm,
                    title: "Are you sure?",
                    message: "Are you sure you want to end your break?",
                    characterImageName: "blue",
                    onClose: {
                        onResume?()
                    }
                ) {
                    HStack(spacing: 16) {
                        Button(action: {
                            onExit?()
                            navigateToEnd = true
                        }) {
                            Text("Yes")
                                .font(.buttonText)
                                .foregroundColor(.black)
                                .frame(minWidth: 100, minHeight: 44)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                        )

                        ChoiceButton(title: "No", width: 100) {
                            onResume?()
                            withAnimation { showExitConfirm = false }
                        }
                    }
                }
                .zIndex(2)
            }
            .navigationDestination(isPresented: $navigateToEnd) {
                EndSessionView()
            }
            .animation(.easeInOut, value: isBubbleVisible)
            .onAppear {
                let totalSeconds = Int(duration * 60)
                print("Break starting — will dismiss in \(totalSeconds) seconds")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { 
                    print("Timer fired, dismissing BreakView")
                    self.isActive = false
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private func showRandomAffirmation() {
        currentAffirmation = affirmations.randomElement() ?? "You're awesome!"
        isBubbleVisible = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            isBubbleVisible = false
        }
    }
}


#Preview {
    BreakView(duration: 1, isActive: .constant(true))
}
