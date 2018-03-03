import UserNotifications

class LocalNotificationManager {
    
    static let shared = LocalNotificationManager()
    
    private init() {}
    
    func scheduleSoundNotifications(withSecondsInterval interval: TimeInterval) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = UNNotificationSound(named: "beep.wav")
        
        let triggerTime = Date().millisecondsSince1970 + Int(interval * 1000)
        var dateInfo = DateComponents()
        dateInfo.second = triggerTime / 60
        dateInfo.nanosecond = (triggerTime % 60) * 1000000
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateInfo,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "TimerIntervalBeep",
            content: notificationContent,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
}
