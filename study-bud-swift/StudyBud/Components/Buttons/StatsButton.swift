import SwiftUI

struct StatsButton: View {
    
    var body: some View {
        // Instead of a Button, use a NavigationLink directly
        NavigationLink(destination: StatsView()) {
            VStack(spacing: 1) {
                Image(systemName: "chart.bar.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(height: 24)      // adjust icon size as needed
            }
            .padding(8)
        }
    }
}

#Preview {
    NavigationStack {
        StatsButton()
            .padding()
    }
}
