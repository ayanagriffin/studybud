import SwiftUI
import SwiftUI

struct LandingView: View {
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("empty-bedroom")
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
                GIFImage(gifName: "BlueCelebrating")
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 400, height: 400)
                                    .position(x: 200, y: 500)
                                    .allowsHitTesting(false) // Prevents the GIF from intercepting touches
                ChatBubbleView(text: "Hey John! I've been itching to do some work.", tailPosition: 0.7)
                    .frame(maxWidth: 300)
                    .position(x: 220, y: 300)
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
