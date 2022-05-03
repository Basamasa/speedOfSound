//
//  Colors.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 24.04.22.
//

import Foundation
import SwiftUI

struct Colors {
    static let colorGradient = LinearGradient(
        gradient: Gradient(colors: [Color(.systemGreen), Color(.systemGray4)]),
                            startPoint: .topLeading, endPoint: .bottomTrailing)
    static let grayGradient = LinearGradient(
        gradient: Gradient(colors: [Color(.systemGray2), Color(.systemGray4)]),
                            startPoint: .topLeading, endPoint: .bottomTrailing)
}
