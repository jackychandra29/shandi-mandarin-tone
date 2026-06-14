import SwiftUI

struct AnswerOption: View {
    let title: String
    var isSelected = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 16, design: .rounded))
                    .fontWeight(.regular)

                Spacer()

                Circle()
                    .stroke(isSelected ? Color.clear : Color.text, lineWidth: 1.2)
                    .frame(width: 18, height: 18)
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
        }
        .buttonStyle(AnswerOptionButtonStyle(isSelected: isSelected))
    }
}

private struct AnswerOptionButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(
                configuration.isPressed || isSelected
                ? Color.white
                : Color.text
            )
            .frame(maxWidth: .infinity)
            .background(
                configuration.isPressed || isSelected
                ? Color.orangeBrand
                : Color.screen
            )
            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}

#Preview {
    VStack(spacing: 22) {
        AnswerOption(title: "Nada 3 + Nada 3") {}
        AnswerOption(title: "Nada 2 + Nada 3", isSelected: true) {}
    }
    .padding(.horizontal, 20)
}
