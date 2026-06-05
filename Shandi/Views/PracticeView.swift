//
//  PracticeView.swift
//  Shandi
//
//  Created by Garry Agassi on 02/06/26.
//

import SwiftUI

struct PracticeView: View {
    var body: some View {
        BigCard{
            VStack(){
                HStack(){
                    Spacer()
                    Button{} label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundStyle(.black)
                    }

                }
                Spacer()
                VStack(alignment: .center, spacing: 4){
                    Text("bīng")
                        .font(Font.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                    Text("冰")
                        .font(Font.system(size: 60, design: .rounded))
                        .fontWeight(.semibold)
                    Text("Ice")
                        .font(Font.system(.subheadline, design: .rounded))
                    
                }
                Spacer()
                WaveformView(values: [4,1,4], )
                Spacer()
                Spacer()
                Spacer()
                ButtonRecord()
            }
            .padding(24)
        }
    }
}

#Preview {
    PracticeView()
}
