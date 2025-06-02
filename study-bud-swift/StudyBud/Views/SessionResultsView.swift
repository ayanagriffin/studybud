import SwiftUI

struct SessionResultsView: View {
    @State private var imageIndex = 1

    var body: some View {
        ZStack {
            Image(imageIndex == 1 ? "session-results-1" : "session-results-2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            

            VStack {
                Spacer()
                ChoiceButton(title: "Next", width: 200) {
                    imageIndex = 2
                }
                .padding(.bottom, 100)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SessionResultsView()
}
