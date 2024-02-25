//
//  CrisisManagementViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/24/24.
//

import Foundation
import UIKit

class CrisisManagementViewController : UIViewController {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "crisis")
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
        label.text = "Crisis Management"
        label.textColor = UIColor(named: "info")
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hotlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Need immediate help?"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "label")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hotlineButton: UIButton = {
        let button = UIButton()
        button.setTitle("Find a Hotline", for: .normal)
        button.setTitleColor(UIColor(named: "label"), for: .normal)
        button.backgroundColor = UIColor(named: "panel-color")
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hotlineButton.addTarget(self, action: #selector(hotlinePressed), for: .touchUpInside)
        
        view.backgroundColor = UIColor(named: "bg-color")
        view.addSubview(imageView)
        view.addSubview(separator)
        view.addSubview(titleLabel)
        view.addSubview(hotlineLabel)
        view.addSubview(hotlineButton)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        separator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        separator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 3).isActive = true

        hotlineLabel.leftAnchor.constraint(equalTo: separator.leftAnchor).isActive = true
        hotlineLabel.rightAnchor.constraint(equalTo: separator.rightAnchor).isActive = true
        hotlineLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 30).isActive = true

        hotlineButton.leftAnchor.constraint(equalTo: hotlineLabel.leftAnchor, constant: 30).isActive = true
        hotlineButton.rightAnchor.constraint(equalTo: hotlineLabel.rightAnchor, constant: -30).isActive = true
        hotlineButton.topAnchor.constraint(equalTo: hotlineLabel.bottomAnchor, constant: 5).isActive = true
        hotlineButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func hotlinePressed() {
        let urlString = "https://findahelpline.com/"
        if let url = URL(string: urlString) {
            // Check if the application can open the URL
            if UIApplication.shared.canOpenURL(url) {
                // Open the URL
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
