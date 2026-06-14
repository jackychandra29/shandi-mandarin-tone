import SwiftUI

struct SpeakerButton: View {
    let action: () -> Void

    var body: some View {
        ZStack {
//            Circle()
//                .fill(Color.yellowShadow)
//                .offset(y: 4)

            Button(action: action) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.yellowBrand)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .shadow(
                color: Color.yellowShadow,
                radius: 0,
                x: 0,
                y: 4
            )
        }
        .frame(width: 40, height: 40)
    }
}
#Preview {
    SpeakerButton {
        print("Play audio")
    }
}
