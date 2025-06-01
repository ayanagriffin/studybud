import SwiftUI

struct SettingsButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "gearshape.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
        }
        .frame(width: 36, height: 36) // ✅ Final size constraint
    }
}

#Preview {
    SettingsButton {
        print("Settings Pressed")
    }
}
