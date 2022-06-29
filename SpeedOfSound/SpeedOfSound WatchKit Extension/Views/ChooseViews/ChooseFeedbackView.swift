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
                    VStack(alignment: .center) {
                        Image(systemName: "applewatch.radiowaves.left.and.right")
                            .imageScale(.large)
                            .foregroundColor(Color("Green"))
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    
                    Text("Watch A")
                        .bold()
                        .font(.footnote)
                        .foregroundColor(Color("Green"))
                    Spacer()

                }
                .tint(.red)
                .font(.body)
            }
            .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))
            
            NavigationLink(destination:  ChooseRangeView(feedback: .appleWatchSound)) {
                HStack {
                    VStack(alignment: .center) {
                        Image(systemName: "applewatch.radiowaves.left.and.right")
                            .imageScale(.large)
                            .foregroundColor(Color("Green"))
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    Text("Watch B")
                        .bold()
                        .font(.footnote)
                        .foregroundColor(Color("Green"))
                    Spacer()

                }
            }
            .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))

            NavigationLink(destination:  ChooseRangeView(feedback: .iosSound)) {
                HStack {
                    VStack(alignment: .center) {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .imageScale(.large)
                            .foregroundColor(Color("Green"))
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    Text("iOS B")
                        .bold()
                        .font(.footnote)
                        .foregroundColor(Color("Green"))
                    Spacer()

                }
            }
            .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))

            
//            NavigationLink(destination:  ChooseRangeView(feedback: .sound2)) {
//                HStack {
//                    Image(systemName: "metronome.fill")
//                        .imageScale(.large)
//                        .foregroundColor(Color("Green"))
//                    Text("Adaptive Sound")
//                        .bold()
//                        .font(.body)
//                        .foregroundColor(Color("Green"))
//                    Spacer()
//
//                }
//            }
//            .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))
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
