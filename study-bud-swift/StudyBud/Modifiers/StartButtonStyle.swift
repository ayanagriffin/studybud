//
//  StartButtonStyle.swift
//  StudyBud
//
//  Created by Lauren Yu on 6/1/25.
//

import SwiftUI

struct StartButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.button)
                    .stroke(Color.orangeYellow, lineWidth: 8)
            )
            .cornerRadius(CornerRadius.button)
    }
}

extension View {
    func startButtonStyle() -> some View {
        self.modifier(StartButtonStyle())
    }
}
