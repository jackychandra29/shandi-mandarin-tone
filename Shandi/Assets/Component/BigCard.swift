import SwiftUI

struct BigCard<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.pitchtrack)
        )
        .padding(28)
    }
}

#Preview {
    BigCard {
        Text("Holla Mandarin")
    }
}
