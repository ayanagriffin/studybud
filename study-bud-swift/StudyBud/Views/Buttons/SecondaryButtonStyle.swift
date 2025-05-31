// Views/Buttons/SecondaryButtonStyle.swift

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.black)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("AccentYellow"), lineWidth: 2)
            )
            .cornerRadius(16)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Secondary") { }
            .buttonStyle(SecondaryButtonStyle())
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}
