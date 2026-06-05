//
//  WaveformView.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

//
//  WaveformView.swift
//  Shandi
//
//  Created by Garry Agassi on 03/06/26.
//

import SwiftUI

struct WaveformView: View {
    var values: [CGFloat] = [1,4,1];
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pitch track")
                .font(.system(size: 12))
                .foregroundStyle(.black.opacity(0.65))
                .fontDesign(.rounded)
            
            GeometryReader { geo in
                let leftPadding: CGFloat = 24
                let chartWidth = geo.size.width - leftPadding
                let labels = ["05", "04", "03", "02", "01"]
                let maxValue: CGFloat = 5
                let minValue: CGFloat = 1
                
                ZStack(alignment: .topLeading) {
                    
                    // Grid lines + labels
                    ForEach(0..<5) { index in
                        let y = CGFloat(index) * geo.size.height / 4
                        
                        Text(labels[index])
                            .font(.system(size: 8))
                            .foregroundStyle(.gray)
                            .position(x: 6, y: y)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.22))
                            .frame(width: chartWidth, height: 1)
                            .position(
                                x: leftPadding + chartWidth / 2,
                                y: y
                            )
                    }
                    
                    Path { path in
                        guard values.count > 1 else { return }
                        
                        func point(for index: Int) -> CGPoint {
                            let value = min(max(values[index], minValue), maxValue)
                            
                            let x = leftPadding + CGFloat(index) * chartWidth / CGFloat(values.count - 1)
                            
                            // value 5 = top, value 1 = bottom
                            let normalized = (maxValue - value) / (maxValue - minValue)
                            let y = normalized * geo.size.height
                            
                            return CGPoint(x: x, y: y)
                        }
                        
                        path.move(to: point(for: 0))
                        
                        for index in 1..<values.count {
                            let previousPoint = point(for: index - 1)
                            let currentPoint = point(for: index)
                            
                            let midPoint = CGPoint(
                                x: (previousPoint.x + currentPoint.x) / 2,
                                y: (previousPoint.y + currentPoint.y) / 2
                            )
                            
                            path.addQuadCurve(
                                to: midPoint,
                                control: previousPoint
                            )
                            
                            path.addQuadCurve(
                                to: currentPoint,
                                control: currentPoint
                            )
                        }
                    }
                    .stroke(
                        Color.gray.opacity(0.85),
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round,
                            lineJoin: .round,
                            dash: [8, 7]
                        )
                    )
                }
            }
            .frame(height: 76)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(Color(red: 0.94, green: 0.94, blue: 0.97))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    WaveformView(
        values: [1,4,1]
    )
    .padding()
}
