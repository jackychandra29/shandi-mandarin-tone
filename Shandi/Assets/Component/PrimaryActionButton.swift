import SwiftUI

struct PrimaryActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Styles.headlineShandi)
                .foregroundStyle(Color.screen)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.redBrand)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
    }
}

#Preview {
    PrimaryActionButton(title: "Selanjutnya") {}
        .padding()
}
