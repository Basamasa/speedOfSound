//
//  ChooseRangeView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI

struct ChooseRangeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var feedback: Feedbackstyle
    let heartRange = Array(stride(from: 40, to: 200, by: 1))
    let ageRange = Array(stride(from: 18, to: 80, by: 1))
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text("Age:")
                    Spacer()
                    Picker("", selection: $workoutManager.workoutModel.age) {
                        ForEach(ageRange, id: \.self) {
                            Text("\($0)")
                                .tag($0)
                                .foregroundColor(Color("MainHighlight"))
                        }
                    }
                    .pickerStyle(.wheel)
                    .compositingGroup()
                    .frame(width: 40, height: 60)
                    .clipped(antialiased: true)
                    .offset(y: -10)
                }
//                HStack {
//                    Text("Rest heart rate:")
//                    Spacer()
//                    Picker("", selection: $workoutManager.workoutModel.restingHeartRate) {
//                        ForEach(heartRange, id: \.self) {
//                            Text("\($0)")
//                                .tag($0)
//                                .foregroundColor(Color("MainHighlight"))
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                    .compositingGroup()
//                    .frame(width: 40, height: 60)
//                    .clipped(antialiased: true)
//                    .offset(y: -10)
//                }
                VStack(alignment: .leading) {
                    Text("Heart rate zone:")
                    HStack {
                        Picker("", selection: $workoutManager.workoutModel.lowBPM) {
                            ForEach(heartRange, id: \.self) {
                                Text("\($0)")
                                    .tag($0)
                                    .foregroundColor(Color("MainHighlight"))
                            }
                        }
                        .pickerStyle(.wheel)
                        .compositingGroup()
                        .frame(height: 60)
                        .clipped(antialiased: true)

                        Picker("", selection: $workoutManager.workoutModel.highBPM) {
                            ForEach(heartRange, id: \.self) {
                                Text("\($0)")
                                    .foregroundColor(Color("MainHighlight"))
                            }
                        }
                        .pickerStyle(.wheel)
                        .compositingGroup()
                        .frame(height: 60)
                        .clipped(antialiased: true)
                    }
                    .offset(y: -10)
                }
                NavigationLink(destination: CadenceView()) {
                    HStack {
                        Text("Next")
                            .bold()
                            .foregroundColor(Color("Green"))
                    }
                }
            }
        }
        .padding([.leading, .trailing])
        .navigationBarTitle("Calculate zone❤️")
        .onAppear() {
            workoutManager.workoutModel.feedback = feedback
        }
    }
}

struct ChooseRangeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseRangeView(feedback: .notification)
    }
}
