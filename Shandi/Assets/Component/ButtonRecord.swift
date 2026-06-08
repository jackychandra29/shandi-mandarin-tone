//
//  ButtonRecord.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

import SwiftUI

struct ButtonRecord: View {
    var action: () -> Void = {}

    @State private var micPermission = MicrophonePermissionManager()

    var body: some View {
        Button {
            micPermission.requestPermission(onGranted: action)
        } label: {
            Image(systemName: "mic.circle.fill")
                .foregroundStyle(Color.redBrand)
                .font(.system(size: 60))
        }
        .alert("Akses Mikrofon Diperlukan", isPresented: $micPermission.showDeniedAlert) {
            Button("Buka Pengaturan") { micPermission.openSettings() }
            Button("Batal", role: .cancel) {}
        } message: {
            Text("Shandi membutuhkan akses mikrofon untuk merekam suaramu. Izinkan di Pengaturan > Shandi.")
        }
    }
}

#Preview {
    ButtonRecord()
}
