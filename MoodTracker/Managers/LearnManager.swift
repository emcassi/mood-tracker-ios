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
        LearnItem(id: 1, name: "Be Mindful", completed: false, image: nil, filename: "Be-Mindful"),
        LearnItem(id: 2, name: "Wise Mind", completed: false, image: UIImage(named: "wise-mind"), filename: "Wise-Mind"),
        LearnItem(id: 3, name: "GIVE", completed: false, image: nil, filename: "GIVE"),
        LearnItem(id: 4, name: "FAST", completed: false, image: nil, filename: "FAST"),
        LearnItem(id: 5, name: "Window of Tolerance", completed: false, image: UIImage(named: "window-of-tolerance"), filename: "Window-of-Tolerance"),
        LearnItem(id: 6, name: "Radical Acceptance", completed: false, image: UIImage(named: "circles-of-control"), filename: "Radical-Acceptance"),
    ]
    
    static func getContent(item: LearnItem, completion: (_ contents: String) -> Void) {
        print("\(item.filename).md")
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
