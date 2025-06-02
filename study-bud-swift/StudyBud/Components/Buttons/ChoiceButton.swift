import SwiftUI

struct ChoiceButton: View {
    let title: String
    let width: CGFloat?
    let verticalPadding: CGFloat
    let fontWeight: Font.Weight
    let action: () -> Void

    init(
        title: String,
        width: CGFloat? = nil,
        verticalPadding: CGFloat = 12,
        fontWeight: Font.Weight = .medium,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.width = width
        self.verticalPadding = verticalPadding + 6
        self.fontWeight = fontWeight
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.buttonText)
                .foregroundColor(.black)
                .frame(width: width)
                .padding(.vertical, verticalPadding)
        }
        .buttonStyle(YellowOutlinedButtonStyle())
    }
}
