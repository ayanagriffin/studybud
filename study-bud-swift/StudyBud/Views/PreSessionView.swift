import SwiftUI

struct PreSessionView: View {
    @StateObject private var vm = PreSessionViewModel()

    var body: some View {
        ZStack {
            // ── 1) Full‑screen bedroom background ──
            Image("bedroom")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // ── 2) Top area: Back arrow + “Session Setup” title ──
            VStack(spacing: 0) {
                HStack {
                    BackArrow {
                        // Pop or dismiss logic here if using NavigationStack
                    }
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 8)

                Text("Session Setup")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.top, 4)

                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)

            // ── 3) Speech bubble, positioned under the title ──
            VStack {
                Spacer().frame(height: 80) // Adjust to move bubble up/down
                SpeechBubble(text: vm.promptText)
                    .padding(.horizontal, 32)
                Spacer()
            }

            // ── 4) Avatar (larger, shifted right and down) ──
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("blueAtDesk")
                      .resizable()
                      .scaledToFit()
                      .frame(maxHeight: 300)
                      .padding(.horizontal)
                    Spacer()
// Make it large
//                        .offset(x: 20, y: 60)           // Nudge right (+20) & down (+60)
                }
            }
            

            // ── 5) Bottom area: Task / Duration / Confirm UI ──
            VStack {
                Spacer() // Push controls down

                switch vm.step {
                case .chooseTask:
                    // In chooseTask: show three yellow‐outlined controls stacked vertically
                    VStack(spacing: 16) {
                        // A) Two side‐by‐side “Homework” / “Chores” buttons
                        HStack(spacing: 16) {
                            Button(action: {
                                vm.selectTask(vm.taskOptions[0])
                            }) {
                                Text(vm.taskOptions[0])
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                            .buttonStyle(YellowOutlinedButtonStyle())

                            Button(action: {
                                vm.selectTask(vm.taskOptions[1])
                            }) {
                                Text(vm.taskOptions[1])
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                            .buttonStyle(YellowOutlinedButtonStyle())
                        }
                        .padding(.horizontal, 24)

                        // B) “Say something else…” text field + pencil icon, in the same styled outline
                        HStack(spacing: 12) {
                            Image(systemName: "pencil")
                                .foregroundColor(.gray)
                            TextField("Say something else…", text: $vm.taskName)
                                .autocapitalization(.sentences)
                                .disableAutocorrection(false)
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.white.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("AccentYellow"), lineWidth: 3)
                        )
                        .cornerRadius(20)
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24) // space from bottom edge

                case .chooseDuration:
                    // In chooseDuration: two gold‐filled buttons (“30 Minutes” / “45 Minutes”)
                    HStack(spacing: 16) {
                        Button(action: { vm.selectDuration(30) }) {
                            Text("30 Minutes")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(YellowFilledButtonStyle())

                        Button(action: { vm.selectDuration(45) }) {
                            Text("45 Minutes")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(YellowFilledButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                case .confirm:
                    // In confirm: single gold “Start X‑Minute Session” button
                    if vm.isLoadingRecap {
                        ProgressView("Generating…")
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(20)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                    } else {
                        Button(action: {
                            vm.confirmAndStart()
                        }) {
                            Text("Start \(vm.duration!)-Minute Session")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(YellowFilledButtonStyle())
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    }
                }

                Spacer().frame(height: 0) // Just to satisfy the VStack bottom
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .navigationDestination(isPresented: $vm.isSessionActive) {
                WorkSessionView(vm: vm.workVM!)
            }
        }
        .onAppear {
            // Make nav bar transparent so background bleeds through
            UINavigationBar.appearance().barTintColor = .clear
        }
    }
}

struct PreSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PreSessionView()
    }
}

