//
//  LandingView 2.swift
//  StudyBud
//
//  Created by Ayana Griffin on 5/30/25.
//


import SwiftUI

struct LandingHeader: View {
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("landing")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Text("MON, JUN 2ND").font(.mainHeader)
                        
                    }
                    


                    
                    HoursProgressBar(currentHours: 10, goalHours: 15)
                    
                }
            }
            .navigationDestination(isPresented: $navigate) {
                PreSessionView()
            }
        }
    }
}

#Preview {
    LandingHeader()
}

