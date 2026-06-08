//
//  Onboarding1.swift
//  Shandi
//
//  Created by Jacky Chandra on 08/06/26.
//

import Foundation
import SwiftUI

struct Onboarding1: View {
    @State private var userName = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Spacer()
            Spacer()
            
            Text("Belajar Bahasa Mandarin Mulai dari Nadanya").font(
                Styles.largeTitleShandi
            )
            Text("Dengarkan, ucapkan ulang, lalu cek nadamu").font(
                Styles.bodyShandi
            )
            Image("pitchTrack").resizable().scaledToFit()

            Spacer()
            
            Text("Hai siapa nama kamu?").font(Styles.bodyShandi)
            TextField("Tulis nama kamu", text: $userName)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)

            Button(action: {
                print("Button tapped!")
            }) {
                Text("Mulai")
                    .font(.headline)
                    .foregroundColor(.white)  // White text color
                    .padding()  // Adds space around the text
                    .frame(maxWidth: .infinity)  // Optional: Makes button full width
                    .background(Color.redBrand)  // Red background
                    .cornerRadius(50)  // Rounds the corners
            }.padding(.vertical, 20)

        }.padding(.horizontal, 30)
            .foregroundStyle(Color.text)
            .background(Color.screen)
    }
}

#Preview {
    Onboarding1()
}
