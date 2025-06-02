import SwiftUI

struct BreakView: View {
    let duration: Int

    var body: some View {
        VStack {
            Spacer()
            Text("Enjoy your \(duration)-minute break!")
                .font(.title)
                .padding()
            Spacer()
        }
        .background(Color("blue").ignoresSafeArea())
    }
}
