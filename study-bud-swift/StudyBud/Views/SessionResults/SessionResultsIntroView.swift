import SwiftUI

struct SessionResultsIntroView: View {
    let onNext: () -> Void

    var body: some View {
        ZStack {
            Image("session-results-1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()
                ChoiceButton(title: "Next", width: 200, action: onNext)
                    .padding(.bottom, 80)
            }
        }
    }
}
