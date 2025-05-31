//
//  OutlinedButtonStyle.swift
//  StudyBud
//
//  Created by Ayana Griffin on 5/30/25.
//


import SwiftUI

/// A button with a white fill, golden border, and rounded corners.
/// Used for “Homework” / “Chores” presets.
struct OutlinedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.white.opacity(0.8))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("AccentYellow"), lineWidth: 3)
            )
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct OutlinedButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Outlined") { }
            .buttonStyle(OutlinedButtonStyle())
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}
