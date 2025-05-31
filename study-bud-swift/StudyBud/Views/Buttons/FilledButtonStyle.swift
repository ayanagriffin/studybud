//
//  FilledButtonStyle.swift
//  StudyBud
//
//  Created by Ayana Griffin on 5/30/25.
//


import SwiftUI

/// A fully filled golden button with black text for “Set” and “Start” actions.
struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("AccentYellow"))
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct FilledButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Filled") { }
            .buttonStyle(FilledButtonStyle())
            .foregroundColor(.black)
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}
