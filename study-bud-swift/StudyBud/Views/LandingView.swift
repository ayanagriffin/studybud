//
//  LandingView 2.swift
//  StudyBud
//
//  Created by Ayana Griffin on 5/30/25.
//


import SwiftUI

struct LandingView: View {
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("landing")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()
                    
                    
                    StartButton(title: "START SESSION ") {
                        navigate = true
                    }
                    .padding(.horizontal, 40) // Optional: padding for better layout


                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigate) {
                PreSessionView()
            }
        }
    }
}

#Preview {
    LandingView()
}

