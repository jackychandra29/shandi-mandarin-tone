import SwiftUI

struct BigCard<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .padding(28)
    }
}

#Preview {
    BigCard {
        Text("Holla Mandarin")
    }
}
