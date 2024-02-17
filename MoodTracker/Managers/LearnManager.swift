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
        LearnItem(id: 0, name: "What is DBT?", completed: false, image: nil, filename: "What is DBT?"),
        LearnItem(id: 1, name: "Be Mindful", completed: false, image: nil, filename: "Be-Mindful"),
        LearnItem(id: 2, name: "Observing Thoughts", completed: false, image: nil, filename: "Observing Thoughts"),
        LearnItem(id: 3, name: "Describing Emotions", completed: false, image: nil, filename: "Describing Emotions"),
        LearnItem(id: 4, name: "Participating Fully", completed: false, image: nil, filename: "Participating Fully"),
        LearnItem(id: 5, name: "Mindful Breathing", completed: false, image: nil, filename: "Mindful Breathing"),
        LearnItem(id: 6, name: "Mindful Walking", completed: false, image: nil, filename: "Mindful Walking"),
        LearnItem(id: 7, name: "Wise Mind", completed: false, image: UIImage(named: "wise-mind"), filename: "Wise-Mind"),
        LearnItem(id: 8, name: "Non-judgmental Stance", completed: false, image: nil, filename: "Non-judgmental Stance"),
        LearnItem(id: 9, name: "Effectiveness", completed: false, image: nil, filename: "Effectiveness"),
        LearnItem(id: 10, name: "Mindfulness in Daily Life", completed: false, image: nil, filename: "Mindfulness in Daily Life"),
        
        LearnItem(id: 11, name: "Understanding Distress Tolerance", completed: false, image: nil, filename: "Understanding Distress Tolerance"),
        LearnItem(id: 12, name: "Radical Acceptance", completed: false, image: UIImage(named: "circles-of-control"), filename: "Radical-Acceptance"),
        LearnItem(id: 13, name: "Window of Tolerance", completed: false, image: UIImage(named: "window-of-tolerance"), filename: "Window-of-Tolerance"),
        LearnItem(id: 14, name: "Pain vs. Suffering", completed: false, image: nil, filename: "Pain-vs-Suffering"),
        LearnItem(id: 15, name: "Urge Surfing", completed: false, image: UIImage(named: "urge-surfing"), filename: "Urge-Surfing"),
        
        LearnItem(id: 16, name: "GIVE", completed: false, image: nil, filename: "GIVE"),
        LearnItem(id: 17, name: "FAST", completed: false, image: nil, filename: "FAST"),
        LearnItem(id: 18, name: "Attending to Relationships", completed: false, image: nil, filename: "Attend-To-Relationships"),
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
