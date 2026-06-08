import SwiftUI

struct WaveformView: View {
    var values: [CGFloat] = [1, 4, 1]
    var comparisonValues: [CGFloat]? = nil
    var title = "Jejak nada"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(Color.text)
                .fontDesign(.rounded)

            GeometryReader { geo in
                let leftPadding: CGFloat = 24
                let chartWidth = geo.size.width - leftPadding
                let labels = ["5", "4", "3", "2", "1"]
                let maxValue: CGFloat = 5
                let minValue: CGFloat = 1

                ZStack(alignment: .topLeading) {
                    ForEach(0..<5) { index in
                        let y = CGFloat(index) * geo.size.height / 4

                        Text(labels[index])
                            .font(.system(size: 8))
                            .foregroundStyle(Color.text)
                            .position(x: 6, y: y)

                        Rectangle()
                            .fill(Color.gridline)
                            .frame(width: chartWidth, height: 1)
                            .position(
                                x: leftPadding + chartWidth / 2,
                                y: y
                            )
                    }

                    waveformPath(
                        values: values,
                        leftPadding: leftPadding,
                        chartWidth: chartWidth,
                        height: geo.size.height,
                        minValue: minValue,
                        maxValue: maxValue
                    )
                    .stroke(
                        Color.guidance,
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round,
                            lineJoin: .round,
                            dash: [8, 7]
                        )
                    )

                    if let comparisonValues {
                        waveformPath(
                            values: comparisonValues,
                            leftPadding: leftPadding,
                            chartWidth: chartWidth,
                            height: geo.size.height,
                            minValue: minValue,
                            maxValue: maxValue
                        )
                        .stroke(
                            Color.userPitchLine,
                            style: StrokeStyle(
                                lineWidth: 3,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                    }
                }
            }
            .frame(height: 76)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(Color.pitchtrack)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func waveformPath(
        values: [CGFloat],
        leftPadding: CGFloat,
        chartWidth: CGFloat,
        height: CGFloat,
        minValue: CGFloat,
        maxValue: CGFloat
    ) -> Path {
        Path { path in
            guard values.count > 1 else { return }

            func point(for index: Int) -> CGPoint {
                let value = min(max(values[index], minValue), maxValue)
                let x = leftPadding + CGFloat(index) * chartWidth / CGFloat(values.count - 1)
                let normalized = (maxValue - value) / (maxValue - minValue)
                let y = normalized * height

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

                path.addQuadCurve(to: midPoint, control: previousPoint)
                path.addQuadCurve(to: currentPoint, control: currentPoint)
            }
        }
    }
}

#Preview {
    WaveformView(values: [1, 4, 1])
        .padding()
}
