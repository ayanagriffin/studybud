import SwiftUI

struct LandingView: View {
    @State private var navigate = false
    @State private var showQuickstartModal = false
    @State private var quickstartDuration: Int? = nil
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("landing")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    VStack(alignment: .center, spacing: 10) {
                        // Header
                        LandingHeader()
                            .padding(.top, 70)
                            .padding(.horizontal, 2)
                        
                        Spacer()
                        
                        // Bottom Buttons
                        HStack(spacing: 16) {
                            // Quickstart circular button
                            Button(action: {
                                showQuickstartModal = true
                            }) {
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.black)
                                    .frame(width: 56, height: 56)
                                    .background(Circle().fill(Color.yellow))
                            }
                            
                            // Start session button
                            StartButton(title: "START SESSION") {
                                navigate = true
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 120))
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                
                // Chat bubble
                ChatBubbleView(text: "Hey John! I've been itching to do some work.", tailPosition: 0.7)
                    .frame(maxWidth: 300)
                    .position(x: 220, y: 300)
                
                // Darken background while modal is active
                if showQuickstartModal {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.2), value: showQuickstartModal)
                }
            }
            .sheet(isPresented: $showQuickstartModal) {
                QuickstartModalView { duration in
                    quickstartDuration = duration
                    showQuickstartModal = false
                }
                .presentationDetents([.fraction(0.75)])
                .presentationDragIndicator(.visible)
            }            // Navigate to PreSessionView (standard flow)
            .navigationDestination(isPresented: $navigate) {
                PreSessionView()
            }

            // Navigate to WorkSessionView (quickstart flow)
            .navigationDestination(isPresented: Binding(
                get: { quickstartDuration != nil },
                set: { if !$0 { quickstartDuration = nil } }
            )) {
                if let duration = quickstartDuration {
                    WorkSessionView(vm: WorkSessionViewModel(taskName: "Quickstart", durationMinutes: duration))
                }
            }

            
        }
    }
}

#Preview {
    LandingView()
}
