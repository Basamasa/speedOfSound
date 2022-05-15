//
//  CGFloat.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 15.05.22.
//

import Foundation
import UIKit

infix operator &/
extension CGFloat {
    public static func &/(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
        if rhs == 0 {
            return 0
        }
        return lhs/rhs
    }
}
