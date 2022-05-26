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
        List {
            NavigationLink(destination: ChooseRangeView(feedback: .notification)) {
                HStack {
                    Image(systemName: "applewatch.radiowaves.left.and.right")
                        .foregroundColor(Color("Green"))
                    Text("Notification")
                        .bold()
                        .font(.body)
                        .foregroundColor(Color("Green"))
                    Spacer()

                }
                .tint(.red)
                .font(.body)
            }
            .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))

            NavigationLink(destination:  ChooseRangeView(feedback: .sound)) {
                HStack {
                    Image(systemName: "metronome.fill")
                        .foregroundColor(Color("Green"))
                    Text("Sound")
                        .bold()
                        .font(.body)
                        .foregroundColor(Color("Green"))
                    Spacer()

                }
            }
            .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))

            
            NavigationLink(destination:  ChooseRangeView(feedback: .sound2)) {
                HStack {
                    Image(systemName: "metronome.fill")
                        .foregroundColor(Color("Green"))
                    Text("Adaptive Sound")
                        .bold()
                        .font(.body)
                        .foregroundColor(Color("Green"))
                    Spacer()

                }
            }
            .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))
        }
        .listStyle(.carousel)
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
