import SwiftData
import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserProfile.updatedAt, order: .reverse) private var userProfiles: [UserProfile]

    private var existingName: String? {
        userProfiles.first?.name.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
    }

    var body: some View {
        if hasCompletedOnboarding {
            ContentView()
        } else {
            OnboardingView(existingName: existingName) { name in
                completeOnboarding(name: name)
            }
        }
    }

    private func completeOnboarding(name: String) {
        if existingName == nil {
            let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            modelContext.insert(UserProfile(name: trimmedName.isEmpty ? "User" : trimmedName))
            try? modelContext.save()
        }
        hasCompletedOnboarding = true
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}

#Preview {
    RootView()
        .modelContainer(for: [PracticeAnswer.self, UserProfile.self], inMemory: true)
}
