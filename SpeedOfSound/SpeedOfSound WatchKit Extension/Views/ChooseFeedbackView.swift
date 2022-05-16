//
//  ChooseFeedbackView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI

enum Feedbackstyle: Int {
    case notification = 0
    case sound = 1
}

struct ChooseFeedbackView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: ChooseRangeView(feedback: .notification)) {
                HStack {
                    Image(systemName: "applewatch.radiowaves.left.and.right")
                    Text("Notification")
                        .bold()
                        .font(.body)
                }
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            }
            
            NavigationLink(destination:  ChooseRangeView(feedback: .sound)) {
                HStack {
                    Image(systemName: "metronome.fill")
                    Text("Sound")
                        .bold()
                        .font(.body)
                }
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
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
