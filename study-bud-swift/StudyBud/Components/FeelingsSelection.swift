import SwiftUI

struct FeelingSelection: View {
    @Binding var selectedFeeling: Int?
    let feelingImages = (1...5).map { "feeling-\($0)" }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { index in
                        Image(feelingImages[index - 1])
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: selectedFeeling == index ? 90 : 50,
                                   height: selectedFeeling == index ? 90 : 50)
                            .clipped() // prevent overflow
                            .background(Color.clear)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: selectedFeeling == index ? 4 : 0)
                            )
                            .scaleEffect(selectedFeeling == index ? 1.1 : 0.9)
                            .animation(.easeInOut(duration: 0.2), value: selectedFeeling)
                            .onTapGesture {
                                selectedFeeling = (selectedFeeling == index) ? 0 : index
                            }
                    }
                }
                .frame(width: geometry.size.width, alignment: .center)
                .padding(.vertical, 50)
            }
        }
        .frame(height: 120) // Set max height to prevent overflow wiggle
    }
}


struct StatefulPreviewWrapper<Value: Equatable, Content: View>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> Content

    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

#Preview {
    StatefulPreviewWrapper(nil) { binding in
        FeelingSelection(selectedFeeling: binding)
    }
}
