import SwiftUI

struct SessionResultsView: View {
    var body: some View {
        ZStack {
            Image("empty-bedroom")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image("blue")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)

                Text("Session Complete!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Text("Amazing job staying focused. Let’s keep it up!")
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal)

                NavigationLink("Back to Home") {
                    EndSessionView()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .padding(.horizontal, 32)
        }
    }
}
