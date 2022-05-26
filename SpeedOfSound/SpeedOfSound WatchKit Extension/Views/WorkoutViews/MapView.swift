//
//  MapView.swift
//  MetronomeZones WatchKit Extension
//
//  Created by Anzer Arkin on 26.05.22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var manager = LocationManager()
    @State var tracking: MapUserTrackingMode = .follow
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")

                Map(coordinateRegion: $manager.region, showsUserLocation: false, userTrackingMode: $tracking, annotationItems: manager.allLocations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        Circle()
                            .stroke(.red, lineWidth: 3)
                            .frame(width: 4, height: 4)
                            .onTapGesture {
                                print("Tapped on \(location.name)")
                            }
                    }
                }
                .disabled(true)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }

        }.navigationTitle("Running")
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
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
