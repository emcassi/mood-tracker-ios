//
//  BreatheOptionsViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/14/24.
//

import Foundation
import UIKit
import FirebaseFirestore

class BreatheOptionsViewController: UIViewController {
    
    let pullBar: ModalPullBar = {
        let view = ModalPullBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inhaleView: BreatheOptionView = {
        let view = BreatheOptionView()
        view.label.text = "Inhale Time (sec.)"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let exhaleView: BreatheOptionView = {
        let view = BreatheOptionView()
        view.label.text = "Exhale Time (sec.)"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let holdView: BreatheOptionView = {
        let view = BreatheOptionView()
        view.label.text = "Hold Time (sec.)"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor(named: "label"), for: .normal)
        button.backgroundColor = UIColor(named: "panel-color")
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        
        if AuthManager.user == nil {
            AuthManager().logout()
            return
        }
        
        let viewTapGR = UITapGestureRecognizer(target: self, action: #selector(viewPressed))
        view.addGestureRecognizer(viewTapGR)
        
        view.addSubview(pullBar)
        view.addSubview(inhaleView)
        view.addSubview(exhaleView)
        view.addSubview(holdView)
        view.addSubview(saveButton)
        
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        inhaleView.input.textField.text = "\(AuthManager.user!.breathOptions.inhaleLength)"
        exhaleView.input.textField.text = "\(AuthManager.user!.breathOptions.exhaleLength)"
        holdView.input.textField.text = "\(AuthManager.user!.breathOptions.holdLength)"
        
        setupSubviews()
    }
    
    func setupSubviews() {
        pullBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        pullBar.widthAnchor.constraint(equalToConstant: 64).isActive = true
        pullBar.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        inhaleView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        inhaleView.topAnchor.constraint(equalTo: pullBar.bottomAnchor, constant: 30).isActive = true
        inhaleView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        inhaleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        exhaleView.leftAnchor.constraint(equalTo: inhaleView.leftAnchor).isActive = true
        exhaleView.topAnchor.constraint(equalTo: inhaleView.bottomAnchor).isActive = true
        exhaleView.rightAnchor.constraint(equalTo: inhaleView.rightAnchor).isActive = true
        exhaleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        holdView.leftAnchor.constraint(equalTo: exhaleView.leftAnchor).isActive = true
        holdView.topAnchor.constraint(equalTo: exhaleView.bottomAnchor).isActive = true
        holdView.rightAnchor.constraint(equalTo: exhaleView.rightAnchor).isActive = true
        holdView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func viewPressed() {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
    }
    
    @objc func savePressed() {
        save()
    }
    
    func save() {
        let options = BreathOptions(inhaleLength: Int(inhaleView.input.textField.text ?? "") ?? Defaults.breathInhaleLength, exhaleLength: Int(exhaleView.input.textField.text ?? "") ?? Defaults.breathExhaleLength, holdLength: Int(holdView.input.textField.text ?? "") ?? Defaults.breathHoldLength)
        if options == AuthManager.user?.breathOptions {
            self.dismiss(animated: true)
            return
        }
        
        BreathManager.saveBreathSettings(options: options) {
            self.dismiss(animated: true)
        }
    }
}
