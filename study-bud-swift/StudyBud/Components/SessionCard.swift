import SwiftUI

struct SessionCard: View {
    let title: String
    let subtitle: String
    let color: Color
    let borderColor: Color
    let actionTitle: String
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onTap) {
                Text(actionTitle)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(borderColor)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 130)
        .background(color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 2)
        )
    }
}
