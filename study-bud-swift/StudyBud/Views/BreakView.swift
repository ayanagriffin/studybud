import SwiftUI

struct BreakView: View {
    let duration: CGFloat

    @State private var currentAffirmation: String = ""
    @State private var isBubbleVisible: Bool = false

    private let affirmations = [
        "What a well-earned break!",
        "I love relaxing in the sun.",
        "You're doing great!",
        "Time to breathe and reset.",
        "So proud of your progress!",
        "This chill time is powerful."
    ]

    var body: some View {
        ZStack {
            Image("grass")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                TimeProgressView()
                Spacer()

                if isBubbleVisible {
                    ChatBubbleView(text: currentAffirmation)
                        .padding(.top, 24)
                        .transition(.opacity)
                }

                Image("blue")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .scaleEffect(x: -1, y: 1)
                    .rotationEffect(.degrees(-40))
                    .padding(.bottom, 110)
                    .onTapGesture {
                        showRandomAffirmation()
                    }
            }
        }
        .animation(.easeInOut, value: isBubbleVisible)
    }

    private func showRandomAffirmation() {
        currentAffirmation = affirmations.randomElement() ?? "You're awesome!"
        isBubbleVisible = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            isBubbleVisible = false
        }
    }
}

#Preview{
    BreakView(duration: 5)
}
