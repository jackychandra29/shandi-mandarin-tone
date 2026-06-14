//
//  WaveFormView.swift
//  GeoTest
//
//  Created by Dody Adi Sancoko on 10/06/26.
//

import SwiftUI

struct WaveformView: View {
    var segments: [[CGFloat]]
    var userSegments: [[CGFloat]]? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GeometryReader { geo in
                let leftPadding: CGFloat = 24
                let chartWidth = geo.size.width - leftPadding
                let labels = ["5", "4", "3", "2", "1"]
                let maxValue: CGFloat = 5
                let minValue: CGFloat = 1

                ZStack(alignment: .topLeading) {
                    // Gridlines
                    ForEach(0..<5) { index in
                        let y = CGFloat(index) * geo.size.height / 4

                        Text(labels[index])
                            .font(.system(size: 8))
                            .foregroundStyle(Color.text)
                            .position(x: 6, y: y)

                        Rectangle()
                            .fill(Color.gridline)
                            .frame(width: chartWidth, height: 1)
                            .position(x: leftPadding + chartWidth / 2, y: y)
                    }

                    // Segment Divider
                    let totalSegments = segments.count
                    let gap: CGFloat = totalSegments > 1 ? 16 : 0 // Jeda 16pt antar kata jika ada > 1 nada
                    let totalGapWidth = CGFloat(totalSegments - 1) * gap
                    let segmentWidth = (chartWidth - totalGapWidth) / CGFloat(totalSegments)

                    ForEach(0..<totalSegments, id: \.self) { s in
                        let segmentLeft = leftPadding + CGFloat(s) * (segmentWidth + gap)
                        
                        waveformPath(
                            values: segments[s],
                            segmentLeftPadding: segmentLeft,
                            segmentWidth: segmentWidth,
                            height: geo.size.height,
                            minValue: minValue,
                            maxValue: maxValue
                        )
                        .stroke(
                            Color.text.opacity(0.5),
                            style: StrokeStyle(
                                lineWidth: 3,
                                lineCap: .round,
                                dash: [10, 10]
                            )
                        )
                    }
                    
                    // 3. GAMBAR GRAFIK USER (REKAMANNYA) JIKA ADA
                    if let userSegments = userSegments {
                        ForEach(0..<min(userSegments.count, totalSegments), id: \.self) { s in
                            let segmentLeft = leftPadding + CGFloat(s) * (segmentWidth + gap)
                            
                            waveformPath(
                                values: userSegments[s],
                                segmentLeftPadding: segmentLeft,
                                segmentWidth: segmentWidth,
                                height: geo.size.height,
                                minValue: minValue,
                                maxValue: maxValue
                            )
                            .stroke(Color.orangeBrand, lineWidth: 4)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(Color.pitchTrack)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .frame(height: 158)
    }

    // Smooth Curve
    private func waveformPath(
        values: [CGFloat],
        segmentLeftPadding: CGFloat,
        segmentWidth: CGFloat,
        height: CGFloat,
        minValue: CGFloat,
        maxValue: CGFloat
    ) -> Path {
        Path { path in
            guard !values.isEmpty else { return }
            guard values.count > 1 else { return }

            var points: [CGPoint] = []
            let denominator = CGFloat(max(1, values.count - 1))
            
            for index in 0..<values.count {
                let value = min(max(values[index], minValue), maxValue)
                let x = segmentLeftPadding + CGFloat(index) * segmentWidth / denominator
                let normalized = (maxValue - value) / (maxValue - minValue)
                let y = normalized * height
                points.append(CGPoint(x: x, y: y))
            }

            path.move(to: points[0])

            // If only 1 point, draw a dot (a very short line)
            if points.count == 1 {
                path.addLine(to: CGPoint(x: points[0].x + 1, y: points[0].y))
                return
            }

            // Jika cuma 2 titik (Nada 1, 2, 4) -> Garis lurus tegas
            if points.count == 2 {
                path.addLine(to: points[1])
                return
            }

            // Jika >= 3 titik (Nada 3) -> Interpolasi kurva mengalir melengkung
            let tension: CGFloat = 0.25
            for index in 0..<points.count - 1 {
                let p0 = points[max(index - 1, 0)]
                let p1 = points[index]
                let p2 = points[index + 1]
                let p3 = points[min(index + 2, points.count - 1)]
                
                let cp1 = CGPoint(
                    x: p1.x + (p2.x - p0.x) * tension,
                    y: p1.y + (p2.y - p0.y) * tension
                )
                let cp2 = CGPoint(
                    x: p2.x - (p3.x - p1.x) * tension,
                    y: p2.y - (p3.y - p1.y) * tension
                )
                
                path.addCurve(to: p2, control1: cp1, control2: cp2)
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    VStack(spacing: 20) {
        Text("Contoh Single Tone (Nada 3)")
        WaveformView(segments: [[2, 1, 4]]) // Bungkus dengan 1 pasang kurung siku luar tambahan
            .frame(height: 150)
        
        Text("Contoh Tone Pair (Nada 2 + Nada 3)")
        WaveformView(segments: [[3, 5], [2, 1, 4]]) // Melempar 2 segmen terpisah secara explisit!
            .frame(height: 150)
    }
    .padding()
}
