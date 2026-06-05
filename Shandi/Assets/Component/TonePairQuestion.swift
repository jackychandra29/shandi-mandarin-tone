//
//  TonePairQuestion.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

import SwiftUI

struct TonePairQuestion: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Tone 3 + Tone 3 ")
                .font(.system(size: 14))
                .foregroundStyle(.black.opacity(0.65))
                .fontDesign(.rounded)
                .fontWeight(.bold)
            
            Rectangle()
                .fill(.black.opacity(0.5))
                .frame(width: .infinity, height: 2)
            
            Text("What does it sound like in speech?")
                .fontDesign(.rounded)
                .font(.system(size: 14))
                .fontWeight(.regular)
           
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(height: 105)
        .background(Color(red: 0.94, green: 0.94, blue: 0.97))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        
        
    }
}

#Preview {
    TonePairQuestion()
//    .padding()
}
