//
//  Sound.swift
//  LeBaluchon
//
//  Created by Greg on 08/09/2021.
//

import AVFoundation

class SoundManager {
    init() {
        
        var audioPlayers: [SoundType: AVAudioPlayer?] = [:]
        
        for soundType in SoundType.allCases {
            let audioPlayer = createAudioPlayerFrom(soundType: soundType)
            
            audioPlayers[soundType] = audioPlayer
        }
        
        self.audioPlayers = audioPlayers
    }
    
    
    private func createAudioPlayerFrom(soundType: SoundType) -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: soundType.rawValue, ofType: nil) else { return  nil}
        let url = URL(fileURLWithPath: path)
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url) else { return nil }
        audioPlayer.prepareToPlay()
        return audioPlayer
    }
    

    static let shared = SoundManager()
    
    private var audioPlayers: [SoundType: AVAudioPlayer?] = [:]
    
    

    
    
    enum SoundType: String, CaseIterable {
        case Printer = "printer.mp3"
        case Paper = "paper.mp3"
        case Woop = "woop.mp3"
    }
    
    func play(_ soundName: SoundType) {
        guard let audioPlayer = audioPlayers[soundName] else { return }
        audioPlayer?.play()
    }
}

