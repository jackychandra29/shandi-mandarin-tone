import SwiftUI

enum SpotlightTarget: Hashable {
    case speaker
    case mic
    case waveform
    case replay
}

struct SpotlightAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: [SpotlightTarget: Anchor<CGRect>] = [:]

    static func reduce(
        value: inout [SpotlightTarget: Anchor<CGRect>],
        nextValue: () -> [SpotlightTarget: Anchor<CGRect>]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}

extension View {
    func spotlightAnchor(_ target: SpotlightTarget) -> some View {
        anchorPreference(key: SpotlightAnchorPreferenceKey.self, value: .bounds) { anchor in
            [target: anchor]
        }
    }
}

struct SpotlightOverlay: View {
    let coachmark: CoachmarkContent
    let anchors: [SpotlightTarget: Anchor<CGRect>]
    let onNext: () -> Void

    var body: some View {
        GeometryReader { proxy in
            if let anchor = anchors[coachmark.target] {
                spotlightLayer(
                    rect: proxy[anchor].insetBy(dx: -12, dy: -12),
                    size: proxy.size
                )
            } else {
                fallbackLayer(size: proxy.size)
            }
        }
    }

    private func spotlightLayer(rect: CGRect, size: CGSize) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.58))
                .overlay {
                    RoundedRectangle(
                        cornerRadius: cornerRadius(for: coachmark.target),
                        style: .continuous
                    )
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
                    .blendMode(.destinationOut)
                }
                .compositingGroup()
                .onTapGesture(perform: onNext)

            OnboardingCoachmark(
                title: coachmark.title,
                message: coachmark.message,
                onNext: onNext
            )
            .frame(width: min(size.width * 0.72, 340))
            .position(coachmarkPosition(for: rect, in: size))
        }
    }

    private func fallbackLayer(size: CGSize) -> some View {
        ZStack {
            Color.black.opacity(0.58)
                .onTapGesture(perform: onNext)

            OnboardingCoachmark(
                title: coachmark.title,
                message: coachmark.message,
                onNext: onNext
            )
            .frame(width: min(size.width * 0.72, 340))
            .position(x: size.width / 2, y: size.height / 2)
        }
    }

    private func cornerRadius(for target: SpotlightTarget) -> CGFloat {
        switch target {
        case .speaker, .mic, .replay:
            44
        case .waveform:
            Sizing.roundedMedium
        }
    }

    private func coachmarkPosition(for rect: CGRect, in size: CGSize) -> CGPoint {
        let x = size.width / 2
        let rawY: CGFloat

        switch coachmark.target {
        case .speaker:
            rawY = rect.maxY + 78
        case .mic:
            rawY = rect.minY - 96
        case .waveform:
            rawY = rect.minY - 88
        case .replay:
            rawY = rect.minY - 112
        }

        let y: CGFloat
        if rawY < rect.midY {
            y = max(rawY, 120)
        } else {
            y = min(rawY, size.height - 120)
        }

        return CGPoint(x: x, y: y)
    }
}
