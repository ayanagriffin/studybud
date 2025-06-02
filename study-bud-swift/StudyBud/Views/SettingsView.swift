import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // ── Top bar with custom back arrow + title ──
            HStack {
                BackArrow {
                    dismiss()
                }
                
                Spacer()
                
                Text("Settings")
                    .font(.mainHeader)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Add a placeholder spacer so the title is centered
                Spacer().frame(width: 44)
            }
            
            Spacer()
            

        }
        .navigationBarBackButtonHidden(true)
        .background(Color.white.ignoresSafeArea())
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}

