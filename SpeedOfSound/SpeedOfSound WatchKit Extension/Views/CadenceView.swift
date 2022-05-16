//
//  CadenceView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI

struct CadenceView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State var selection: Int = 120
    private let range: [Int] = Array(60...200)
    
    var body: some View {
        VStack{
            HStack {
                Picker("", selection: $selection) {
                    ForEach(range, id: \.self) {
                        Text("\($0)")
                            .tag($0)
                    }
                }
                .pickerStyle(.wheel)
                .compositingGroup()
                .clipped(antialiased: true)
                Button {
                    
                } label: {
                    Text("Test")
                        .font(.footnote)
                        .bold()
                        .cornerRadius(25)
                }
            }
            NavigationLink(destination: ContentView(cadence: selection)) {
                Text("Finish")
                    .bold()
                    .cornerRadius(25)
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
