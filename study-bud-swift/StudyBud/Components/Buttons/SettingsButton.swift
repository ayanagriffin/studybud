import SwiftUI

struct SettingsButton: View {
    var body: some View {
        NavigationLink(destination: SettingsView()) {
            Image(systemName: "gearshape.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .frame(width: 36, height: 36)
        }
    }
}

#Preview {
    SettingsButton()
}
