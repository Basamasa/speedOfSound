//
//  MetroView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 23.04.22.
//

import SwiftUI
import AVFoundation
import UIKit

struct PlayerView: View {
    @EnvironmentObject var soundViewModel: PlayerViewModel
    let namespace: Namespace.ID

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "music.note")
                Picker("Effect", selection: $soundViewModel.effectIndex) {
                    ForEach(0 ..< soundViewModel.effect.count, id:\.self) { index in
                            Text(soundViewModel.effect[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: soundViewModel.effectIndex) { _ in
                    soundViewModel.runRestart()
                }
            }
            .padding()
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    soundViewModel.clickOnMinusButton()
                }, label: {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .font(Font.title.weight(.light))
                })
                
                Button(action: {
                    soundViewModel.clickOnBPM()
                }, label: {
                    VStack {
                        Text("\(Int(soundViewModel.BPM))")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("BPM")
                            .font(.footnote)
                    }
                    .foregroundColor(.white)
                })
                .matchedGeometryEffect(id: "BPM", in: namespace)

                Image(systemName: "poweron")
                    .font(.largeTitle)
                VStack {
                    Text("\(soundViewModel.count)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Heart rate")
                        .font(.footnote)
                }
                .foregroundColor(.white)
                Button(action: {
                    soundViewModel.clickOnPlusButton()
                }, label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .font(Font.title.weight(.light))
                })
                Spacer()
            }
            Spacer()
            Button(action: {
                soundViewModel.tapOnStartButton()
            }, label: {
                Image(systemName: soundViewModel.mode == .stopped ? "play.circle.fill" : "pause.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    
            })
            .matchedGeometryEffect(id: "PlayButton", in: namespace)

            Spacer()
        }
        .frame(height: 400)
        .background(.black)
    }
}

enum isMetroRunning {
    case running
    case stopped
}

