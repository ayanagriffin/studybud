import SwiftUI

struct TextInput: View {
    @Binding var text: String
    var placeholder: String
    var width: CGFloat?

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "pencil")
                .foregroundColor(.gray)
                .font(.system(size: 20))

            TextField(placeholder, text: $text)
                .keyboardType(.numberPad)
                .font(.buttonText)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 12)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("ButtonFill"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color("ButtonOutline"), lineWidth: 4)
        )
        .frame(width: width ?? 280)
    }
}

#Preview {
    @State var customDurationText = ""

    return TextInput(text: $customDurationText, placeholder: "Say something else...", width: 280)
}
