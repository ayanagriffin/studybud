import SwiftUI

// MARK: - CUSTOM COLORS (hex values sampled from your mockups)
extension Color {
    // Off‑white page background (#F9F8F5)
    static let onboardBackground = Color(red: 249/255, green: 248/255, blue: 245/255)
    
    // “Login” button blue (#5486CD)
    static let primaryBlue = Color(red: 84/255, green: 134/255, blue: 205/255)
    // “Create an account” lighter blue (#C0DAFF)
    static let secondaryBlue = Color(red: 192/255, green: 218/255, blue: 255/255)
    
    // Accent orange/peach for text field border (#FFD8CC) and "Maybe later" (#FDECEA)
    static let accentPeach = Color(red: 255/255, green: 216/255, blue: 204/255)
    static let peachBackground = Color(red: 253/255, green: 236/255, blue: 234/255)
    
    // Dark‑brown heading text (#3B2D2E)
    static let darkBrown = Color(red: 59/255, green: 45/255, blue: 46/255)
    // Mid‑gray subtext (#7B6F7D)
    static let midGray = Color(red: 123/255, green: 111/255, blue: 125/255)
    
    // For the little progress bar at top
    static let progressGreen = Color(red: 139/255, green: 195/255, blue: 74/255)
}

// MARK: - ONBOARDING PARENT VIEW
struct OnboardingView: View {
    // Which step are we on?
    /// 0 = welcome
    /// 1 = choose character
    /// 2 = celebrate character
    /// 3 = name StudyBud
    /// 4 = choose personality
    /// 5 = enter user's name
    /// 6 = enable notifications
    @State private var step: Int = 0
    
    // The user’s selections so far:
    @State private var selectedCharacter: String? = nil
    @State private var budName: String = ""
    @State private var chosenPersonalities: [String] = []
    @State private var userName: String = ""
    @State private var notificationsEnabled: Bool = false
    
    // When true, we immediately navigate to LandingView
    @State private var navigateToLanding: Bool = false
    
    // Available personalities to pick from
    private let personalities = [
        "Gentle", "Positive", "Sassy",
        "Focused", "Whimsical", "Logistical",
        "Data‑focused", "Other"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // ─── BACKGROUND ───
                Color.onboardBackground
                    .ignoresSafeArea()
                
                VStack {
                    // ─── PROGRESS BAR ───
                    ProgressView(value: Double(step), total: 6.0)
                        .accentColor(.progressGreen)
                        .tint(.progressGreen)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    Spacer()
                    
                    // ─── SWITCH ON “step” ───
                    switch step {
                    case 0:
                        WelcomeScreen(
                            onSkip: { withAnimation { step = 1 } }
                        )
                        
                    case 1:
                        CharacterSelectionScreen(
                            selectedCharacter: $selectedCharacter,
                            onNext: {
                                guard selectedCharacter != nil else { return }
                                withAnimation { step = 2 }
                            },
                            onBack: { withAnimation { step = 0 } }
                        )
                        
                    case 2:
                        CelebrateCharacterScreen(
                            selectedCharacter: selectedCharacter,
                            onNext: {
                                withAnimation { step = 3 }
                            }
                        )
                        
                    case 3:
                        NameYourBudScreen(
                            selectedCharacter: selectedCharacter,
                            budName: $budName,
                            onNext: {
                                guard !budName.isEmpty else { return }
                                withAnimation { step = 4 }
                            },
                            onBack: { withAnimation { step = 1 } }
                        )
                        
                    case 4:
                        PersonalityScreen(
                            selectedCharacter: selectedCharacter,
                            personalities: personalities,
                            chosenPersonalities: $chosenPersonalities,
                            onNext: {
                                guard !chosenPersonalities.isEmpty else { return }
                                withAnimation { step = 5 }
                            },
                            onBack: { withAnimation { step = 3 } }
                        )
                        
                    case 5:
                        UserNameScreen(
                            budName: budName,
                            userName: $userName,
                            onNext: {
                                guard !userName.isEmpty else { return }
                                withAnimation { step = 6 }
                            },
                            onBack: { withAnimation { step = 4 } }
                        )
                        
                    case 6:
                        NotificationScreen(
                            selectedCharacter: selectedCharacter,
                            onEnableNotifications: {
                                notificationsEnabled = true
                                navigateToLanding = true
                            },
                            onMaybeLater: {
                                notificationsEnabled = false
                                navigateToLanding = true
                            },
                            onBack: { withAnimation { step = 5 } }
                        )
                        
                    default:
                        EmptyView()
                    }
                    
                    Spacer()
                }
                
                // ─── NAVIGATE TO LANDING VIEW WHEN "navigateToLanding" TURNS TRUE ───
                NavigationLink(
                    destination: LandingView(),
                    isActive: $navigateToLanding
                ) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}


// MARK: - 1) WELCOME SCREEN (step 0)
private struct WelcomeScreen: View {
    var onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 8) {
                ChatBubbleView(text: "Hey there! We’ll be off to work in no time!", tailPosition: 0.5)
                
                Image("blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Text("StudyBud")
                    .font(.mainHeader)
                    .foregroundColor(.darkBrown)
                
                Text("Let’s get to work!")
                    .font(.normalText)
                    .foregroundColor(.midGray)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: {
                    // TODO: integrate real Login
                }) {
                    Text("Login")
                        .font(.buttonText)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.primaryBlue)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    // TODO: integrate real Create Account
                }) {
                    Text("Create an account")
                        .font(.buttonText)
                        .foregroundColor(.darkBrown)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.secondaryBlue)
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal, 24)
            
            Button(action: {
                onSkip()
            }) {
                Text("Skip for now")
                    .font(.normalText)
                    .underline()
                    .foregroundColor(.primaryBlue)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}


// MARK: - 2) CHARACTER SELECTION SCREEN (step 1)
private struct CharacterSelectionScreen: View {
    @Binding var selectedCharacter: String?
    var onNext: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // ─── Back arrow ───
            HStack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.mainHeader)
                        .foregroundColor(.darkBrown)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // ─── Title + Subtitle ───
            VStack(spacing: 8) {
                Text("Choose your StudyBud!")
                    .font(.dateHeader)
                    .foregroundColor(.darkBrown)
                
                Text("StudyBuds love companionship, to work, and are full of energy and life.")
                    .font(.normalText)
                    .foregroundColor(.midGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // ─── ZStack: position three bunnies ───
            ZStack {
                // Blue StudyBud (center‑top)
                selectableBunny(
                    imageName: "blue",
                    isSelected: selectedCharacter == "blue",
                    size: 120
                )
                .offset(y: -60)
                .onTapGesture {
                    selectedCharacter = "blue"
                }
                
                // Red/Pink StudyBud (bottom‑left)
                selectableBunny(
                    imageName: "pink",
                    isSelected: selectedCharacter == "pink",
                    size: 100
                )
                .offset(x: -75, y: 45)
                .onTapGesture {
                    selectedCharacter = "pink"
                }
                
                // Green StudyBud (bottom‑right)
                selectableBunny(
                    imageName: "green",
                    isSelected: selectedCharacter == "green",
                    size: 100
                )
                .offset(x: 75, y: 45)
                .onTapGesture {
                    selectedCharacter = "green"
                }
            }
            .frame(height: 200)
            
            Spacer()
            
            // ─── “Choose” Button pinned at the bottom ───
            Button {
                onNext()
            } label: {
                Text("Choose")
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        (selectedCharacter == nil) ? Color.gray.opacity(0.4) : Color.primaryBlue
                    )
                    .cornerRadius(25)
            }
            .disabled(selectedCharacter == nil)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .padding(.top, 24)
        .frame(maxHeight: .infinity)
    }
    
    // Helper view with translucent circle behind the selected StudyBud
    @ViewBuilder
    private func selectableBunny(imageName: String, isSelected: Bool, size: CGFloat) -> some View {
        ZStack {
            if isSelected {
                Circle()
                    .fill(Color.primaryBlue.opacity(0.25))
                    .frame(width: size + 24, height: size + 24)
            }
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}


// MARK: - 2a) CELEBRATE CHARACTER SCREEN (step 2)
private struct CelebrateCharacterScreen: View {
    var selectedCharacter: String?
    var onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Stars around the character
            ZStack {
                // top‑left star
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentPeach)
                    .offset(x: 20, y: 125)
                
                // top‑center star
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentPeach)
                    .offset(x: 0, y: 100)
                
                // bottom‑right star
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.accentPeach)
                    .offset(x: 50, y: 200)
            }
            
            ChatBubbleView(text: "Great choice if you ask me!", tailPosition: 0.5)
                .padding(.horizontal, 40)
            
            // Character GIF/image
            if let imgName = selectedCharacter {
                GIFImage(gifName: "BlueCelebrating")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 350)
                    .allowsHitTesting(false)
            }
            
            Spacer()
            
            Button {
                onNext()
            } label: {
                Text("Nice!")
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.primaryBlue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
        .frame(maxHeight: .infinity)
    }
}


// MARK: - 3) NAME YOUR STUDYBUD (step 3)
private struct NameYourBudScreen: View {
    var selectedCharacter: String?
    @Binding var budName: String
    var onNext: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Back arrow
            HStack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.darkBrown)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            Spacer()
            
            if let imgName = selectedCharacter {
                Image(imgName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            VStack(spacing: 8) {
                Text("What do you want to name your StudyBud?")
                    .font(.buttonText)
                    .foregroundColor(.darkBrown)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text("You can change this later.")
                    .font(.normalText)
                    .foregroundColor(.midGray)
            }
            
            TextField("Percy", text: $budName)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentPeach, lineWidth: 3)
                )
                .font(.normalText)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                onNext()
            } label: {
                Text("Next")
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        budName.isEmpty ? Color.gray.opacity(0.4) : Color.primaryBlue
                    )
                    .cornerRadius(25)
            }
            .disabled(budName.isEmpty)
            .padding(.horizontal, 24)
        }
        .frame(maxHeight: .infinity)
    }
}


// MARK: - 4) CHOOSE PERSONALITY (step 4)
private struct PersonalityScreen: View {
    var selectedCharacter: String?
    let personalities: [String]
    @Binding var chosenPersonalities: [String]
    var onNext: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            // 1) Back arrow
            HStack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.darkBrown)
                }
                Spacer()
            }
            .padding(.horizontal, 24)

            // 2) Character image (optional)
            if let imgName = selectedCharacter {
                Image(imgName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            }

            // 3) Title
            Text("Your encouragement personality is…")
                .font(.buttonText)
                .foregroundColor(.darkBrown)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // 4) Scrollable list of traits
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(personalities, id: \.self) { trait in
                        Button {
                            toggleTrait(trait)
                        } label: {
                            HStack {
                                Text(trait)
                                    .font(.normalText)
                                    .foregroundColor(.darkBrown)
                                
                                Spacer()
                                
                                if chosenPersonalities.contains(trait) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        chosenPersonalities.contains(trait)
                                            ? Color.primaryBlue
                                            : Color.accentPeach.opacity(0.7),
                                        lineWidth: 3
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }
            .frame(maxHeight: .infinity)

            // 5) “Next” button at the bottom
            Button {
                onNext()
            } label: {
                Text("Next")
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        chosenPersonalities.isEmpty
                            ? Color.gray.opacity(0.4)
                            : Color.primaryBlue
                    )
                    .cornerRadius(25)
            }
            .disabled(chosenPersonalities.isEmpty)
            .padding(.horizontal, 24)
        }
        .padding(.top, 24)
    }

    private func toggleTrait(_ trait: String) {
        if chosenPersonalities.contains(trait) {
            chosenPersonalities.removeAll { $0 == trait }
        } else {
            chosenPersonalities.append(trait)
        }
    }
}


// MARK: - 5) ENTER USER'S NAME (step 5)
private struct UserNameScreen: View {
    var budName: String
    @Binding var userName: String
    var onNext: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Back arrow
            HStack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.darkBrown)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(spacing: 8) {
                ChatBubbleView(text: "I love my name! Percy, Percy, Percy, I could say it forever and ever. What’s your name?", tailPosition: 0.5)
                    .padding(.horizontal, 32)
                
                    Image("blue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                
                
                Text("Glad you like your name \(budName)!")
                    .font(.buttonText)
                    .foregroundColor(.darkBrown)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text("My name is…")
                    .font(.normalText)
                    .foregroundColor(.midGray)
            }
            
            TextField("John", text: $userName)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentPeach, lineWidth: 3)
                )
                .font(.normalText)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                onNext()
            } label: {
                Text("Next")
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        userName.isEmpty ? Color.gray.opacity(0.4) : Color.primaryBlue
                    )
                    .cornerRadius(25)
            }
            .disabled(userName.isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .frame(maxHeight: .infinity)
    }
}


// MARK: - 6) ENABLE NOTIFICATIONS (step 6)
private struct NotificationScreen: View {
    var selectedCharacter: String?
    
    // Called if the user taps "Turn on notifications"
    var onEnableNotifications: () -> Void
    // Called if the user taps "Maybe later"
    var onMaybeLater: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Back arrow
            HStack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.darkBrown)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            
            ChatBubbleView(text: "Break is over! Let’s get to work!", tailPosition: 0.85)
            
            VStack(spacing: 8) {
                if let imgName = selectedCharacter {
                    Image(imgName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                
                Text("Percy wants to check in here and there!")
                    .font(.buttonText)
                    .foregroundColor(.darkBrown)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button {
                    onEnableNotifications()
                } label: {
                    Text("Turn on notifications")
                        .font(.buttonText)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.primaryBlue)
                        .cornerRadius(25)
                }
                
                Button {
                    onMaybeLater()
                } label: {
                    Text("Maybe later")
                        .font(.buttonText)
                        .foregroundColor(.darkBrown)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.peachBackground)
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

// MARK: - PREVIEW
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .previewDevice("iPhone 14 Pro")
    }
}
