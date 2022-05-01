//
//  MetroView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 23.04.22.
//

import SwiftUI
import AVFoundation
import UIKit

var player: AVAudioPlayer!

struct SoundView: View {
    
    @EnvironmentObject var soundViewModel: MetronomeViewModel
    @StateObject var model = HeartRateViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Text("❤️ \(model.count)")
                    .font(.largeTitle)
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
                HStack {
                    HStack {
                        Button(action: {
                            soundViewModel.clickOnMinusButton()
                        }, label: {
                            Circle()
                                .fill(soundViewModel.mode == .stopped ? Colors.grayGradient : Colors.colorGradient)
                                .overlay(
                                    Image(systemName: "minus.circle")
                                        .resizable()
                                        .frame(width: 90, height: 90)
                                        .foregroundColor(Color("ButtonAccent"))
                                        .font(Font.title.weight(.light)))
                        })
                        
                        Button(action: {
                            soundViewModel.clickOnPlusButton()
                        }, label: {
                            Circle()
                                .fill(soundViewModel.mode == .stopped ? Colors.grayGradient : Colors.colorGradient)
                                .overlay(
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 90, height: 90)
                                        .foregroundColor(Color("ButtonAccent"))
                                        .font(Font.title.weight(.light)))
                        })
                    }
                    .onChange(of: soundViewModel.BPM) { _ in
                        soundViewModel.bpmChange()
                        soundViewModel.runRestart()
                    }
                    Button(action: {
                        soundViewModel.clickOnHeart()
                    }, label: {
                        VStack {
                            Label(soundViewModel.speedString, systemImage: "metronome")
                                .font(.footnote)
                            Text("\(Int(soundViewModel.BPM))")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("BPM")
                                .font(.footnote)
                        }
                        .foregroundColor(Color("ButtonAccent"))
                    })
                    Button(action: {
                        soundViewModel.tapOnStartButton()
                    }, label: {
                        Image(systemName: soundViewModel.mode == .stopped ? "play.fill" : "pause.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("ButtonAccent"))
                            .font(.largeTitle)
                            
                    })
                }
            }
            .padding()
        }
        .frame(height: 250)
        .background(soundViewModel.mode == .stopped ? Colors.grayGradient : Colors.colorGradient)
        .cornerRadius(25.0)
        .shadow(color: Color.black.opacity(0.8), radius: 5, x: 0, y: 2)
        .padding()
        .onAppear() {
            soundViewModel.soundViewAppear()
        }
    }
}

enum isMetroRunning {
    case running
    case stopped
}

