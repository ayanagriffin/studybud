import SwiftUI

struct SessionResultsCoinsView: View {
    let onNext: () -> Void

    var body: some View {
        ZStack {
            Image("earn-coins")
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
