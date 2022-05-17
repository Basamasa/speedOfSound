//
//  CadenceCalculateView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI

struct CadenceWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var timeRemaining = countDownTime
    
    static let countDownTime: Int = 60
    
    var body: some View {
        ScrollView {
            VStack {
                if timeRemaining != 0 {
                    HStack {
                        Text("\(timeRemaining)")
                            .foregroundStyle(.yellow)
                            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            .frame(alignment: .leading)
                        Spacer()
                    }
                }
            
                if timeRemaining == 0 {
                    HStack {
                        Text("Select one of the cadence")
                            .bold()
                            .font(.footnote)
                            .frame(alignment: .leading)
                        Spacer()
                    }
                }
                VStack(alignment: .leading) {
                    if timeRemaining == 0 {
                        Button {
                            workoutManager.selectedCadenceStyle = .average
                        } label: {
                            VStack(alignment: .leading) {
                                Text("Average:")
                                    .font(.footnote)
                                Text("\(workoutManager.averageCadence)")
                                    .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps()) +
                                Text("SPM")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .tag(CadenceStyle.average)
                        }
                        .onTapGesture {
                            workoutManager.selectedCadenceStyle = .average
                        }
                        .tint(workoutManager.selectedCadenceStyle == .average ? Color("Green") : nil)
                        Button {
                            workoutManager.selectedCadenceStyle = .highest
                        } label: {
                            VStack(alignment: .leading) {
                                Text("Highest:")
                                    .font(.footnote)
                                Text("\(workoutManager.highestCadence)")
                                    .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                + Text("SPM")
                                        .font(.body)
                                        .foregroundColor(.gray)
                            }
                            .tag(CadenceStyle.highest)
                        }
                        .onTapGesture {
                            workoutManager.selectedCadenceStyle = .highest
                        }
                        .tint(workoutManager.selectedCadenceStyle == .highest ? Color("Green") : nil)
                    }
                    if timeRemaining != 0 {
                        Button {
                            workoutManager.selectedCadenceStyle = .current
                        } label: {
                            VStack(alignment: .leading) {
                                Text("\(workoutManager.currentCadence)")
                                    .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                + Text("SPM")
                                        .font(.body)
                                        .foregroundColor(.gray)
                            }
                            .tag(CadenceStyle.current)
                        }
                        .onTapGesture {
                            workoutManager.selectedCadenceStyle = .current
                        }
                        .tint(workoutManager.selectedCadenceStyle == .current ? Color("Green") : nil)
                    }
                }
                .pickerStyle(.inline)
                if timeRemaining == 0 {
                    Button {
                        workoutManager.cadenceWorkoutSelected()
                    } label: {
                        Text("Use this")
                            .bold()
                            .font(.title3)
                    }
                    .tint(Color("Main"))
                    .font(.footnote)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarHidden(true)
            .scenePadding()
            .onReceive(workoutManager.timer) { time in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    if timeRemaining == CadenceWorkoutView.countDownTime - 8 {
                        if workoutManager.isCadenceAvailable {
                            workoutManager.startTrackingSteps()
                        }
                    }
                } else if timeRemaining == 0 {
                    workoutManager.endCadenceWorkout()
                }
            }
        }
    }
}

struct CadenceWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        CadenceWorkoutView()
            .environmentObject(WorkoutManager())
    }
}
