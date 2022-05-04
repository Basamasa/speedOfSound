//
//  NewWorkOutView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 30.04.22.
//

import SwiftUI
import SwiftUIGIF
import HalfASheet

struct NewWorkOutView: View {
    @State var username = ""
    @State var sleepAmount = 0
    @State private var lowBPM: Int = 120
    @State private var highBPM = 140
    private let heartRange = [40, 60, 80, 100, 120, 140, 160, 180, 200]
    @EnvironmentObject var soundViewModel: MetronomeViewModel

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                        .frame(width: 32.0, height: 32.0)
                    .foregroundColor(Color.white)
                VStack(alignment: .leading) {
                    HStack {
                        TextField("", text: $username)
                            .foregroundColor(.green)
                    }
                    .textFieldStyle(OvalTextFieldStyle())
                }.padding()
            }
            .padding([.leading])
            .offset(y: -50)
            HStack {
                Picker("", selection: $lowBPM) {
                    ForEach([60, 80, 100, 120], id: \.self) {
                        Text("\($0)")
                            .foregroundColor(.white)
                            .tag($0)
                    }
                }
                .pickerStyle(.wheel)
                .fixedSize()
                .frame(width: 30, height: 30)
                Text("BPM")
                    .foregroundColor(.white)
                    .bold()
                    .font(.body)
                Spacer()
                Text("----")
                    .foregroundColor(.white)
                    .bold()
                    .font(.body)
                Spacer()
                Picker("", selection: $highBPM) {
                    ForEach([140, 160, 180, 200], id: \.self) {
                        Text("\($0)")
                            .foregroundColor(.white)

                    }
                }
                .pickerStyle(.wheel)
                .fixedSize()
                .frame(width: 30, height: 30)

                Text("BPM")
                    .foregroundColor(.white)
                    .bold()
                    .font(.body)
            }
            .padding([.leading, .trailing])
            HStack {
                Spacer()
                Button("Start", action: {soundViewModel.isShowingSheet.toggle()})
                .buttonStyle(.bordered)
                .font(.title)
                .foregroundColor(.white)
                .background(Color.blue.opacity(0.1))
                Spacer()
            }
            .padding()
            .offset(y: 50)
        }
        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 500)
        .background(.gray.opacity(0.3))
        .cornerRadius(25.0)
        .shadow(color: Color.black.opacity(0.8), radius: 5, x: 0, y: 2)
        .padding()
        .navigationBarTitleDisplayMode(.large)
        }
    }
    func didDismiss() {
        // Handle the dismissing action.
    }
}

struct NewWorkOutView_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkOutView()
    }
}
