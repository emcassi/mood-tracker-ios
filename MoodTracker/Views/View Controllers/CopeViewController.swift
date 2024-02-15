//
//  CopeViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/10/24.
//

import Foundation
import UIKit

class CopeViewController : UIViewController {
    
    let breatheButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Breathe", for: .normal)
        button.setTitleColor(UIColor(named: "info"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(named: "panel-color")
        button.setImage(UIImage(systemName: "wind", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .medium)), for: .normal)
        button.imageView?.tintColor = UIColor(named: "info")
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(named: "panel-color")?.cgColor
        button.layer.borderWidth = 3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 15
        button.addTarget(self, action: #selector(breathePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sensesButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Sense", for: .normal)
        button.setTitleColor(UIColor(named: "info"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(named: "panel-color")
        button.setImage(UIImage(systemName: "hand.point.up.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .medium)), for: .normal)
        button.imageView?.tintColor = UIColor(named: "info")
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(named: "panel-color")?.cgColor
        button.layer.borderWidth = 3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 15
        button.addTarget(self, action: #selector(sensePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let distractButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Distract", for: .normal)
        button.setTitleColor(UIColor(named: "info"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(named: "panel-color")
        button.setImage(UIImage(systemName: "brain.filled.head.profile", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .medium)), for: .normal)
        button.imageView?.tintColor = UIColor(named: "info")
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(named: "panel-color")?.cgColor
        button.layer.borderWidth = 3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 15
        button.addTarget(self, action: #selector(distractPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        
        view.addSubview(breatheButton)
        view.addSubview(sensesButton)
        view.addSubview(distractButton)
        
        breatheButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        breatheButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        breatheButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        breatheButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        sensesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sensesButton.topAnchor.constraint(equalTo: breatheButton.bottomAnchor, constant: 15).isActive = true
        sensesButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        sensesButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        distractButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        distractButton.topAnchor.constraint(equalTo: sensesButton.bottomAnchor, constant: 15).isActive = true
        distractButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        distractButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func breathePressed() {
        navigationController?.pushViewController(BreatheViewController(), animated: true)
    }
    
    @objc func sensePressed() {
        navigationController?.pushViewController(SenseViewController(), animated: true)
    }
    
    @objc func distractPressed() {
        navigationController?.pushViewController(BreatheViewController(), animated: true)
    }
}
