//
//  CadenceCalculateView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI

struct CadenceWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                VStack {
                    if timeRemaining == 0 {
                        Button {
                            workoutManager.selectedCadenceStyle = .average
                        } label: {
                            VStack(alignment: .leading) {
                                Text("Average cadence:")
                                    .font(.footnote)
                                Text("\(workoutManager.averageCadence)")
                                    .font(.title3)
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
                                Text("Highest cadence:")
                                    .font(.footnote)
                                Text("\(workoutManager.highestCadence)")
                                    .font(.title3)
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
                                Text("Current cadence:")
                                    .font(.footnote)
                                Text("\(workoutManager.currentCadence)")
                                    .font(.title3)
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
            .onReceive(timer) { time in
                if timeRemaining > 0 {
                    timeRemaining -= 1
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
