//
//  CadenceCalculateView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI

struct CadenceWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            VStack {
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                    .foregroundStyle(.yellow)
//                    .frame(
                VStack {
                    Button {
                        workoutManager.endCadenceWorkout()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(.red)
                    .font(.title2)
                }
            }
        }
    }
}
