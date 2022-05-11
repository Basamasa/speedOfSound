//
//  Text+extensions.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 03.05.22.
//
import SwiftUI

extension Text {
    func workoutSubheadlineStyle() -> Text {
        self
            .font(.subheadline).bold().foregroundColor(Color(UIColor.systemGray))
    }
    
    func workoutDateStyle() -> Text {
        self
            .font(.footnote).bold().foregroundColor(Color(UIColor.systemGray))
    }
    
    func workoutTitleStyle() -> Text {
        self
            .font(.title3).bold().foregroundColor(Color("Green"))
    }
}
