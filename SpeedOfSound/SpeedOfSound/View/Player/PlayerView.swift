//
//  MetroView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 23.04.22.
//

import SwiftUI
import AVFoundation
import UIKit

enum isMetroRunning {
    case running
    case stopped
}

struct PlayerView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    let namespace: Namespace.ID
    @State private var animationAmount: CGFloat = 1

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "music.note")
                Picker("Effect", selection: $playerViewModel.effectIndex) {
                    ForEach(0 ..< playerViewModel.effect.count, id:\.self) { index in
                            Text(playerViewModel.effect[index]).tag(index)
                            .foregroundColor(playerViewModel.mode == .running ? Color("Main") : .white)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: playerViewModel.effectIndex) { _ in
                    playerViewModel.runRestart()
                }
            }
            .padding()
            if playerViewModel.mode == .running {
                HStack {
                    Text("\(playerViewModel.workoutModel.lowBPM) - \(playerViewModel.workoutModel.highBPM)")
                        .foregroundColor(Color("Main"))
                        .bold()
                        .font(.title)
                }
                .padding()
            }
            
            Label(playerViewModel.speedString, systemImage: "metronome.fill")
                .foregroundColor(playerViewModel.mode == .running ? Color("MainHighlight") : .white)
            
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        playerViewModel.clickOnPlusButton()
                    }, label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(playerViewModel.mode == .running ? Color("Green") : .white)
                            .font(Font.title.weight(.light))
                    })
                    Button(action: {
                        playerViewModel.clickOnMinusButton()
                    }, label: {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(playerViewModel.mode == .running ? Color("Green") : .white)
                            .font(Font.title.weight(.light))
                    })
                }
                
                Button(action: {
                    playerViewModel.clickOnBPM()
                }, label: {
                    VStack {
                        Text("\(Int(playerViewModel.BPM))")
                            .font(.largeTitle)
                            .foregroundColor(playerViewModel.mode == .running ? Color("Green") : .white)
                            .fontWeight(.bold)
                        Text("BPM")
                            .font(.footnote)
                            .foregroundColor(playerViewModel.mode == .running ? Color("Green") : .white)
                    }
                    .foregroundColor(.white)
                })
                .matchedGeometryEffect(id: "BPM", in: namespace)

                Image(systemName: "poweron")
                    .font(.largeTitle)
                    .foregroundColor(playerViewModel.mode == .running ? Color("MainHighlight") : .white)
                VStack {
                    Text("\(playerViewModel.heartRate)")
                        .font(.largeTitle)
                        .foregroundColor(playerViewModel.mode == .running ? Color("Main") : .white)
                        .fontWeight(.bold)
                    Text("Heart rate")
                        .font(.footnote)
                        .foregroundColor(playerViewModel.mode == .running ? Color("Main") : .white)
                }
                .foregroundColor(.white)
                if playerViewModel.mode == .running {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                        .scaleEffect(animationAmount)
                        .animation(
                            .linear(duration: 0.1)
                                .delay(0.2)
                                .repeatForever(autoreverses: true),
                            value: animationAmount)
                        .onAppear {
                            animationAmount = 1.2
                        }
                } else {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
                Spacer()
            }
            Spacer()
            Button(action: {
                playerViewModel.tapOnStartButton()
            }, label: {
                Image(systemName: playerViewModel.mode == .stopped ? "play.circle.fill" : "pause.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(playerViewModel.mode == .running ? Color("Green") : .white)
                    .font(.largeTitle)
                    
            })
            .matchedGeometryEffect(id: "PlayButton", in: namespace)

            Spacer()
        }
        .background(.black)
    }
}
