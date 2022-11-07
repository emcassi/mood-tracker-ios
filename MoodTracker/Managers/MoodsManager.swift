//
//  MoodsManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/7/22.
//

import Foundation
import UIKit

class MoodsManager {
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
}
