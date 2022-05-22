//
//  ChooseFeedbackView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 16.05.22.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ChooseFeedbackView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
//    @ObservedObject var manager = LocationManager()
//    @State var tracking: MapUserTrackingMode = .follow

    var body: some View {
//        NavigationView {
//            Map(coordinateRegion: $manager.region, showsUserLocation: false, userTrackingMode: $tracking, annotationItems: manager.allLocations) { location in
//                MapAnnotation(coordinate: location.coordinate) {
//                    Circle()
//                        .stroke(.red, lineWidth: 3)
//                        .frame(width: 4, height: 4)
//                        .onTapGesture {
//                            print("Tapped on \(location.name)")
//                        }
//                }
//            }
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//            .edgesIgnoringSafeArea(.all)
//
//        }.navigationTitle("Running")
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
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
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
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
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
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            }
        }
        .navigationBarTitle("Feedback")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var region = MKCoordinateRegion()
    private let manager = CLLocationManager()
    @Published var allLocations: [Location] = []
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            allLocations.append(Location(name: "", coordinate: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)))
        }
        print("New")
    }
}

struct ChooseFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseFeedbackView()
    }
}
