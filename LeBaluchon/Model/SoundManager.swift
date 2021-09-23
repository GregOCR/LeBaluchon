//
//  Sound.swift
//  LeBaluchon
//
//  Created by Greg on 08/09/2021.
//

import AVFoundation

struct SoundManager {
    
    static var soundToPlay: AVAudioPlayer?
    
    enum SoundType: String {
        case Printer = "printer.mp3"
        case Paper = "paper.mp3"
        case Woop = "woop.mp3"
    }
    
    static func play(_ soundName: SoundType) {        
        let path = Bundle.main.path(forResource: soundName.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            self.soundToPlay = try AVAudioPlayer(contentsOf: url)
            self.soundToPlay?.play()
        } catch {
        }
    }
    
    static func stop() {
        self.soundToPlay?.stop()
    }
    
    static func initialize() {
        self.play(.Woop)
        self.stop()
    }
}
