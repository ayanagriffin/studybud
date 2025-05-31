import SwiftUI

struct BackArrow: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .padding(8)
        }
    }
}

struct BackArrow_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            BackArrow { print("Back tapped") }
        }
    }
}
