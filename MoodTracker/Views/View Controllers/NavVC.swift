//
//  NavVC.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/6/22.
//

import Foundation
import UIKit
import FirebaseAuth

class NavVC: UINavigationController {
    
    let authManager = AuthManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        authManager.setListener(navVC: self)
        navigationBar.tintColor = UIColor(named: "info")
    }
    
}
