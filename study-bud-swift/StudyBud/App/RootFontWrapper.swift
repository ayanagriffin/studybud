import SwiftUI

struct RootFontWrapper<Content: View>: View {
    var content: () -> Content

    var body: some View {
        content()
            .font(.normalText)
    }
}
