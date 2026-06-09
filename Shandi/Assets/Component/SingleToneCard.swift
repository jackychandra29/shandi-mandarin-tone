//
//  SingleToneCard.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 08/06/26.
//

import SwiftUI

struct SingleToneCard<BottomContent: View>: View {
    let title: String
    let pinyin: String
    let description: String
    let ratio: CGFloat
    var showSpeaker: Bool = false
    
    @ViewBuilder let bottomContent: BottomContent
    
    var body: some View {
        VStack(spacing: 8) {
            if showSpeaker {
                HStack {
                    Spacer()
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color.text)
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
            } else {
                Spacer(minLength: 0)
            }

            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color.orangeBrand)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .frame(maxWidth: .infinity, minHeight: 28, alignment: .center)

            Text(pinyin)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(Color.redBrand)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)

            Text(description)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.9)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, minHeight: 42, alignment: .top)

            Spacer(minLength: 0)

            bottomContent
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Sizing.roundedBig, style: .continuous))
        .aspectRatio(ratio, contentMode: .fit)
    }
}
