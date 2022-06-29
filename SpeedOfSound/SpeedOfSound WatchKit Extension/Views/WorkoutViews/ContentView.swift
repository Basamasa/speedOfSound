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
    var workoutTypes: [WorkoutType] = [.indoorRunning, .outdoorRunning, .indoorWalking, .outdoorWalking]
    var body: some View {
        List(workoutTypes) { workoutType in
            NavigationLink(tag: workoutType, selection: $workoutManager.selectedWorkout) {
                SessionPagingView()
            } label: {
                HStack {
                    Image(workoutType.imagName)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(workoutType.name)
                        .bold()
                        .font(.footnote)
                }
                .onTapGesture {
                    workoutManager.selectedOneWorkout(workoutType: workoutType)
                }
            }
            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        }
        .listStyle(.carousel)
        .navigationBarTitle("Let's start 💪")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

enum WorkoutType: String, Identifiable {
    var id: RawValue { rawValue }

    
    case outdoorRunning = "Outdoor running"
    case indoorRunning = "Indoor running"
    case outdoorWalking = "Outdoor walking"
    case indoorWalking = "Indoor walking"
    
    var name: String {
        switch self {
        case .outdoorRunning:
            return "Outdoor Run"
        case .indoorRunning:
            return "Indoor run"
        case .outdoorWalking:
            return "Outdoor walk"
        case .indoorWalking:
            return "Indoor walk"
        }
    }
    
    var imagName: String {
        switch self {
        case .outdoorRunning:
            return "running"
        case .indoorRunning:
            return "running"
        case .outdoorWalking:
            return "walking"
        case .indoorWalking:
            return "walking"
        }
    }
}

