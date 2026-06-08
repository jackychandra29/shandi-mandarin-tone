//
//  ButtonRecord.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

import SwiftUI

struct ButtonRecord: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: "mic.circle.fill")
                .foregroundStyle(Color.redBrand)
                .font(.system(size: 60))
        }
    }
}

#Preview {
    ButtonRecord()
}
