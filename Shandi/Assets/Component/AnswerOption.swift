//
//  AnswerOption.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

import SwiftUI


struct AnswerOption: View {
    let title: String
    var isSelected = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14))
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .buttonStyle(AnswerOptionButtonStyle(isSelected: isSelected))
    }
}

private struct AnswerOptionButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(
                configuration.isPressed || isSelected
                ? Color.screen
                : Color.text
            )
            .background(
                configuration.isPressed || isSelected
                ? Color.yellowBrand
                : Color.screen
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    AnswerOption(title: "Nada 2 + Nada 3", isSelected: true) {}
        .padding(.horizontal, 20)
}
