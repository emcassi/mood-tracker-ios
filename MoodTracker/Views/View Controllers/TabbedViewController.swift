//
//  TabbedViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/10/24.
//

import Foundation
import UIKit

class TabbedViewController : UITabBarController {
    
    let brandView: UILabel = {
        let view = UILabel()
        view.text = "Mudi"
        view.font = UIFont(name: "Pacifico", size: 20)
        view.textColor = UIColor(named: "label")
        view.textAlignment = .center
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeViewController()
        home.tabBarItem.title = "Journal"
        home.tabBarItem.image = UIImage(systemName: "text.book.closed")
        home.tabBarItem.selectedImage = UIImage(systemName: "text.book.closed.fill")
        let cope = CopeViewController()
        cope.tabBarItem.title = "Cope"
        cope.tabBarItem.image = UIImage(systemName: "heart")
        cope.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        let goals = GoalsViewController()
        goals.tabBarItem.title = "Goals"
        goals.tabBarItem.image = UIImage(systemName: "trophy")
        goals.tabBarItem.selectedImage = UIImage(systemName: "trophy.fill")
        let learn = LearnViewController()
        learn.tabBarItem.title = "Learn"
        learn.tabBarItem.image = UIImage(systemName: "graduationcap")
        learn.tabBarItem.selectedImage = UIImage(systemName: "graduationcap.fill")
        let profile = SettingsViewController()
        profile.tabBarItem.title = "Profile"
        profile.tabBarItem.image = UIImage(systemName: "person")
        profile.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        viewControllers = [ home, cope, goals, learn, profile ]
        navigationItem.title = "Mudi"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsPressed))
        navigationItem.titleView = brandView
        tabBar.tintColor = UIColor(named: "label")
        self.selectedIndex = 2
    }
    
    @objc func settingsPressed() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
