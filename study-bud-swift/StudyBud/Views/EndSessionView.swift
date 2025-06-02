// Views/EndSessionView.swift

import SwiftUI

struct EndSessionView: View {
    @Environment(\.dismiss) private var dismiss

    // Local state for a custom duration string
    @State private var customDurationText: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // ── 1) Full‑screen bedroom background ──
                Image("empty-bedroom")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Image("blue")
            }
        }
    }

}

// MARK: – Preview
struct EndSessionView_Previews: PreviewProvider {
    static var previews: some View {
        EndSessionView()
    }
}

#Preview{
    EndSessionView()
}
