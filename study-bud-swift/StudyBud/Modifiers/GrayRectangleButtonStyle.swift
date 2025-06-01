//
//  GrayRectangleModifier.swift
//  StudyBud
//

import SwiftUI

struct GrayRectangleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 72, height: 72)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 4)
            )
    }
}

extension View {
    func grayRectangleStyle() -> some View {
        self.modifier(GrayRectangleModifier())
    }
}
