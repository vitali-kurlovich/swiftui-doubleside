//
//  Created by Kurlovich Vitali on 5/16/26.
//

import SwiftUI

public struct DoubleSide<Front: View, Back: View>: View {
    private let side: Side

    private let front: (CGFloat) -> Front
    private let back: (CGFloat) -> Back

    private let axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    private let anchor: UnitPoint
    private let anchorZ: CGFloat
    private let perspective: CGFloat

    private let reversed: Bool

    public init(_ side: Side,
                axis: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 0, y: 1, z: 0),
                anchor: UnitPoint = .center,
                anchorZ: CGFloat = 0,
                perspective: CGFloat = 0.333,

                reversed: Bool = true,

                @ViewBuilder front: @escaping (CGFloat) -> Front,
                @ViewBuilder back: @escaping (CGFloat) -> Back)
    {
        self.side = side

        self.axis = axis
        self.anchor = anchor
        self.anchorZ = anchorZ
        self.perspective = perspective

        self.reversed = reversed

        self.front = front
        self.back = back
    }

    public var body: some View {
        DoubleSideView(angle: angle,
                       axis: axis,
                       anchor: anchor,
                       anchorZ: anchorZ,
                       perspective: perspective,
                       front: front,
                       back: back)
    }
}

private extension DoubleSide {
    var angle: Angle {
        switch side {
        case .front:
            .degrees(0)
        case .back:
            reversed ? .degrees(-180) : .degrees(180)
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
#Preview {
    @Previewable
    @State
    var side: Side = .front

    HStack {
        DoubleSide(side,
                   front: { phase in
                       PreviewContent(color: Color(hue: phase / 5, saturation: 1, brightness: 1), systemName: "moon.stars.fill")
                           .overlay {
                               Text(phase, format: .number)
                           }
                   }, back: { phase in
                       PreviewContent(color: Color(hue: phase, saturation: 1, brightness: 1), systemName: "cloud.moon.fill")
                           .scaleEffect(x: -1)

                   })

        DoubleSide(side, reversed: true, front: { _ in
            PreviewContent(color: .purple, systemName: "moon.stars.fill")
        }, back: { _ in
            PreviewContent(color: .mint, systemName: "cloud.moon.fill")
                .scaleEffect(x: -1)

        })

        DoubleSide(side,
                   axis: (x: 1, y: 0, z: 0),
                   front: { _ in
                       PreviewContent(color: .green, systemName: "moon.stars.fill")
                   }, back: { _ in
                       PreviewContent(color: .red, systemName: "cloud.moon.fill")
                           .scaleEffect(y: -1)

                   })

        DoubleSide(side, anchor: .trailing, front: { _ in
            PreviewContent(color: .purple, systemName: "moon.stars.fill")
        }, back: { _ in
            PreviewContent(color: .mint, systemName: "cloud.moon.fill")
                .scaleEffect(x: -1)

        })
    }
    Button("Toggle") {
        withAnimation {
            side.toggle()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PreviewContent: View {
    let color: Color
    let systemName: String

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(color)
            .overlay {
                Image(systemName: systemName)
                    .symbolEffect(.breathe)
                    .symbolRenderingMode(.multicolor)
                    .font(.largeTitle)
                    .foregroundStyle(.regularMaterial)
            }
            .frame(width: 275 / 2,
                   height: 475 / 2)
            .doubleSideStyle(.shading)
    }
}
