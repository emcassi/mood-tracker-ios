//
//  ProsCons.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation

struct ProsConsItem {
    let id: String
    let title: String
    let date: Date
}

struct ProsCons {
    let id: String
    var title: String
    var pros: [ProsConsItem]
    var cons: [ProsConsItem]
    let createdAt: Date
    var updatedAt: Date
}
