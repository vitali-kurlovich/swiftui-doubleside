//
//  Created by Kurlovich Vitali on 5/16/26.
//

import SwiftUI

extension Angle {
    var isBackSide: Bool {
        cos(radians) < 0
    }
}
