import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userName") private var userName = "User"

    var body: some View {
        if hasCompletedOnboarding {
            ContentView()
        } else {
            OnboardingView { name in
                completeOnboarding(name: name)
            }
        }
    }

    private func completeOnboarding(name: String) {
        userName = name
        hasCompletedOnboarding = true
    }
}

#Preview {
    RootView()
}
