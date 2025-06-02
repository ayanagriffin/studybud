import SwiftUI

struct SessionResultsView: View {
    @State private var step = 1
    @State private var selectedFeeling: Int? = nil

    var body: some View {
        ZStack {
            switch step {
            case 1:
                SessionResultsCoinsView {
                    step = 2
                }
            case 2:
                SessionResultsIntroView {
                    step = 3
                }
            case 3:
                SessionResultsFeelingView(selectedFeeling: $selectedFeeling) {
                    print("Feeling selected:", selectedFeeling ?? -1)
                }
            default:
                Text("Done")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
