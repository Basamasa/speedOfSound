//
//  CadenceView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI

struct CadenceView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    private let range: [Int] = Array(60...200)
    
    var body: some View {
        VStack{
            HStack {
                Picker("", selection: $workoutManager.selectedCadence) {
                    ForEach(range, id: \.self) {
                        Text("\($0)")
                            .tag($0)
                            .foregroundColor(Color("MainHighlight"))
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 90)
                Spacer()
                Button {
                    workoutManager.showCadenceSheet = true
                    if workoutManager.isCadenceAvailable {
                        workoutManager.startTrackingSteps()
                    }
                } label: {
                    Text("Test")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color("Green"))
                }
            }
            NavigationLink(destination: ContentView(cadence: workoutManager.selectedCadence)) {
                Text("Finish")
                    .bold()
                    .foregroundColor(Color("Main"))
                    .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            }
        }
        .padding([.leading, .trailing])
        .navigationBarTitle("Cadence")
        .sheet(isPresented: $workoutManager.showCadenceSheet) {
            print("Dismiss cadence workout view")
        } content: {
            CadenceWorkoutView()
        }

    }
}

struct CadenceView_Previews: PreviewProvider {
    static var previews: some View {
        CadenceView()
    }
}
