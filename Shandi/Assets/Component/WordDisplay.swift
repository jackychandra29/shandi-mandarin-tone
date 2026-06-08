//
//  WordDisplay.swift
//  Shandi
//
//  Created by Garry Agassi on 07/06/26.
//

import SwiftUI

struct WordDisplay: View {
    let pinyin: String
    let hanzi: String
    let meaning: String

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(pinyin)
                .font(Font.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(Color.orangeBrand)

            Text(hanzi)
                .font(Font.system(size: 60, design: .rounded))
                .fontWeight(.semibold)
                .foregroundStyle(Color.text)

            Text(meaning)
                .font(Font.system(.subheadline, design: .rounded))
                .foregroundStyle(Color.text)
        }
    }
}

#Preview {
    WordDisplay(pinyin: "nǐ hǎo", hanzi: "你好", meaning: "Halo")
}
