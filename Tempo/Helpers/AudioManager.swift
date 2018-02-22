import AVFoundation

class AudioManager {
    
    static let shared = AudioManager()
    
    var player: AVAudioPlayer?
    
    func playBeep() {
        guard let fileUrl = Bundle.main.url(forResource: "beep", withExtension: "wav") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: fileUrl, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else {
                return
            }
            DispatchQueue.global().async {
                player.play()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
