//
//  CadenceView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 15.05.22.
//

import SwiftUI

struct CadenceView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel

    var body: some View {
        VStack {
            Text("Hello world")
                .foregroundColor(.black)
        }
        .frame(width: UIScreen.main.bounds.width - 100, height: 350)
                .background(.white)
                .cornerRadius(25.0)
                .shadow(color: Color.black.opacity(0.8), radius: 5, x: 0, y: 2)
                .padding()
                .navigationBarTitleDisplayMode(.large)
    }
}

struct CadenceView_Previews: PreviewProvider {
    static var previews: some View {
        CadenceView()
    }
}
