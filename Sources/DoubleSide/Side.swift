//
//  Created by Kurlovich Vitali on 5/16/26.
//

public enum Side {
    case front
    case back

    public mutating func toggle() {
        switch self {
        case .front:
            self = .back
        case .back:
            self = .front
        }
    }
}
