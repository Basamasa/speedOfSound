//
//  RecentWorkoutsWidgets.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 03.05.22.
//

import SwiftUI
import HealthKit

struct Constants {
    static let widgetMediumHeight: CGFloat = 169
    static let widgetLargeHeight: CGFloat = 376
}

struct RecentWorkoutsWidgets: View {
    let workouts: [HKWorkout]
    let type: HKWorkoutActivityType

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TitleWorkouts(type: type)
            
            Text("You did \(workouts.count) workouts in the last 7 days.")
                .font(Font.body.bold())
                .foregroundColor(Color.white)
            Divider()
                .background(Color(UIColor.systemGray2))
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 20) {
                    ForEach(workouts.batched(into: 3), id: \.self) { items in
                        ThreeRowWorkouts(workouts: items)
                    }
                }
            }
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
    }
}

struct TitleWorkouts: View {
    let type: HKWorkoutActivityType
    var body: some View {
        HStack(spacing: 3) {
            if type == .running {
                Image("running")
                    .resizable()
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(width: 50, height: 50, alignment: .center)
                Text("Running workouts")
                    .foregroundColor(Color("Green"))
                    .padding()
            } else if type == .cycling {
                Image("cycling")
                    .resizable()
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(width: 50, height: 50, alignment: .center)
                Text("Cycling workouts")
                    .foregroundColor(Color("Green"))
                    .padding()
            } else if type == .walking {
                Image("walking")
                    .resizable()
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(width: 50, height: 50, alignment: .center)
                Text("Walking workouts")
                    .foregroundColor(Color("Green"))
                    .padding()
            }
        }
        .font(Font.body.bold())
        .foregroundColor(Color("Main"))
    }
}

struct ThreeRowWorkouts: View {
    let workouts: [HKWorkout]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(Array(workouts.enumerated()), id: \.offset) { (offset, element) in
                NavigationLink {
                    ZStack {
                        Color.black.edgesIgnoringSafeArea(.all)
                        RowDetailsView(rowDetailsViewModel: RowDetailsViewModel(workout: element))
                    }
                } label: {
                    WorkoutRowView(workout: WorkoutRowModel(workout: element))
                }
            }
            Spacer()
        }
    }
}

struct WorkoutRowView: View {
    let workout: WorkoutRowModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: -5)  {
                Text(workout.activityName)
                    .font(.caption).bold().foregroundColor(Color(UIColor.systemGray))
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(workout.durationHours)")
                            .workoutTitleStyle()
                        + Text(" hr ")
                            .workoutSubheadlineStyle()
                            + Text("\(workout.durationMinutes)")
                            .workoutTitleStyle()
                        + Text(" min")
                            .workoutSubheadlineStyle()
                    }
                    Divider()
                        .background(Color(UIColor.systemGray2))
                    VStack(alignment: .leading, spacing: 5) {
                        Text(workout.startTime.0)
                            .workoutTitleStyle()
                        + Text(workout.startTime.1)
                                .workoutSubheadlineStyle()
                    }
                    Divider()
                        .background(Color(UIColor.systemGray2))
                    VStack(alignment: .leading, spacing: 5) {
                        Text(workout.endTime.0)
                            .workoutTitleStyle()
                        + Text(workout.startTime.1)
                            .workoutSubheadlineStyle()
                    }
                }
                .frame(maxHeight: 40)
            }
        }
        .foregroundColor(Color.white)
    }
}
