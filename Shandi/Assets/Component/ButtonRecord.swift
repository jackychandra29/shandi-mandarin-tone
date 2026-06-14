//
//  ButtonRecord.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

import SwiftUI

struct ButtonRecord: View {
    var action: (() -> Void)?

    @State private var micPermission = MicrophonePermissionManager()

    var body: some View {
        Button {
            micPermission.requestPermission {
                action?()
            }
        } label: {
            ZStack {
                Circle()
                    .fill(Color.yellowShadow)
                    .offset(y: 4)

                Image(systemName: "mic.fill")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 34, weight: .bold))
                    .frame(width: 72, height: 72)
                    .background(Color.yellowBrand)
                    .clipShape(Circle())
            }
            .frame(width: 72, height: 78)
        }
        .buttonStyle(.plain)
        .alert("Akses Mikrofon Diperlukan", isPresented: $micPermission.showDeniedAlert) {
            Button("Buka Pengaturan") {
                micPermission.openSettings()
            }

            Button("Batal", role: .cancel) {}
        } message: {
            Text("Shandi membutuhkan akses mikrofon untuk merekam suaramu. Izinkan di Pengaturan > Shandi.")
        }
    }
}

#Preview {
    ButtonRecord {
        print("record")
    }
}
