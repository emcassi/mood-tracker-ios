//
//  BreathManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/14/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class BreathOptions: Equatable {
    static func == (lhs: BreathOptions, rhs: BreathOptions) -> Bool {
        if lhs.inhaleLength != rhs.inhaleLength {
            return false
        }
        if lhs.exhaleLength != rhs.exhaleLength {
            return false
        }
        if lhs.holdLength != rhs.holdLength {
            return false
        }
        return true
    }
    
    var inhaleLength = Defaults.breathInhaleLength
    var exhaleLength = Defaults.breathExhaleLength
    var holdLength = Defaults.breathHoldLength
    
    init(inhaleLength: Int, exhaleLength: Int, holdLength: Int) {
        self.inhaleLength = inhaleLength
        self.exhaleLength = exhaleLength
        self.holdLength = holdLength
    }
}

class BreathManager {
    
    static func startedBreathSession() {
        Firestore.firestore().collection("analytics").document("breathing-sessions").updateData([
            "started": FieldValue.increment(Int64(1))
        ])
    }
    
    static func finishedBreathSession() {
        Firestore.firestore().collection("analytics").document("breathing-sessions").updateData([
            "completed": FieldValue.increment(Int64(1))
        ])
    }
    
    static func saveBreathSettings(options: BreathOptions, completion: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        Firestore.firestore().collection("users").document(user.uid).setData([
            "inhale-length": options.inhaleLength,
            "exhale-length": options.exhaleLength,
            "hold-length": options.holdLength,
        ], merge: true) { error in
            if error != nil {
                print("Error saving breath options")
                return
            }
            AuthManager.user!.breathOptions = options
            completion()
        }
    }
}
