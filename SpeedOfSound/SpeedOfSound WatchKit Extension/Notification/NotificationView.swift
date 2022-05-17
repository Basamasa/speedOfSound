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
        Text(message)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(message: "Test")
    }
}
