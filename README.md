# DoubleSide

A two-sided, flippable view for SwiftUI.

`rotation3DEffect` rotates a view, but it doesn't know a card has a back: past 90° you see the front mirrored. `DoubleSide` shows the right face at every angle, animates smoothly, and lets you flip around any axis.

https://github.com/user-attachments/assets/ffdeccb3-8641-4d99-bceb-f3b04fc8516e

## Features

- Shows the front or back face depending on the current angle, so the back is never a mirrored front
- Fully animatable: use `.front`, `.back`, or any `.angle(_:)`, and drive it with `withAnimation`, a slider or a gesture
- Flips around any axis, with your own anchor, `anchorZ` and perspective
- Passes a phase value into each face, so content can react while it turns
- Optional `.shading` style darkens the card as it turns away, tuned for light and dark mode
- Swift 6 language mode, no dependencies

## Requirements

- iOS 17+, macOS 14+, tvOS 17+
- Swift tools 6.4 (see `Package.swift`)

## Installation

### Swift Package Manager

In Xcode, choose **File → Add Package Dependencies…** and enter:

```
https://github.com/vitali-kurlovich/swiftui-doubleside
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/vitali-kurlovich/swiftui-doubleside", from: "1.0.1"),
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "DoubleSide", package: "swiftui-doubleside"),
        ]
    ),
]
```

## Usage

### Basic flip

```swift
import DoubleSide
import SwiftUI

struct CardView: View {
    @State private var side: Side = .front

    var body: some View {
        DoubleSide(side) { _ in
            RoundedRectangle(cornerRadius: 16)
                .fill(.purple)
                .overlay { Text("Front") }
        } back: { _ in
            RoundedRectangle(cornerRadius: 16)
                .fill(.mint)
                .overlay { Text("Back") }
        }
        .frame(width: 200, height: 300)
        .onTapGesture {
            withAnimation(.spring) {
                side.toggle()
            }
        }
    }
}
```

`Side.toggle()` switches `.front` and `.back`, and adds 180° to an `.angle(_:)`.

### Any angle

`Side` can hold any angle, so you can bind it to a slider or a drag gesture:

```swift
@State private var side: Side = .angle(.zero)

Slider(
    value: Binding(
        get: { side.angle.degrees },
        set: { side = .angle(.degrees($0)) }
    ),
    in: 0 ... 360
)
```

### Axis, anchor and perspective

```swift
// Flip vertically, around the top edge
DoubleSide(side,
           axis: (x: 1, y: 0, z: 0),
           anchor: .top,
           perspective: 0.5) { _ in
    Front()
} back: { _ in
    Back()
}
```

| Parameter     | Default             | Description                                       |
| ------------- | ------------------- | ------------------------------------------------- |
| `axis`        | `(x: 0, y: 1, z: 0)` | Rotation axis. The default flips horizontally.  |
| `anchor`      | `.center`           | Point the view rotates around.                    |
| `anchorZ`     | `0`                 | Depth offset of the anchor.                       |
| `perspective` | `0.333`             | Strength of the 3D perspective.                   |
| `reversed`    | `true`              | Rotates in the opposite direction.                |

### Shading

```swift
DoubleSide(side) { _ in Front() } back: { _ in Back() }
    .doubleSideStyle(.shading)
```

`doubleSideStyle(_:)` is an environment value, so you can set it once on a container and every `DoubleSide` inside picks it up.

## Example app

Open `Example/Example.xcodeproj` to try the flip, the axes and the shading style.

## License

DoubleSide is available under the MIT license. See [LICENSE](LICENSE) for details.
