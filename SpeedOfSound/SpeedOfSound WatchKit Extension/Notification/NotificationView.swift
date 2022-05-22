//
//  NotificationView.swift
//  SpeedOfSound WatchKit Extension
//
//  Created by Anzer Arkin on 20.04.22.
//

import SwiftUI

struct NotificationView: View {
    var message: String
    
    var body: some View {
        if message == "Slow" {
            VStack {
                Image(systemName: "tortoise.fill")
                    .foregroundColor(.yellow)
                Text("Let's speed up!")
                    .foregroundColor(.yellow)
            }
        } else {
            VStack {
                Image(systemName: "hare")
                    .foregroundColor(.red)
                Text("Slow down!")
                    .foregroundColor(.red)
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(message: "Test")
    }
}
