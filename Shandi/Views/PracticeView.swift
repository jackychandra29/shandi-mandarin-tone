import SwiftUI

struct PracticeView: View {
    var body: some View {
        BigCard {
            VStack {
                HStack {
                    Spacer()
                    Button {} label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundStyle(Color.text)
                    }

                }
                Spacer()
                WordDisplay(pinyin: "bīng", hanzi: "冰", meaning: "Es")
                Spacer()
                //WaveformView(segments:: [4, 1, 4])
                Spacer()
                Spacer()
                Spacer()
                ButtonRecord()
            }
            .padding(24)
        }
    }
}

#Preview {
    PracticeView()
}
