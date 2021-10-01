//
//  Sound.swift
//  LeBaluchon
//
//  Created by Greg on 08/09/2021.
//

import AVFoundation

class SoundManager {

    static let shared = SoundManager()
    
    private var soundToPlay: AVAudioPlayer?
    
    enum SoundType: String {
        case Printer = "printer.mp3"
        case Paper = "paper.mp3"
        case Woop = "woop.mp3"
    }
    
    func play(_ soundName: SoundType) {
        let path = Bundle.main.path(forResource: soundName.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            self.soundToPlay = try AVAudioPlayer(contentsOf: url)
            self.soundToPlay?.play()
        } catch {
            return
        }
    }
}

