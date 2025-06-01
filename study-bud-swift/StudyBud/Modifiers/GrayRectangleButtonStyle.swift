//
//  GrayRectangleModifier.swift
//  StudyBud
//

import SwiftUI

struct GrayRectangleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 52, height: 52)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 3)
            )
    }
}

extension View {
    func grayRectangleStyle() -> some View {
        self.modifier(GrayRectangleModifier())
    }
}
