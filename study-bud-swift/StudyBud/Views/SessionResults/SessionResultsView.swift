import SwiftUI

struct SessionResultsView: View {
    @State private var step = 1
    @State private var selectedFeeling: Int? = nil

    var body: some View {
        ZStack {
            if step == 1 {
                SessionResultsIntroView {
                    step = 2
                }
            } else {
                SessionResultsFeelingView(selectedFeeling: $selectedFeeling) {
                    print("Feeling selected:", selectedFeeling ?? -1)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SessionResultsView()
}
