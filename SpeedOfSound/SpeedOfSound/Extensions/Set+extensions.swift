//
//  Set+extensions.swift
//  MetronomeZones
//
//  Created by Anzer Arkin on 19.09.22.
//

import SwiftUI

extension Set where Element == PresentationDetent {

    func withLarge() -> Set<PresentationDetent> {
        var detent = self
        detent.insert(.large)
        return detent
    }
}
