//
//  TestSmallCard.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 02/06/26.
//

import SwiftUI

struct ToneLibraryView: View {
    
    let phonetics: [SmallModel] = [
        SmallModel(id: "b", letter: "b", desc: "Like \"b\" in book\nno air puff", example: "bā"),
        SmallModel(id: "p", letter: "p", desc: "like \"p\" in pan\nwith air puff", example: "pà"),
        SmallModel(id: "m", letter: "m", desc: "like \"m\"\nin moon", example: "māo"),
        SmallModel(id: "f", letter: "f", desc: "like \"f\"\nin fan", example: "fēi")
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                LazyVGrid(columns: columns, spacing: 16) {
                    
                    ForEach(phonetics) { item in
                        SmallCardView(
                            data: item,
                            onPlayMainAudio: {
                                print("Memutar suara utama untuk \(item.letter)")
                            },
                            onPlayExampleAudio: {
                                print("Memutar contoh suara untuk \(item.example)")
                            }
                        )
                    }
                    
                }
                .padding(.horizontal)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    ToneLibraryView()
}
