//
//  MetroViewModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 23.04.22.
//

import Foundation
import AVFoundation
import Combine

class MetronomeViewModel: ObservableObject, MetronomeDelegate {
    @Published var mode:isMetroRunning = .stopped
    @Published var effectIndex = 0
    @Published var effect = ["1","2","3","4","5","6","7","8"]
    @Published var wasRunning = false
    
    @Published var BPM: Double = 120
    @Published var speedString = "Allegro"
    @Published var isShowingSheet = false
    
    let myMetronome = Metronome(audioFormat: AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!)
    
    var pub1: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    }
    
    var pub: AnyPublisher<Void, Never> {
        Just(())
           .delay(for: .seconds(0.001), scheduler: DispatchQueue.main)
           .eraseToAnyPublisher()
    }
    
    var timer = Timer()
    
    func metronomeTicking(_ metronome: Metronome, currentTick: Int) {
    }
    
    func start() {
        mode = .running
        try? myMetronome.start()
    }
    
    func stop() {
        mode = .stopped
        myMetronome.stop()
    }
    
    func clickOnHeart() {
        BPM = 60
    }
    
    func tapOnStartButton() {
        if mode == .stopped {
            start()
        } else {
            stop()
        }
    }
    
    private func updateBpm() {
        BPM = Double(myMetronome.tempoBPM)
    }
    
    func bpmChange() {
        if(BPM <= 15) {
            BPM = 15
        }
        if(BPM >= 500) {
            BPM = 500
        }
        
        if(BPM >= 15) {
            speedString = "Grave"
        }
        if(BPM >= 40) {
            speedString = "Lento"
        }
        if(BPM >= 45) {
            speedString = "Largo"
        }
        if(BPM >= 55) {
            speedString = "Adagio"
        }
        if(BPM >= 65) {
            speedString = "Adagietto"
        }
        if(BPM >= 73) {
            speedString = "Andante"
        }
        if(BPM >= 86) {
            speedString = "Moderato"
        }
        if(BPM >= 98) {
            speedString = "Allegretto"
        }
        if(BPM >= 109) {
            speedString = "Allegro"
        }
        if(BPM >= 132) {
            speedString = "Vivace"
        }
        if(BPM >= 168) {
            speedString = "Presto"
        }
        if(BPM >= 178) {
            speedString = "Prestissimo"
        }
    }
    
    func clickOnMinusButton() {
        myMetronome.incrementTempo(by: -1)
        updateBpm()
    }
    
    func clickOnPlusButton() {
        myMetronome.incrementTempo(by: 1)
        updateBpm()
    }
    
    func runRestart() {
    }
    
    func soundViewAppear() {
        // Activate Audio Playback in Background
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            }
        catch let error {
            print("Error \(error.localizedDescription)")
        }
        myMetronome.delegate = self
        updateBpm()
    }
    
    func playSound(effect: Int) {
        var url = Bundle.main.url(forResource: "Mechanical metronome - High", withExtension: "aif")
        
        switch effect {
        case 0:
            url = Bundle.main.url(forResource: "Mechanical metronome - High", withExtension: "aif")
        case 1:
            url = Bundle.main.url(forResource: "Hi-hat", withExtension: "aif")
        case 2:
            url = Bundle.main.url(forResource: "Cowbell", withExtension: "aif")
        case 3:
            url = Bundle.main.url(forResource: "Bass drum", withExtension: "aif")
        case 4:
            url = Bundle.main.url(forResource: "Jack slap", withExtension: "aif")
        case 5:
            url = Bundle.main.url(forResource: "Mechanical metronome - Low", withExtension: "aif")
        case 6:
            url = Bundle.main.url(forResource: "Rimshot", withExtension: "aif")
        case 7:
            url = Bundle.main.url(forResource: "LAUGH!", withExtension: "aif")
        default:
            url = Bundle.main.url(forResource: "Mechanical metronome - High", withExtension: "aif")
        }
        
        guard url != nil else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        } catch {
            print("\(error)")
        }
    }
}
