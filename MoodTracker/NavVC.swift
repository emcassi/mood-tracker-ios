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
   
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.popToRootViewController(animated: false)
            } else {
                self.pushViewController(WelcomeViewController(), animated: true)
            }
        }
    }
    
}
