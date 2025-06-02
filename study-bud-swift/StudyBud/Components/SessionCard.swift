import SwiftUI

struct SessionCard: View {
    let title: String
    let subtitle: String
    let color: Color
    let buttonColor: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
            }
            Spacer()
            Button {
                // Start session
            } label: {
                HStack {
                    Text("Start")
                    Image(systemName: "play.fill")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
        .padding()
        .background(color)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
