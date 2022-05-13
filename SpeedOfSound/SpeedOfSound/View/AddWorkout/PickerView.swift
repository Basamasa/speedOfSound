//
//  NewWorkOutView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 30.04.22.
//

import SwiftUI
import SwiftUIGIF
import HalfASheet

struct PickerView: View {
    @State private var lowBPM: Int = 120
    @State private var highBPM = 140
    private let heartRange = [40, 60, 80, 100, 120, 140, 160, 180, 200]
    @EnvironmentObject var playerViewModel: PlayerViewModel

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack(alignment: .trailing) {
            Button {
                playerViewModel.showPickerView = false
            } label: {
                Image(systemName: "multiply.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
            }
            .frame(alignment: .trailing)
            .offset(y: -20)

            HStack {
                Picker("", selection: $lowBPM) {
                    ForEach([60, 80, 100, 120], id: \.self) {
                        Text("\($0)")
                            .foregroundColor(.black)
                            .tag($0)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 50, height: 120)
                .compositingGroup()
                .clipped(antialiased: true)
                Text("BPM")
                    .foregroundColor(.black)
                    .bold()
                    .font(.body)
                Spacer()
                Text("----")
                    .foregroundColor(.black)
                    .bold()
                    .font(.title)
                    .frame(width: 100)
                Spacer()
                Picker("", selection: $highBPM) {
                    ForEach([140, 160, 180, 200], id: \.self) {
                        Text("\($0)")
                            .foregroundColor(.black)

                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 50, height: 120)
                .compositingGroup()
                .clipped(antialiased: true)
                Text("BPM")
                    .foregroundColor(.black)
                    .bold()
                    .font(.body)
            }
            .padding([.leading, .trailing])
            HStack {
                Spacer()
                Button {
                    playerViewModel.tapOnStartSessionButton()
                } label: {
                    Text("Start")
                        .bold()
                        .frame(width: 190, height: 60, alignment: .center)
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .cornerRadius(25)
                }
                Spacer()
            }
            .padding()
//            .offset(y: 50)
        }
        .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 500)
                .background(.gray.opacity(0.3))
                .cornerRadius(25.0)
                .shadow(color: Color.black.opacity(0.8), radius: 5, x: 0, y: 2)
                .padding()
                .navigationBarTitleDisplayMode(.large)
    }
    func didDismiss() {
        // Handle the dismissing action.
    }
}

struct NewWorkOutView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
