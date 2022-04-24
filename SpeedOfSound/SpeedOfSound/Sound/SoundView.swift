//
//  MetroView.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 23.04.22.
//

import SwiftUI
import AVFoundation

var player: AVAudioPlayer!

struct SoundView: View {
    
    @ObservedObject var metroViewModel = SoundViewModel()
    
    let colorGradient = LinearGradient(
        gradient: Gradient(colors: [Color.green, Color.clear]),
                            startPoint: .topLeading, endPoint: .bottomTrailing)
    let grayGradient = LinearGradient(
                            gradient: Gradient(colors: [Color(.systemGray4), Color(.systemGray4)]),
                            startPoint: .topLeading, endPoint: .bottomTrailing)
    let BPMtimer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                VStack {
                    HStack {
                        Image(systemName: "music.note")
                        Picker("Effect", selection: $metroViewModel.effectIndex) {
                            ForEach(0 ..< metroViewModel.effect.count, id:\.self) { index in
                                    Text(metroViewModel.effect[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: metroViewModel.effectIndex) { _ in
                            metroViewModel.runRestart()
                        }
                    }
                    HStack {
                        HStack {
                            Button(action: {
                                metroViewModel.clickOnMinusButton()
                            }, label: {
                                Circle()
                                    .fill(metroViewModel.mode == .stopped ? grayGradient : colorGradient)
                                    .overlay(
                                        Image(systemName: "minus.circle")
                                            .resizable()
                                            .frame(width: 90, height: 90)
                                            .foregroundColor(Color("ButtonAccent"))
                                            .font(Font.title.weight(.light)))
                            })
                            .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                                metroViewModel.longPressMinusTap()
                            })
                            
                            Button(action: {
                                metroViewModel.clickOnPlusButton()
                            }, label: {
                                Circle()
                                    .fill(metroViewModel.mode == .stopped ? grayGradient : colorGradient)
                                    .overlay(
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 90, height: 90)
                                            .foregroundColor(Color("ButtonAccent"))
                                            .font(Font.title.weight(.light)))
                            })
                            .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                                metroViewModel.longPressPlusTap()
                            })
                        }
                        .onChange(of: metroViewModel.BPM) { _ in
                            metroViewModel.bpmChange()
                            metroViewModel.runRestart()
                        }
                        Button(action: {
                            metroViewModel.clickOnHeart()
                        }, label: {
                            VStack {
                                Label(metroViewModel.speedString, systemImage: "metronome")
                                    .font(.footnote)
                                Text("\(Int(metroViewModel.BPM))")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text("BPM")
                                    .font(.footnote)
                            }
                            .foregroundColor(Color("ButtonAccent"))
                        })
                        Button(action: {
                            if metroViewModel.mode == .stopped {
                                metroViewModel.start(interval: 60/metroViewModel.BPM,
                                                     effect: metroViewModel.effectIndex,
                                                     time: Int(metroViewModel.beatsIndex))
                            } else {
                                metroViewModel.stop()
                            }
                        }, label: {
                            Image(systemName: metroViewModel.mode == .stopped ? "play.fill" : "pause.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color("ButtonAccent"))
                                .font(.largeTitle)
                                
                        })
                    }
                }
                .padding()
            }
            Spacer()
        }
        .frame(height: 180)
        .background(metroViewModel.mode == .stopped ? grayGradient : colorGradient)
        .cornerRadius(25.0)
        .shadow(color: Color.black.opacity(0.8), radius: 5, x: 0, y: 2)
        .onReceive(BPMtimer) { _ in metroViewModel.difference1 += 0.001}
        .padding()
    }
}

enum isMetroRunning {
    case running
    case stopped
}

