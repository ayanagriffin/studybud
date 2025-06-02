import SwiftUI

@main
struct StudyBudApp: App {
    var body: some Scene {
        WindowGroup {
            RootFontWrapper {
                OnboardingView()
            }
        }
    }
}
