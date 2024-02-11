//
//  TabbedViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/10/24.
//

import Foundation
import UIKit

class TabbedViewController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeViewController()
        home.tabBarItem.title = "Journal"
        home.tabBarItem.image = UIImage(systemName: "text.book.closed.fill")
        let cope = CopeViewController()
        cope.tabBarItem.title = "Cope"
        cope.tabBarItem.image = UIImage(systemName: "heart.fill")
        let affirm = AffirmationsViewController()
        affirm.tabBarItem.title = "Wisdom"
        affirm.tabBarItem.image = UIImage(systemName: "quote.closing")
        
        viewControllers = [ home, cope, affirm ]
        navigationItem.title = "Mudi"
        tabBar.tintColor = UIColor(named: "info")
    }
}
