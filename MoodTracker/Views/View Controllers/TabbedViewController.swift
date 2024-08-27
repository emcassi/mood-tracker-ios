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
		cope.tabBarItem.image = UIImage(systemName: "heart.circle")
		cope.tabBarItem.selectedImage = UIImage(systemName: "heart.circle.fill")
		let settings = SettingsViewController()
		settings.tabBarItem.title = "About"
		settings.tabBarItem.image = UIImage(systemName: "info.circle")
		settings.tabBarItem.selectedImage = UIImage(systemName: "info.circle.fill")
		
		viewControllers = [ home, cope, settings ]
		navigationItem.title = "Mudi"
		navigationItem.titleView = brandView
		tabBar.tintColor = UIColor(named: "label")
		self.selectedIndex = 0
	}
}
