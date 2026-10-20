//
//  Created by Kurlovich Vitali on 5/16/26.
//

import SwiftUI

public enum Side: Hashable {
    case front
    case back
    case angle(Angle)

    public mutating func toggle() {
        switch self {
        case .front:
            self = .back
        case .back:
            self = .front
        case let .angle(angle):
            self = .angle((angle + Angle(radians: .pi)).normalized)
        }
    }
}

public extension Side {
    var angle: Angle {
        switch self {
        case .front:
            .zero
        case .back:
            .radians(.pi)
        case let .angle(angle):
            angle
        }
    }
}

private extension Angle {
    /// The same angle wrapped into [0, 2π).
    var normalized: Angle {
        let twoPi = 2 * Double.pi
        var r = radians.truncatingRemainder(dividingBy: twoPi) // (-2π, 2π)
        if r < 0 {
            r += twoPi
        } // [0, 2π)
        if r >= twoPi {
            r = 0
        }
        return .radians(r)
    }
}
