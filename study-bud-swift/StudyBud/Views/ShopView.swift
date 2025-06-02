import SwiftUI

struct ShopView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // ── Background image ──
            Image("shop-static")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer().frame(height: 16) // Push into safe area slightly, but not flush to top

                HStack {
                    BackArrow {
                        dismiss()
                    }

                    Spacer()

                    Spacer()

                    Spacer().frame(width: 44) // Placeholder to center title
                }
                .padding(.horizontal, 16)

                Spacer()
            }
            .padding(.top, UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
                .first ?? 44) // fallback top padding if safe area not available
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ShopView()
        }
    }
}
