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

                VStack(spacing: 10) {
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Text("MON, JUN 2ND").font(.mainHeader)
                    }
                    
                    HoursProgressBar(currentHours: 10, goalHours: 15)
                    
                    StartButton(title: "START SESSION ") {
                        navigate = true
                    }
                    .padding(.horizontal, 40)

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

