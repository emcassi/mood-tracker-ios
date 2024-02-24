//
//  ProsConsManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation

class ProsConsManager {
    
    static func setup(_ items: [ProsCons]) {
        AuthManager.user?.prosCons = items
    }
    
    static func new(item: ProsCons) {
        AuthManager.user?.prosCons.append(item)
    }
    
    static func updateTitle(id: String, title: String) -> Bool {
        guard let user = AuthManager.user else {
            return false
        }
        
        guard let index = user.prosCons.firstIndex(where: { $0.id == id}) else {
            return false
        }
        
        AuthManager.user?.prosCons[index].title = title
        return true
    }
}
