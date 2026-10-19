//
//  Created by Kurlovich Vitali on 10/19/26.
//

import SwiftUI

public extension EnvironmentValues {
    @Entry var doubleSideStyle: DoubleSideStyle = .default
}

public enum DoubleSideStyle {
    case shading
    case `default`
}

public extension View {
    func doubleSideStyle(_ style: DoubleSideStyle) -> some View {
        environment(\.doubleSideStyle, style)
    }
}
