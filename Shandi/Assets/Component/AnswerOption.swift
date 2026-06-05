//
//  AnswerOption.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

import SwiftUI


struct AnswerOption: View {
    
    var body: some View {
        Button {
            print("Tapped")
        } label: {
            Text("Tone 2 + Tone 3")
                .font(.system(size: 14))
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .buttonStyle(AnswerOptionButtonStyle())
    }
}

struct AnswerOptionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(
                configuration.isPressed
                ? Color.white
                : Color.black.opacity(0.65)
            )
            .background(
                configuration.isPressed
                ? Color(red: 142 / 255, green: 142 / 255, blue: 147 / 255)
                : Color(red: 0.94, green: 0.94, blue: 0.97)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    AnswerOption()
        .padding(.horizontal, 20)
}
