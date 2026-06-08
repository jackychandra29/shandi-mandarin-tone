import SwiftUI

struct OnboardingCoachmark: View {
    let title: String
    let message: String
    let onNext: () -> Void

    var body: some View {
        Button(action: onNext) {
            HStack(alignment: .bottom, spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(Styles.headlineShandi)
                        .foregroundStyle(Color.text)

                    Text(message)
                        .font(Styles.subheadlineShandi)
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.text)
            }
            .padding(20)
            .background(Color.screen)
            .clipShape(RoundedRectangle(cornerRadius: Sizing.roundedMedium, style: .continuous))
            .shadow(color: Color.text.opacity(0.16), radius: 18, y: 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingCoachmark(
        title: "Latih telingamu dulu!",
        message: "Dengar nadanya, pahami naik-turunnya, lalu coba ucapkan ulang",
        onNext: {}
    )
    .padding()
    .background(Color.screen)
}
