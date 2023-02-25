//
//  SettingsViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/7/22.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(UIColor(named: "bg-color"), for: .normal)
        button.addTarget(self, action: #selector(privacyPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(UIColor(named: "bg-color"), for: .normal)
        button.addTarget(self, action: #selector(signOutPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Account", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteAccountPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        
        
        view.addSubview(privacyButton)
        view.addSubview(signOutButton)
        view.addSubview(deleteAccountButton)
        
        setupSubviews()
    }
    
    func setupSubviews(){
        setupPrivacyButton()
        setupSignoutButton()
        setupDeleteAccountButton()
    }
    
    func setupPrivacyButton(){

        privacyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true
        privacyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        privacyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        privacyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupSignoutButton(){
        signOutButton.topAnchor.constraint(equalTo: privacyButton.bottomAnchor, constant: 50).isActive = true
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupDeleteAccountButton(){
        deleteAccountButton.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 10).isActive = true
        deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        deleteAccountButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    
    @objc func privacyPressed(){
        if let url = URL(string: "https://alexwayne.org/apps/mood-tracker/privacypolicy.html") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func signOutPressed(){
        AuthManager().logout()
    }
    
    @objc func deleteAccountPressed(){
        self.navigationController?.pushViewController(DeleteAccountViewController(), animated: true)
    }
}
