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
                Picker("", selection: $workoutManager.workoutModel.cadence) {
                    ForEach(range, id: \.self) {
                        Text("\($0)")
                            .tag($0)
                            .foregroundColor(Color("MainHighlight"))
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 90)
                Spacer()
            }
            NavigationLink(destination: ContentView()) {
                Text("Finish")
                    .bold()
                    .foregroundColor(Color("Green"))
                    .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            }
        }
        .padding([.leading, .trailing])
        .navigationBarTitle("Cadence")

    }
}

struct CadenceView_Previews: PreviewProvider {
    static var previews: some View {
        CadenceView()
    }
}
