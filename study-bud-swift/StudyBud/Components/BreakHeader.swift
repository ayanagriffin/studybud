import SwiftUI
import Combine

struct BreakHeader: View {
    let totalTime: CGFloat
    
    @State private var currentTime: CGFloat = 0
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    
    private var timeRemaining: Int {
        max(0, Int(ceil(totalTime - currentTime)))
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(timeRemaining) min left in break")
                .font(.buttonText)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.top, 16)
            
            TimeProgressBar(currentTime: currentTime, totalTime: totalTime, label: "Break")
        }
        .padding()
        .onAppear {
            timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        }
        .onReceive(timer ?? Timer.publish(every: 10, on: .main, in: .common).autoconnect()) { _ in
            guard currentTime < totalTime else {
                timer = nil
                return
            }
            
            withAnimation(.easeInOut(duration: 0.5)) {
                currentTime += 3.0 / 60.0 
            }
        }
    }
}
