import SwiftUI

struct SessionResultsFeelingView: View {
    @Binding var selectedFeeling: Int?
    @State private var finished = false
    let onFinish: () -> Void

    var body: some View {
        NavigationStack {
            
            ZStack {
                Image("session-results-2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    FeelingSelection(selectedFeeling: $selectedFeeling)
                        .padding(.bottom, 100)
                    
                    ChoiceButton(title: "Finish", width: 200) {
                        finished = true
                    }
                        .padding(.bottom, 80)
                }
                
                NavigationLink(destination: LandingView(), isActive: $finished) {
                    EmptyView()
                }
            }
        }
    }
}
