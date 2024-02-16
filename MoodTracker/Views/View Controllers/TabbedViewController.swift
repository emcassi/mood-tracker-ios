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
        view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 128, height: 50))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeViewController()
        home.tabBarItem.title = "Journal"
        home.tabBarItem.image = UIImage(systemName: "text.book.closed.fill")
        let learn = LearnViewController()
        learn.tabBarItem.title = "Learn"
        learn.tabBarItem.image = UIImage(systemName: "graduationcap.fill")
        let cope = CopeViewController()
        cope.tabBarItem.title = "Cope"
        cope.tabBarItem.image = UIImage(systemName: "heart.fill")
        let affirm = AffirmationsViewController()
        affirm.tabBarItem.title = "Wisdom"
        affirm.tabBarItem.image = UIImage(systemName: "quote.closing")
        
        viewControllers = [ home, learn, cope, affirm ]
        navigationItem.title = "Mudi"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsPressed))
        navigationItem.titleView = brandView
        tabBar.tintColor = UIColor(named: "info")
    }
    
    @objc func settingsPressed() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
