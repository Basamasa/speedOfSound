//
//  MetroViewModel.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 23.04.22.
//

import AVFoundation
import Combine
import WatchConnectivity
import CoreMotion

enum FeedbackType: Int {
    case notification = 0
    case sound = 1
}

class PlayerViewModel: ObservableObject, MetronomeDelegate {
    // BPM metronome
    @Published var mode:isMetroRunning = .stopped
    @Published var effectIndex = 0
    @Published var effect = ["1","2","3","4","5","6","7","8"]
    @Published var BPM: Double = 120
    @Published var speedString = "Allegro"
    let myMetronome: MetronomeModel

    // Popups
    @Published var showGif: Bool = false
    @Published var showPlayer: Bool = false
    @Published var showNotificationPickerView: Bool = false
    @Published var showSoundPickerView: Bool = false
    
    @Published var lowBPM: Int = 120
    @Published var highBPM: Int = 140
    var timer = Timer()

    // Heart rate session
    var wcSession: WCSession
    let delegate: WCSessionDelegate
    let subject1 = PassthroughSubject<Int, Never>()
    let subject2 = PassthroughSubject<Int, Never>()
    @Published private(set) var count: Int = 0
    @Published private(set) var sessionWorkout: Int = 0
    
    // Pedometer(Cadence)
    let pedometer = CMPedometer()
    var cadence: Double = 0
    @Published var showCadenceView: Bool =  false
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject1, sessionWorkoutSubject: subject2)
        self.wcSession = session
        self.wcSession.delegate = self.delegate
        self.wcSession.activate()
           
        myMetronome = MetronomeModel(audioFormat: AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!)

        subject1
            .receive(on: DispatchQueue.main)
            .assign(to: &$count)
        
        subject2
            .receive(on: DispatchQueue.main)
            .assign(to: &$sessionWorkout)
    }
    
    // MARK: - Cadence
    
    var isCadenceAvailable : Bool{
        get{
            return CMPedometer.isCadenceAvailable()
        }
    }
    
    func sendWorkoutToWatch() {
        var feedbackMessage: String?

        if showSoundPickerView && !showNotificationPickerView {
            feedbackMessage = "1"
        } else if !showSoundPickerView && showNotificationPickerView {
            feedbackMessage = "0"
        }
        guard let firstMessage = feedbackMessage else {return }

        let message = firstMessage + "\(lowBPM)" + "\(highBPM)" + "\(Int(cadence))"
        
        if wcSession.isReachable {
            timer.invalidate()
            wcSession.sendMessage(["workoutMessage": message], replyHandler: nil) { error in
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Metronome
    
    // Delegate function
    func metronomeTicking(_ metronome: MetronomeModel, currentTick: Int) {
    }
    
    func start() {
        if sessionWorkout == 1 {
            mode = .running
            try? myMetronome.start()
            showGif = false
            showPlayer = true
        }
    }
    
    func stop() {
        if sessionWorkout  == 0 {
            mode = .stopped
            myMetronome.stop()
            showPlayer = false
        }
    }
    
    func clickOnBPM() {
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
    
    func increaseByTen() {
        myMetronome.incrementTempo(by: 10)
        updateBpm()
    }
    
    func decreaseByTen() {
        myMetronome.incrementTempo(by: -10)
        updateBpm()
    }
    
    func runRestart() {
    }
    
    // MARK: - App state
    
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
    
    func tapOnNotificationFeedbackButton() {
        showGif = false
        showNotificationPickerView.toggle()
    }
    
    func tapOnSoundFeedbackButton() {
        showGif = false
        showSoundPickerView.toggle()
    }
    
    func tapOnStartSessionButton() {
        self.sendWorkoutToWatch()
        showNotificationPickerView = false
        showSoundPickerView = false
        showGif.toggle()
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
//        do {
//            player = try AVAudioPlayer(contentsOf: url!)
//            player?.play()
//        } catch {
//            print("\(error)")
//        }
    }
}
