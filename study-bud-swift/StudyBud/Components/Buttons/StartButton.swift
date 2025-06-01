//
//  StartButton.swift
//  StudyBud
//
//  Created by Lauren Yu on 6/1/25.
//

import SwiftUI

struct StartButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.mainHeader)
                .padding(.vertical,6)
            
            Image(systemName: "chevron.right")
                .font(.mainHeader)
        }
        .startButtonStyle()
    }
}
