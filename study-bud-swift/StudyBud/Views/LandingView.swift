import SwiftUI
import SwiftUI

struct LandingView: View {
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("landing")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                GeometryReader { geometry in
                    VStack(alignment: .center, spacing: 10) {
                        LandingHeader()
                            .padding(.top, 60)
                            .padding(.horizontal, 2)

                        Spacer()

                        StartButton(title: "START SESSION") {
                            navigate = true
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 80))
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .navigationDestination(isPresented: $navigate) {
                PreSessionView()
            }
        }
    }
}



#Preview {
    LandingView()
}
