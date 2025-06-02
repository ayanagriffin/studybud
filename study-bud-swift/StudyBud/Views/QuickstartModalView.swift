import SwiftUI

struct QuickstartModalView: View {
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("⚡")
                Text("Session Quickstart")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal)

            // Last Session
            SessionCard(
                title: "Your Last Session",
                subtitle: "90 min work, 10 min break",
                color: Color.orange.opacity(0.2),
                buttonColor: Color.orange
            )

            // Pomodoro Session
            SessionCard(
                title: "Pomodoro Session 🖊️",
                subtitle: "90 min work, 10 min break",
                color: Color.green.opacity(0.2),
                buttonColor: Color.green
            )

            // Save Custom Session
            HStack {
                Image(systemName: "plus")
                Text("Save a Custom Session")
                    .fontWeight(.medium)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding(.horizontal)

            // Percy Card
            HStack {
                Image("percy") // Replace with your Percy asset
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.leading)

                Text("Percy will guide you through setting up the perfect work session")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 8)

                Spacer()

                Button {
                    // Action
                } label: {
                    Image(systemName: "play.fill")
                        .foregroundColor(.yellow)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color.white))
                }
                .padding()
            }
            .background(Color.yellow.opacity(0.8))
            .cornerRadius(20)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.bottom, 20)
    }
}


#Preview {
    QuickstartModalView()
}
