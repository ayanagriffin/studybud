// Views/Buttons/PrimaryButtonStyle.swift

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.black)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                Color("AccentYellow")      // your custom yellow in Assets
            )
            .cornerRadius(16)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PrimaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Primary") { }
            .buttonStyle(PrimaryButtonStyle())
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}
