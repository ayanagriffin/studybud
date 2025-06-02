//  ShopButton.swift
//  StudyBud
//
//  Created by Lauren Yu on 6/1/25.
//

import SwiftUI

struct ShopButton: View {
    var body: some View {
        NavigationLink(destination: ShopView()) {
                Image(systemName: "bag.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(height: 24)  // adjust as needed
        }

    }
}

#Preview {
    NavigationStack {
        ShopButton()
    }
}
