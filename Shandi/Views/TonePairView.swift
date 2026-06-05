//
//  TonePairView.swift
//  Shandi
//
//  Created by Garry Agassi on 02/06/26.
//

import SwiftUI

struct TonePairView: View {
    var body: some View {
        VStack{
            ZStack {
                VStack {
                    Text("Third Tone Sandhi")
                        .fontWeight(.semibold)
                        .font(Font.system(.headline, design: .rounded))

                    Text("Word 1 of your session")
                        .font(Font.system(.caption, design: .rounded))
                        .foregroundStyle(.gray)
                }

                HStack {
                    Spacer()

                    Button{} label: {
                        Image(systemName: "x.circle.fill")
                            .font(.title)
                            .foregroundStyle(.black)
                        
                    }
                }
            }
            .padding(16)
            
            Divider()
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
                    VStack{
                        VStack(alignment: .center, spacing: 4){
                            Text("nǐ hǎo")
                                .font(Font.system(.largeTitle, design: .rounded))
                                .fontWeight(.bold)
                            Text("你好")
                                .font(Font.system(size: 60, design: .rounded))
                                .fontWeight(.semibold)
                            Text("Hello")
                                .font(Font.system(.subheadline, design: .rounded))
                            
                        }
                        Spacer()
                        TonePairQuestion()
                        Spacer()
                        AnswerOption()
                        AnswerOption()
                        AnswerOption()
                        AnswerOption()
                        Spacer()
                        
                    }
                }
                .padding(24)
            }
//            .background(.red)
        }
    }
}

#Preview {
    TonePairView()
}
