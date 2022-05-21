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
    
    func workoutSubheadlineGreen() -> Text {
        self
            .font(.subheadline).bold().foregroundColor(Color("Green"))
    }
    
    func workoutDateStyle() -> Text {
        self
            .font(.footnote).bold().foregroundColor(Color(UIColor.systemGray))
    }
    
    func workoutTitleStyle() -> Text {
        self
            .font(.title3).bold().foregroundColor(Color("Green"))
    }
    
    func workoutTitleHighLight() -> Text {
        self
            .font(.title3).bold().foregroundColor(Color("MainHighlight"))
    }
    
    func workoutTitleYellow() -> Text {
        self
            .font(.title3).bold().foregroundColor(.yellow)
    }
    
    func workoutTitlBlue() -> Text {
        self
            .font(.title3).bold().foregroundColor(.blue)
    }
    
    func workoutTitlCyan() -> Text {
        self
            .font(.title3).bold().foregroundColor(.cyan)
    }
    
    func workoutTitleRed() -> Text {
        self
            .font(.title3).bold().foregroundColor(Color("Main"))
    }
    
    func workoutTitleHighZone() -> Text {
        self
            .font(.title3).bold().foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.25))
    }
    
    func workoutTitleLowZone() -> Text {
        self
            .font(.title3).bold().foregroundColor(Color(red: 0.25, green: 0.75, blue: 1.0))
    }
}
