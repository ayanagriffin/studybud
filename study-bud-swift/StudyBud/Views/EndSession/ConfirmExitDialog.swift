import SwiftUI

struct ConfirmExitDialog: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        DialogView(
            isPresented: .constant(true),
            title: "Are you sure?",
            message: "Are you sure you want to end?",
            characterImageName: "blue",
            onClose: onCancel
        ) {
            HStack(spacing: 16) {
                Button(action: onConfirm) {
                    Text("Yes")
                        .font(.buttonText)
                        .foregroundColor(.black)
                        .frame(minWidth: 100, minHeight: 44)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20).fill(Color.white)
                )

                ChoiceButton(title: "No", width: 100, action: onCancel)
            }
        }
    }
}
