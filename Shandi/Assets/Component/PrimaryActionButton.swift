import SwiftUI

struct PrimaryActionButton: View {
    let title: String
    var verticalPadding: CGFloat = 16
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Styles.headlineShandi)
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, verticalPadding)
                .background(Color.yellowBrand)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.yellowShadow, radius: 0, x: 0, y: 4)
        }
    }
}

#Preview {
    PrimaryActionButton(title: "Selanjutnya") {}
        .padding()
}
