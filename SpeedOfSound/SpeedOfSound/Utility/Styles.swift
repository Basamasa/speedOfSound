//
//  File.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 30.04.22.
//

import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(35)
    }
}
