import SwiftData
import SwiftUI

struct SessionSummaryView: View {
    @Query(sort: \UserProfile.updatedAt, order: .reverse) private var userProfiles: [UserProfile]

    private var userName: String {
        let name = userProfiles.first?.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return name.isEmpty ? "User" : name
    }

    let wordCount: Int
    let tonePinyin: String
    let toneLabel: String
    let onHomeTapped: () -> Void 
    
    var body: some View {
        VStack(spacing: 4) {
            Spacer()

            VStack(spacing: 4) {
                Text("Hebat \(userName),\nsesi selesai!")
                    .font(Styles.largeTitleShandi)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.redBrand)
            }

            // Ilustrasi Maskot Naga
            Image("dragonend")
                .resizable()
                .scaledToFit()
                .frame(height: 300)

            // Card Ringkasan
            VStack(alignment: .leading, spacing: 16) {
                Text("Ringkasan Sesi")
                    .font(Styles.headlineShandi)
                    .foregroundStyle(Color.text)

                HStack(spacing: 12) {
                    // Menggunakan parameter wordCount, tonePinyin, dan toneLabel
                    summaryStat(value: "\(wordCount)", label: "KATA")
                    summaryStat(value: tonePinyin, label: toneLabel)
                }

                // Teks dinamis sesuai jumlah kata
                Text("\(wordCount) kata selesai. Sedikit demi sedikit, nadamu makin stabil")
                    .font(Styles.headlineShandi)
                    .foregroundStyle(Color.text)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .padding(18)
            .background(Color.yellowBrand)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .padding(.horizontal, 30)

            Spacer()
            // Tombol Beranda Modular
            Button(action: onHomeTapped) {
                Text("Beranda")
                    .font(Styles.headlineShandi)
                    .foregroundStyle(Color.screen)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.redBrand)
                    .clipShape(Capsule())
            }

            Spacer()
        }
        .background(Color.screen.ignoresSafeArea())
        .toolbarVisibility(.hidden, for: .tabBar) 
    }
    
    // Angka & Pinyin
    private func summaryStat(value: String, label: String) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(Styles.largeTitleShandi)
                .foregroundStyle(Color.redBrand)
            Text(label)
                .font(Styles.headlineShandi)
                .foregroundStyle(Color.text)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    SessionSummaryView(wordCount: 10, tonePinyin: "mā", toneLabel: "NADA 1") {}
        .modelContainer(for: [PracticeAnswer.self, UserProfile.self], inMemory: true)
}
