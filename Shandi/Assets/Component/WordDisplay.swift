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
    var pinyinColor: Color = .orangeBrand

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(pinyin)
                .font(Styles.largeTitleShandi)
                .foregroundStyle(pinyinColor)

            Text(hanzi)
                .font(Font.system(size: 70, weight: .bold))
                .foregroundStyle(Color.text)

            Text(meaning)
                .font(Styles.bodyShandi)
                .foregroundStyle(Color.text)
        }
    }
}

#Preview {
    WordDisplay(pinyin: "nǐ hǎo", hanzi: "你好", meaning: "Halo", pinyinColor: .redBrand)
}
