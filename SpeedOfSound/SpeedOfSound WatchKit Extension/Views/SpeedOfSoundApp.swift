//
//  SpeedOfSoundApp.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 20.04.22.
//

import SwiftUI

@main
struct SpeedOfSoundApp: App {
    @StateObject private var workoutManager = WorkoutManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ChooseFeedbackView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
