import SwiftUI

struct ShopView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // ── Top bar with custom back arrow + title ──
            HStack {
                BackArrow {
                    dismiss()
                }
                
                Spacer()
                
                Text("Shop")
                    .font(.mainHeader)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Add a placeholder spacer so the title is centered
                Spacer().frame(width: 44)
            }
            .padding(.horizontal, 16)
            Spacer()
            

        }
        .navigationBarBackButtonHidden(true)
        .background(Color.white.ignoresSafeArea())
    }
    
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ShopView()
        }
    }
}


