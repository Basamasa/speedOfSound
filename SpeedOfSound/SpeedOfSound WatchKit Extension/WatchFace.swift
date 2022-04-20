//
//  WatchFace.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 20.04.22.
//

import SwiftUI
import HealthKit

struct WatchFace: View {
    
    @ObservedObject var watchFaceModel = WatchFaceModel()
    
    var body: some View {
        VStack{
            HStack{
                Text("❤️")
                    .font(.system(size: 50))
                Spacer()
            }
            HStack{
                Text("\(watchFaceModel.value)")
                    .fontWeight(.regular)
                    .font(.system(size: 70))
                
                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 28.0)
                
                Spacer()
                
            }

        }
        .padding()
        .onAppear(perform: watchFaceModel.startCalculateHeartRate)
    }
}

struct WatchFace_Previews: PreviewProvider {
    static var previews: some View {
        WatchFace()
    }
}
