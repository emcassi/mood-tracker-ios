//
//  LearnManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/15/24.
//

import Foundation
import UIKit
import MarkdownKit

struct LearnItem {
    let id: Int
    let name: String
    var completed = false
    let image: UIImage?
    let filename: String
}

class LearnManager {
    static let items = [
        LearnItem(id: 1, name: "Pain vs. Suffering", completed: false, image: nil, filename: "Pain-vs-Suffering"),
        LearnItem(id: 2, name: "Be Mindful", completed: false, image: nil, filename: "Be-Mindful"),
        LearnItem(id: 3, name: "Wise Mind", completed: false, image: UIImage(named: "wise-mind"), filename: "Wise-Mind"),
        LearnItem(id: 4, name: "GIVE", completed: false, image: nil, filename: "GIVE"),
        LearnItem(id: 5, name: "FAST", completed: false, image: nil, filename: "FAST"),
        LearnItem(id: 6, name: "Window of Tolerance", completed: false, image: UIImage(named: "window-of-tolerance"), filename: "Window-of-Tolerance"),
        LearnItem(id: 7, name: "Radical Acceptance", completed: false, image: UIImage(named: "circles-of-control"), filename: "Radical-Acceptance"),
        LearnItem(id: 8, name: "Urge Surfing", completed: false, image: UIImage(named: "urge-surfing"), filename: "Urge-Surfing"),
        LearnItem(id: 9, name: "Attending to Relationships", completed: false, image: nil, filename: "Attend-To-Relationships"),
    ]
    
    static func getContent(item: LearnItem, completion: (_ contents: String) -> Void) {
        if let filepath = Bundle.main.path(forResource: item.filename, ofType: "md") {
            do {
                let contents = try String(contentsOfFile: filepath)
                completion(contents)
            } catch {
                // Contents could not be loaded
                print("Error loading file")
            }
        } else {
            // File not found
            print("File not found")
        }
    }
}
