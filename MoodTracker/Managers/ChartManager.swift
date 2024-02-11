//
//  ChartManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/10/24.
//

import Foundation
import UIKit
import Charts

class ChartManager {
    
    static func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for category in MoodsManager.categories {
            switch category {
            case "Sad":
                colors.append(UIColor(named: "mood-sad")!)
            case "Fearful":
                colors.append(UIColor(named: "mood-fearful")!)
            case "Disgusted":
                colors.append(UIColor(named: "mood-disgusted")!)
            case "Angry":
                colors.append(UIColor(named: "mood-angry")!)
            case "Happy":
                colors.append(UIColor(named: "mood-happy")!)
            case "Surprised":
                colors.append(UIColor(named: "mood-surprised")!)
            default:
                break
            }
        }
        
        return colors
    }
}
