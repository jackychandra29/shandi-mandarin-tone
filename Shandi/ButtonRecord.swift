//
//  ButtonRecord.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

import SwiftUI

struct ButtonRecord: View {
    var body: some View {
        Button{} label: {
            Image(systemName: "mic.circle.fill")
                .foregroundStyle(.black)
                .font(.system(size: 60))
        }
 
    }
}

#Preview {
    ButtonRecord()
}
