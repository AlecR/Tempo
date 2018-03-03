import Foundation
import WatchKit
import AVFoundation

class AudioManager {
    
    static let shared = AudioManager()
    var audioPlayer = AVAudioPlayer()
    
    private init() {}
    
    func preparePlayer() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .duckOthers)
        } catch {
            print("🔊 Audio Session couldn't be created")
        }
        
        do {
            try audioSession.setActive(true)
        } catch {
            print("🔊 Audio Session couldn't be activated")
        }
    }
    
    func playBeep() {
        if let audioFile = Bundle.main.url(forResource: "beep", withExtension: "wav") {
            try! audioPlayer = AVAudioPlayer(contentsOf: audioFile)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
}
