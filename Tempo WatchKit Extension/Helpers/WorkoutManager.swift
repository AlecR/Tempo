import Foundation
import HealthKit

class WorkoutManager: NSObject {
    
    static let shared = WorkoutManager()
    
    var healthStore: HKHealthStore?
    var currentSession: HKWorkoutSession?
    
    func startWorkout() {
        
        guard currentSession == nil else {
            print("🏃🏼‍♂️ Tried to start but session already in progress")
            return
        }
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .unknown
        
        do {
            currentSession = try HKWorkoutSession(configuration: configuration)
            currentSession!.delegate = self
            healthStore = HKHealthStore()
            healthStore?.start(currentSession!)
            print("🏃🏼‍♂️ Starting Workout")
        }
        catch let error as NSError {
            print("🏃🏼‍♂️ *** Unable to create workout session ***\n\(error.localizedDescription)")
        }
    }
    
    func endWorkout() {
        if healthStore != nil && currentSession != nil{
            print("🏃🏼‍♂️ Ending Workout ")
            self.healthStore!.end(currentSession!)
            self.currentSession = nil
        } else {
            print("🏃🏼‍♂️ Tried to end workout but no session in progress")
        }
    }
    
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
}
