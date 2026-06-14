import SwiftUI

struct BigCard<Content: View>: View {
    private let content: Content
    @Environment(\.modelContext) private var modelContext


    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
    }
}

#Preview {
    BigCard {
        Text("Holla Mandarin")
    }
}


#Preview("Answer Feedback") {
    NavigationStack {
        TonePairView(previewStep: .answerFeedback)
    }
}
