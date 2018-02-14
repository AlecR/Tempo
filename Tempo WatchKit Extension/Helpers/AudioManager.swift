import Foundation
import WatchKit

class AudioManager {
    
    static let shared = AudioManager()
    
    func playBeep() {
        if let url = Bundle.main.url(forResource: "beep", withExtension: "wav") {
            let asset = WKAudioFileAsset(url: url)
            let playerItem = WKAudioFilePlayerItem(asset: asset)
            let player = WKAudioFilePlayer(playerItem: playerItem)
            if player.status == .readyToPlay {
                DispatchQueue.main.async {
                    player.play()
                    print("PLAYED")
                }
            }
        }
    }
}
