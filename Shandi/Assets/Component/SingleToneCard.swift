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
        VStack(spacing: 0) {
            // 1. ICON SPEAKER
            if showSpeaker {
                HStack {
                    Spacer()
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color.text)
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
                
                Spacer(minLength: 4)
            } else {
                Spacer(minLength: 24)
            }
            
            // 2. JUDUL
            Text(title)
                .font(Styles.title3Shandi)
                .foregroundColor(Color.text)
            
            Spacer(minLength: 2)
            
            // 3. PINYIN
            Text(pinyin)
                .font(Styles.largeTitleShandi)
                .foregroundColor(Color.redBrand)
                .padding(.bottom, 2)
            
            //(minLength: 2)
            
            // 4. DESKRIPSI
            Text(description)
                .font(Styles.subheadlineShandi)
                .foregroundColor(.black.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
                .minimumScaleFactor(0.8)
            
            Spacer(minLength: 16)
            
            // 5. BOTTOM CONTENT
            bottomContent
                .padding(.bottom, showSpeaker ? 20 : 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .aspectRatio(ratio, contentMode: .fit)
    }
}

