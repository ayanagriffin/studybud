import SwiftUI
import Combine

struct TimeProgressView: View {
    let totalTime: CGFloat = 1 // total in minutes or seconds

    @State private var currentTime: CGFloat = 0
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?

    var body: some View {
        VStack {
            TimeProgressBar(currentTime: currentTime, totalTime: totalTime, label: "Break")

            Spacer()
        }
        .padding()
        .onAppear {
            // Start a 10-second repeating timer
            timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
        }
        .onReceive(timer ?? Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard currentTime < totalTime else {
                timer = nil // stop timer if done
                return
            }

            withAnimation(.easeInOut(duration: 0.5)) {
                currentTime += 10.0 / 60.0 // 10 seconds in minutes
            }
        }
    }
}

#Preview {
    TimeProgressView()
}
