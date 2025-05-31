//
//  YellowFilledButtonStyle.swift
//  StudyBud
//
//  Created by Ayana Griffin on 5/30/25.
//


import SwiftUI

/// A solid golden background button with black text and rounded corners.
/// Used for “30 Minutes”, “45 Minutes”, and “Start…” actions.
struct YellowFilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("AccentYellow"))
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
