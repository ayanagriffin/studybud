import SwiftUI
import Combine

struct WorkSessionView: View {
    @StateObject var vm: WorkSessionViewModel
    @Environment(\.dismiss) private var dismiss
    
    // ── State for compact/full header ──
    @State private var isCompact = false
    
    // ── State for exit/pause dialogs ──
    @State private var showExitConfirm = false
    @State private var showPausedDialog = false
    
    // ── Navigation to end screen ──
    @State private var navigateToEnd = false
    
    // ── NEW: Navigation to LandingView ──
    @State private var navigateToLanding = false
    
    // ── NEW: State for chat bubble ──
    @State private var showChatBubble = false
    @State private var currentMotivation: String = ""
    
    // ── NEW: Timer cancellable ──
    @State private var motivationTimerCancellable: Cancellable?
    
    // ── NEW: Array of motivational phrases ──
    private let motivationalMessages: [String] = [
        "You’ve got this! Keep focused.",
        "One minute at a time!",
        "Step by step!",
        "Keep breathing. Keep going.",
        "Your future self thanks you!"
    ]
    
    // ── NEW: Interval in seconds (e.g. every 3 minutes = 180s) ──
    private let intervalSeconds: TimeInterval = 5 * 60
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // ── 1) Full‑screen bedroom background ──
                Image("bedroom")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .onTapGesture {
                        fireMotivationBubble()
                    }
                
                // ── 2) Main content (character + buttons) ──
                VStack {
                    Spacer()
                    
                    ZStack {
                        // ── Character GIF ──
                        GIFImage(gifName: "BlueWorking")
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(14))
                            .offset(x: 120, y: safeAreaTop() + 37)
                        
                        // ── NEW: Chat bubble overlay ──
                        if showChatBubble {
                            ChatBubbleView(text: currentMotivation)
                                .offset(x: 20, y: safeAreaTop() - 10)
                                .transition(.opacity.combined(with: .scale))
                                .zIndex(5) // Ensure it’s above the character
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 24) {
                        CircleButton(iconName: "xmark", label: "Exit") {
                            vm.pause()
                            withAnimation {
                                showExitConfirm = true
                            }
                        }
                        CircleButton(iconName: "pause.fill", label: "Pause") {
                            vm.pause()
                            withAnimation {
                                showPausedDialog = true
                            }
                        }
                    }
                    .padding(.bottom, 120)
                }
                
                // ── 3) Header (full or compact) ──
                headerView
                    .fixedSize(horizontal: false, vertical: true)
                    .zIndex(1)
                
                // ── 4) Exit confirmation overlay ──
                DialogView(
                    isPresented: $showExitConfirm,
                    title: "Are you sure?",
                    message: "Are you sure you want to exit?",
                    characterImageName: "blue",
                    onClose: {
                        vm.resume()
                    }
                ) {
                    HStack(spacing: 16) {
                        Button(action: {
                            vm.exit()
                            // Instead of dismiss(), navigate to LandingView:
                            navigateToLanding = true
                        }) {
                            Text("Yes")
                                .font(.buttonText)
                                .foregroundColor(.black)
                                .frame(minWidth: 100, minHeight: 44)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                        )
                        
                        ChoiceButton(title: "No", width: 100) {
                            vm.resume()
                            withAnimation { showExitConfirm = false }
                        }
                    }
                }
                .zIndex(2)
                
                // ── Navigation to EndSessionView ──
                NavigationLink(destination: EndSessionView(), isActive: $navigateToEnd) {
                    EmptyView()
                }
                
                // ── Navigation to LandingView when user taps “Yes” on exit ──
                NavigationLink(destination: LandingView(), isActive: $navigateToLanding) {
                    EmptyView()
                }
                
                // ── 5) Pause confirmation dialog ──
                DialogView(
                    isPresented: $showPausedDialog,
                    title: "Paused",
                    message: "Ok, but don’t take too long! Come back soon!",
                    characterImageName: "blue",
                    onClose: {
                        vm.resume()
                    }
                ) {
                    ChoiceButton(
                        title: "Resume",
                        width: 220,
                        fontWeight: .semibold
                    ) {
                        vm.resume()
                        withAnimation {
                            showPausedDialog = false
                        }
                    }
                }
                .zIndex(2)
            }
            // Hide the default back button if inside a NavigationStack
            .navigationBarBackButtonHidden(true)
            .onAppear {
                startMotivationTimer()
            }
            .onDisappear {
                cancelMotivationTimer()
            }
            .onChange(of: vm.isComplete) { complete in
                if complete {
                    print("session completed")
                    navigateToEnd = true
                    cancelMotivationTimer()
                }
            }
            .onChange(of: vm.isPaused) { paused in
                // If user pauses the session, also pause/hide the motivation bubble
                if paused {
                    hideChatBubbleImmediately()
                    cancelMotivationTimer()
                } else {
                    // If user resumes, restart the motivation timer from scratch
                    startMotivationTimer()
                }
            }
        }
    }
    
    // ── Header (full or compact) ──
    @ViewBuilder
    private var headerView: some View {
        if isCompact {
            // ── COMPACT version: a small capsule showing just the time ──
            HStack {
                Text(vm.formattedTime)
                    .font(.buttonText)
                    .bold()
                    .foregroundColor(.black)
            }
            .frame(maxWidth: 80)
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(
                Color("PanelFill")
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("ButtonOutline"), lineWidth: 4)
                    )
            )
            .onTapGesture {
                withAnimation(.easeInOut) {
                    isCompact = false
                }
            }
            .offset(y: safeAreaTop() + 16)
            
        } else {
            // ── FULL version: task, timer, “Time Remaining”, percent + progress bar ──
            VStack(spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Task: \(vm.taskName)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        Text(vm.formattedTime)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                        
                        Text("Time Remaining")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut) {
                            isCompact = true
                        }
                    } label: {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .offset(y: -2)
                    }
                }
                
                HStack(spacing: 0) {
                    Text("\(vm.percentComplete)%")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color("PanelAccent"))
                    Text(" Complete")
                        .font(.caption)
                        .foregroundColor(Color("PanelAccent"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomProgressBar(progress: vm.progress)
                    .frame(height: 14)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(
                width: UIScreen.main.bounds.width - 32
            )
            .background(
                Color("PanelFill")
                    .cornerRadius(20)
            )
            .offset(y: safeAreaTop() + 16)
            
        }
    }
    
    // ── Custom progress bar remains unchanged ──
    struct CustomProgressBar: View {
        let progress: Double
        var body: some View {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.9))
                        .overlay(
                            Capsule()
                                .stroke(Color("PanelAccent"), lineWidth: 3)
                        )
                    Capsule()
                        .fill(Color.red.opacity(0.8))
                        .frame(width: max(CGFloat(progress) * geo.size.width, 0))
                }
            }
        }
    }
    
    // ── Utility to read the top safe‑area inset ──
    private func safeAreaTop() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }?
            .safeAreaInsets
            .top ?? 0
    }
    
    
    // ── NEW: Start the Combine timer to fire every intervalSeconds ──
    private func startMotivationTimer() {
        // If there's already a timer active, cancel it first
        motivationTimerCancellable?.cancel()
        
        // Only schedule if session is not complete or paused
        guard !vm.isComplete, !vm.isPaused else { return }
        
        motivationTimerCancellable = Timer
            .publish(every: intervalSeconds, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                fireMotivationBubble()
            }
    }
    
    // ── NEW: Cancel the timer if needed ──
    private func cancelMotivationTimer() {
        motivationTimerCancellable?.cancel()
        motivationTimerCancellable = nil
    }
    
    // ── NEW: When timer fires, pick a message & show bubble ──
    private func fireMotivationBubble() {
        print("firing motivation bubble")
        // If already showing a bubble, just ignore this tick
        guard !showChatBubble else { return }
        
        // Pick a random—or you can rotate—message
        currentMotivation = motivationalMessages.randomElement() ?? ""
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showChatBubble = true
        }
        
        // Hide the bubble after a short delay (e.g. 3s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showChatBubble = false
            }
        }
    }
    
    // ── NEW: Hide bubble immediately (e.g. on pause or exit) ──
    private func hideChatBubbleImmediately() {
        motivationTimerCancellable?.cancel()
        withAnimation(.easeInOut(duration: 0.1)) {
            showChatBubble = false
        }
    }
}

struct WorkSessionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSessionView(
            vm: WorkSessionViewModel(taskName: "Homework", durationMinutes: 3)
        )
    }
}
