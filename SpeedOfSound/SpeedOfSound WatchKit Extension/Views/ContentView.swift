//
//  ContentView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 20.04.22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutTypes: [HKWorkoutActivityType] = [.cycling, .running, .walking, .traditionalStrengthTraining]
    
    var body: some View {
//        WatchFace()
        List(workoutTypes) { workoutType in
            NavigationLink(workoutType.name, destination: SessionPagingView(),
                           tag: workoutType, selection: $workoutManager.selectedWorkout)
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        }
        .listStyle(.carousel)
        .navigationBarTitle("Workouts")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .running:
            return "🏃🏻‍♂️Run"
        case .cycling:
            return "🚴🏻 Bike"
        case .walking:
            return "🚶🏻 Walk"
        case .traditionalStrengthTraining:
            return "🏋🏻‍♂️ Strength Training"
        default:
            return ""
        }
    }
}
