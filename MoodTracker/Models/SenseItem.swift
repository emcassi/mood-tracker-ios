//
//  SenseItem.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/11/24.
//

import Foundation

enum Sense: String {
	case Touch = "touch"
	case Sight = "sight"
	case Sound = "sound"
	case Taste = "taste"
	case Smell = "smell"
}

struct SenseItem {
	let item: String
	let timestamp: Date
}
