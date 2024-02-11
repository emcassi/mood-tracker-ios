//
//  MoodsManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/7/22.
//

import Foundation
import UIKit

class MoodsManager {
    
    static let categories = [ "Sad", "Fearful", "Disgusted", "Angry", "Happy", "Surprised" ]
    
    func makeMoodsString(moods: [Mood]) -> String {
        
        var moodsString = ""
        
        for mood in moods {
            moodsString.append("\(mood.name), ")
        }
        
        if moodsString.count > 0 {
            if let index = moodsString.lastIndex(of: ",") {
                moodsString = String(moodsString.prefix(upTo: index))
            }
        }
        
        return moodsString
    }
    
    func prepareMoodsForFirebase(moods: [Mood]) -> [[String: String]]{
        var preparedMoods: [[String: String]] = []
        for mood in moods {
            preparedMoods.append([
                "name": mood.name,
                "section": mood.section
            ])
        }
        
        return preparedMoods
    }
    
    static func getColorForMood(category: String) -> UIColor {
        switch category {
        case "Sad":
            return UIColor(named: "mood-sad")!
        case "Fearful":
            return UIColor(named: "mood-fearful")!
        case "Disgusted":
            return UIColor(named: "mood-disgusted")!
        case "Angry":
            return UIColor(named: "mood-angry")!
        case "Happy":
            return UIColor(named: "mood-happy")!
        case "Surprised":
            return UIColor(named: "mood-surprised")!
        default:
            return UIColor(gray: 117)
        }
    }
}
