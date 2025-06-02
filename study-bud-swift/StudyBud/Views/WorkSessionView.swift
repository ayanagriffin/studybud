import SwiftUI

struct WorkSessionView: View {
    @StateObject var vm: WorkSessionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isCompact = false
    @State private var showExitConfirm = false
    @State private var showPausedDialog = false
    @State private var navigateToEnd = false
    
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .top) {
                // ── 1) Full‑screen bedroom background ──
                Image("bedroom")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                

                // ── 2) Main content (character + buttons) ──
                VStack {
                    Spacer()
                    GIFImage(gifName: "BlueWorking")
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(14))
                        .offset(x: 120, y: safeAreaTop() + 37)
                    
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
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
                // No top padding here: headerView will overlay.
                
                // ── 3) Header (either full or compact) ──
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
                            dismiss()
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
                
                NavigationLink(destination: EndSessionView(), isActive: $navigateToEnd) {
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
            .onChange(of: vm.isComplete) { complete in
                if complete {
                    print("session completed")
                    navigateToEnd = true
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
}

struct WorkSessionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSessionView(
            vm: WorkSessionViewModel(taskName: "Homework", durationMinutes: 3)
        )
    }
}
