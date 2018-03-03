import UIKit

protocol TempoTimerDelegate: class {
    func timerDidFire(withCounter counter: Double)
}

class TempoTimer {
    
    static let shared = TempoTimer()
    
    private var timer: Timer!
    var delegate: TempoTimerDelegate?
    var counter = 0.0
    
    private var timeWhenBackgrounded: Date?
    
    private init () {}
    
    func start() {
        guard delegate != nil else {
            print("⏱ TempoTime delegate not set!")
            return
        }

        timer = Timer.scheduledTimer(
            withTimeInterval: 0.01,
            repeats: true,
            block: { _ in
                self.counter += 0.01
                self.delegate!.timerDidFire(withCounter: self.counter)
            }
        )
        timer.fire()
    }
    
    func stop() {
        guard timer != nil else { return }
        timer.invalidate()
    }
    
    func resetTimer() {
        if timer != nil {
            timer.invalidate()
        }
        counter = 0.0
    }
    
    func appWasBackgrounded() {
        guard delegate != nil else {
            print("⏱ TempoTime delegate not set!")
            return
        }
        timeWhenBackgrounded = Date()
    }
    
    func updateTimeFromBackgrounded() {
        guard delegate != nil, timeWhenBackgrounded != nil else {
            print("⏱ TempoTime delegate or timeWhenBackgrounded not set!")
            return
        }

        let duration = Date().timeIntervalSince(timeWhenBackgrounded!).rounded(toPlaces: 2)
        counter += duration
        timeWhenBackgrounded = nil
    }
    
}
