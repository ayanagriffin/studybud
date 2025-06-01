import SwiftUI

struct DurationSelectionView: View {
    let onSelect: (Int) -> Void   // 30 or 45

    var body: some View {
        HStack(spacing: 16) {
            Button(action: { onSelect(30) }) {
                Text("30 Minutes")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(YellowOutlinedButtonStyle())

            Button(action: { onSelect(45) }) {
                Text("45 Minutes")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(YellowOutlinedButtonStyle())
        }
    }
}

struct DurationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DurationSelectionView(onSelect: { _ in })
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}
