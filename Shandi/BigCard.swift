//
//  BigCard.swift
//  Shandi
//
//  Created by Garry Agassi on 02/06/26.
//

import SwiftUI

struct BigCard <Content: View> : View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .frame(width: 335, height: 586)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(.black, lineWidth: 1)
//        )
        .padding(28)
    }
}

#Preview {
    BigCard{
        Text("Holla Mandarin")
    }
}
