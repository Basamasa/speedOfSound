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
    
    var body: some View {
        VStack{
        HStack {
            Picker("", selection: $workoutManager.workoutModel.lowBPM) {
                ForEach(workoutManager.heartRange, id: \.self) {
                    Text("\($0)")
                        .tag($0)
                        .foregroundColor(Color("MainHighlight"))
                }
            }
            .pickerStyle(.wheel)
            .compositingGroup()
            .clipped(antialiased: true)

            Picker("", selection: $workoutManager.workoutModel.highBPM) {
                ForEach(workoutManager.heartRange, id: \.self) {
                    Text("\($0)")
                        .foregroundColor(Color("MainHighlight"))
                }
            }
            .pickerStyle(.wheel)
            .compositingGroup()
            .clipped(antialiased: true)
        }
            NavigationLink(destination: CadenceView()) {
                HStack {
                    Text("Next")
                        .bold()
                        .foregroundColor(Color("Green"))
                }
            }
        }
        .padding([.leading, .trailing])
        .navigationBarTitle("Heart rate range")
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
