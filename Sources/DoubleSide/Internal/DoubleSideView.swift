//
//  Created by Kurlovich Vitali on 5/16/26.
//

import CGMathKit
import SwiftUI

struct DoubleSideView<Front: View, Back: View>: View {
    @Environment(\.doubleSideStyle)
    var style

    @Environment(\.colorScheme)
    var colorScheme

    var angle: Angle

    let axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    let anchor: UnitPoint
    let anchorZ: CGFloat
    let perspective: CGFloat

    let front: (CGFloat) -> Front
    let back: (CGFloat) -> Back

    init(
        angle: Angle,
        axis: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 0, y: 1, z: 0),
        anchor: UnitPoint = .center,
        anchorZ: CGFloat = 0,
        perspective: CGFloat = 0.333,
        front: @escaping (CGFloat) -> Front,
        back: @escaping (CGFloat) -> Back
    ) {
        self.angle = angle
        self.axis = axis
        self.anchor = anchor
        self.anchorZ = anchorZ
        self.perspective = perspective
        self.front = front
        self.back = back
    }

    var body: some View {
        content(angle)
            .rotation3DEffect(
                angle,
                axis: axis,
                anchor: anchor,
                anchorZ: anchorZ,
                perspective: perspective
            ).brightness(brightnessValue)
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
extension DoubleSideView {
    init(
        angle: Angle,
        axis: (x: CGFloat, y: CGFloat, z: CGFloat),
        anchor: UnitPoint,
        anchorZ: CGFloat,
        perspective: CGFloat,
        front: @escaping () -> Front,
        back: @escaping () -> Back
    ) {
        self.init(
            angle: angle,
            axis: axis,
            anchor: anchor,
            anchorZ: anchorZ,
            perspective: perspective
        ) { _ in
            front()
        } back: { _ in
            back()
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
extension DoubleSideView: @MainActor Animatable {
    var animatableData: Angle.AnimatableData {
        get {
            angle.animatableData
        }
        set {
            angle.animatableData = newValue
        }
    }
}

private extension DoubleSideView {
    @ViewBuilder
    func content(_ angle: Angle) -> some View {
        switch currentSide {
        case .front:
            front(phase(for: angle))
        case .back:
            back(phase(for: angle))
        }
    }
}

private extension DoubleSideView {
    var brightnessValue: Double {
        switch style {
        case .default:
            return 0
        case .shading:
            let br = abs(dot)
            return br > (1.0 / 512.0) ? -br * brightnessConstant : 0
        }
    }

    var brightnessConstant: Double {
        switch colorScheme {
        case .dark:
            0.4
        case .light:
            0.2
        @unknown default:
            0.2
        }
    }

    var currentSide: Side {
        angle.side
    }

    func phase(for angle: Angle) -> CGFloat {
        1.0 - abs(dot(for: angle))
    }

    func dot(for angle: Angle) -> CGFloat {
        CGVector(dx: 1, dy: 0)
            .dot(CGVector(dx: 0, dy: 1).rotated(angle))
    }

    var dot: CGFloat {
        dot(for: angle)
    }

    var cross: CGFloat {
        CGVector(dx: 1, dy: 0)
            .cross(CGVector(dx: 0, dy: 1)
                .rotated(angle))
    }
}

#Preview {
    @Previewable
    @State var angle: Angle = .zero

    VStack {
        Slider(value: .init(get: {
            angle.degrees
        }, set: { value in
            angle.degrees = value
        }), in: 0 ... 180)

        DoubleSideView(angle: angle) { phase in
            // Text(phase, format: .number).padding(66)
            RoundedRectangle(cornerRadius: 16).fill(
                Color.red
            ).frame(width: 128, height: 128)
                .overlay {
                    Text(phase, format: .number)
                }

        } back: { phase in
            RoundedRectangle(cornerRadius: 16).fill(
                Color.blue
            )
            .frame(width: 128, height: 128)
            .overlay {
                Text(phase, format: .number)
            }
        }
    }
}
