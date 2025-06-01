//
//  ShopButton.swift
//  StudyBud
//
//  Created by Lauren Yu on 6/1/25.
//

import SwiftUI

struct StatsButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 1) {
                Image(systemName: "chart.bar.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                
                Text(title)
                    .font(.normalText)
                    .foregroundColor(.black)
            }
            .padding(4)
        }
        .grayRectangleStyle()
    }
}

#Preview {
    StatsButton(title: "Stats") {
        print("Stats tapped")
    }
}
