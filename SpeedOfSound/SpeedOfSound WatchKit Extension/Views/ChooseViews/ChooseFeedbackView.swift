//
//  ChooseFeedbackView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ChooseFeedbackView: View {
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: ChooseRangeView(feedback: .notification)) {
                HStack {
                    Image(systemName: "applewatch.radiowaves.left.and.right")
                        .foregroundColor(Color("Green"))
                    Text("Notification")
                        .bold()
                        .font(.body)
                        .foregroundColor(Color("Green"))
                }
                .tint(.red)
                .font(.body)
                .padding(EdgeInsets(top: 50, leading: 5, bottom: 50, trailing: 5))
            }

            NavigationLink(destination:  ChooseRangeView(feedback: .sound)) {
                HStack {
                    Image(systemName: "metronome.fill")
                        .foregroundColor(Color("Green"))
                    Text("Sound")
                        .bold()
                        .font(.body)
                        .foregroundColor(Color("Green"))
                }
                .padding(EdgeInsets(top: 50, leading: 5, bottom: 50, trailing: 5))
            }
            
            NavigationLink(destination:  ChooseRangeView(feedback: .sound2)) {
                HStack {
                    Image(systemName: "metronome.fill")
                        .foregroundColor(Color("Green"))
                    Text("Sound 2")
                        .bold()
                        .font(.body)
                        .foregroundColor(Color("Green"))
                }
                .padding(EdgeInsets(top: 50, leading: 5, bottom: 50, trailing: 5))
            }
        }
        .navigationBarTitle("Feedback")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

struct ChooseFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseFeedbackView()
    }
}
