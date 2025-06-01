//
//  ShopButton.swift
//  StudyBud
//
//  Created by Lauren Yu on 6/1/25.
//

import SwiftUI

struct ShopButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: "bag.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .foregroundColor(.gray)
                
                Text(title)
                    .font(.normalText)
                    .foregroundColor(.black)
            }
        }
        .grayRectangleStyle()
    }
}

#Preview {
    ShopButton(title: "Shop") {
        print("Shop tapped")
    }
}
