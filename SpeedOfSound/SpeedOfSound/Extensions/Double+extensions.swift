//
//  Double+extensions.swift
//  MetronomeZones
//
//  Created by Anzer Arkin on 22.05.22.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
