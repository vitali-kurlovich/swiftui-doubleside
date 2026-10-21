import DoubleSide
import SwiftUI

struct ContentView: View {
    @State
    var side: Side = .front

    @State
    var shading: Bool = false

    @State
    var size: CGFloat = 120

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 24) {
                Card(side: side, axis: (x: 0, y: 1, z: 0),
                     frontImageName: "girl", backImageName: "wolf")
                    .frame(height: size)

                Card(side: side,
                     frontImageName: "nature_lake_2", backImageName: "nature_lake")
                    .frame(height: size)

                Card(side: side, axis: (x: 1, y: 1, z: 0), frontImageName: "books", backImageName: "paper", backRotate:
                    .degrees(-90))
                    .frame(height: size)

                Card(side: side, frontImageName: "nature_lake", backImageName: "wolf")
                    .frame(height: size)

                Card(side: side, frontImageName: "flower", backImageName: "food")
                    .frame(height: size)
            }
            .shadow(radius: 12)
            .doubleSideStyle(shading ? .shading : .default)

        }.overlay(alignment: .bottom) {
            VStack {
                HStack {
                    Button("Toggle") {
                        withAnimation {
                            side.toggle()
                        }
                    }
                    Toggle("Shading", isOn: $shading)
                }

                Slider(value: .init(get: {
                    side.angle.degrees
                }, set: { degrees in
                    side = .angle(Angle(degrees: degrees))
                }), in: 0 ... 360)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Material.regular)
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Slider(value: $size, in: 120 ... 320, step: 40)
                    .frame(width: 220)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
