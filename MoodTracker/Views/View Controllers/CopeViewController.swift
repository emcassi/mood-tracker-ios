//
//  CopeViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/10/24.
//

import Foundation
import UIKit

class CopeViewController : UIViewController {
	
	let scrollView: UIScrollView = {
		let sv = UIScrollView()
		sv.backgroundColor = UIColor(named: "bg-color")
		sv.translatesAutoresizingMaskIntoConstraints = false
		return sv
	}()
	
	let imageView: UIImageView = {
		let view = UIImageView()
		view.image = UIImage(named: "cope")
		view.contentMode = .scaleAspectFit
		view.layer.cornerRadius = 15
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let separator: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(named: "panel-color")
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Coping Skills"
		label.textColor = UIColor(named: "info")
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let breatheButton: CopingSkillView = {
		let view = CopingSkillView(title: "Breathe", icon: "wind")
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let crisisButton: CopingSkillView = {
		let view = CopingSkillView(title: "Crisis Management", icon: "light.beacon.max.fill")
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let wisdomButton: CopingSkillView = {
		let view = CopingSkillView(title: "Words of Wisdom", icon: "quote.closing")
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(named: "bg-color")
		
		view.addSubview(scrollView)
		scrollView.addSubview(imageView)
		scrollView.addSubview(titleLabel)
		scrollView.addSubview(separator)
		scrollView.addSubview(breatheButton)
		scrollView.addSubview(crisisButton)
		scrollView.addSubview(wisdomButton)
		
		breatheButton.addTarget(self, action: #selector(breathePressed), for: .touchUpInside)
		crisisButton.addTarget(self, action: #selector(crisisPressed), for: .touchUpInside)
		wisdomButton.addTarget(self, action: #selector(wisdomPressed), for: .touchUpInside)
		
		scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		
		imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
		imageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: 128).isActive = true
		
		titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
		titleLabel.widthAnchor.constraint(equalToConstant: 128).isActive = true
		titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
		
		separator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
		separator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
		separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
		separator.heightAnchor.constraint(equalToConstant: 3).isActive = true
		
		breatheButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
		breatheButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
		breatheButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15).isActive = true
		breatheButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
		
		wisdomButton.leftAnchor.constraint(equalTo: breatheButton.leftAnchor).isActive = true
		wisdomButton.rightAnchor.constraint(equalTo: breatheButton.rightAnchor).isActive = true
		wisdomButton.topAnchor.constraint(equalTo: breatheButton.bottomAnchor, constant: 15).isActive = true
		wisdomButton.heightAnchor.constraint(equalTo: breatheButton.heightAnchor).isActive = true
		
		crisisButton.leftAnchor.constraint(equalTo: breatheButton.leftAnchor).isActive = true
		crisisButton.rightAnchor.constraint(equalTo: breatheButton.rightAnchor).isActive = true
		crisisButton.topAnchor.constraint(equalTo: wisdomButton.bottomAnchor, constant: 15).isActive = true
		crisisButton.heightAnchor.constraint(equalTo: breatheButton.heightAnchor).isActive = true
		crisisButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -15).isActive = true
		
	}
	
	@objc func breathePressed() {
		navigationController?.pushViewController(BreatheViewController(), animated: true)
	}
	
	@objc func wisdomPressed() {
		navigationController?.pushViewController(AffirmationsViewController(), animated: true)
	}
	
	@objc func crisisPressed() {
		let alert = UIAlertController(title: "Need Immediate Help?", message: "If you're in crisis, contact a hotline for immediate assistance.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Find a Hotline", style: .default, handler: { action in
			let urlString = "https://findahelpline.com/"
			if let url = URL(string: urlString) {
				// Check if the application can open the URL
				if UIApplication.shared.canOpenURL(url) {
					// Open the URL
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}
	
}
