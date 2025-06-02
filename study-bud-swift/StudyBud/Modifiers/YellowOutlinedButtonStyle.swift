//
//  YellowOutlinedButtonStyle.swift
//  StudyBud
//
//  Created by Ayana Griffin on 5/30/25.
//


import SwiftUI

// A button with a white‐semi‑opaque fill, golden border, and rounded corners.
// Used for “Homework”, “Chores”, and the “Say something else…” text field outline.
struct YellowOutlinedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("InputButtonFill"))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("InputButtonOutline"), lineWidth: 8)
            )
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
