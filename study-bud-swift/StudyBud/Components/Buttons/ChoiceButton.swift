import SwiftUI

struct ChoiceButton: View {
    let title: String
    let width: CGFloat?
    let verticalPadding: CGFloat
    let horizontalPadding: CGFloat
    let fontWeight: Font.Weight
    let action: () -> Void

    init(
        title: String,
        width: CGFloat? = nil,
        verticalPadding: CGFloat = 14,
        horizontalPadding: CGFloat = 2,
        fontWeight: Font.Weight = .medium,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.width = width
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
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
                .padding(.horizontal, horizontalPadding)
        }
        .buttonStyle(YellowOutlinedButtonStyle())
    }
}
