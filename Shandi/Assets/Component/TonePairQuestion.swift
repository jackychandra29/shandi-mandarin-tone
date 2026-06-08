//
//  TonePairQuestion.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

import SwiftUI

struct TonePairQuestion: View {
    let tonePair: String
    let question: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(tonePair)
                .font(.system(size: 14))
                .foregroundStyle(Color.text)
                .fontDesign(.rounded)
                .fontWeight(.bold)
            
            Rectangle()
                .fill(Color.text.opacity(0.7))
                .frame(maxWidth: .infinity)
                .frame(height: 2)
            
            Text(question)
                .fontDesign(.rounded)
                .font(.system(size: 14))
                .fontWeight(.regular)
                .foregroundStyle(Color.text)
           
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(minHeight: 105)
        .background(Color.screen)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    TonePairQuestion(
        tonePair: "Nada 3 + Nada 3",
        question: "nadanya berubah jadi apa?"
    )
}
