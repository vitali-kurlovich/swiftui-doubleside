//
//  Created by Kurlovich Vitali on 10/19/26.
//

import DoubleSide
import SwiftUI

struct Card: View {
    let side: Side

    let axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    let reversed: Bool
    let frontImageName: String
    let backImageName: String
    let backScale: (x: CGFloat, y: CGFloat)
    let backRotate: Angle

    init(
        side: Side,
        axis: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 1, y: 0, z: 0),
        reversed: Bool = false,
        frontImageName: String,
        backImageName: String,
        backScale: (x: CGFloat, y: CGFloat) = (x: 1, y: 1),
        backRotate: Angle = .zero
    ) {
        self.side = side
        self.axis = axis
        self.reversed = reversed
        self.frontImageName = frontImageName
        self.backImageName = backImageName
        self.backScale = backScale
        self.backRotate = backRotate
    }

    var body: some View {
        DoubleSide(side, axis: axis, reversed: reversed) { _ in
            Image(frontImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask {
                    RoundedRectangle(cornerRadius: 16)
                }

        } back: { _ in
            Image(backImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask {
                    RoundedRectangle(cornerRadius: 16)
                }
                .scaleEffect(x: backScale.x, y: backScale.y)
                .rotationEffect(backRotate)
        }
    }
}

#Preview {
    @Previewable
    @State
    var side: Side = .front
    HStack {
        Card(side: .angle(.degrees(30)),
             axis: (x: 0, y: 1, z: 0),
             frontImageName: "girl",
             backImageName: "wolf")

        Card(side: .angle(.degrees(30)),
             axis: (x: 1, y: 1, z: 0),
             frontImageName: "girl",
             backImageName: "nature_lake", backRotate:
             .degrees(-90))

        Card(
            side: .front,
            frontImageName: "girl",
            backImageName: "wolf"
        )
    }.padding()
}
