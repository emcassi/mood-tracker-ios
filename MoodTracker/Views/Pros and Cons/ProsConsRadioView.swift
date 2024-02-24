//
//  ProsConsRadioView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation
import UIKit

class ProsConsRadioView: UIView {
    
    var isPro = true
    
    let proRadioButton: RadioButton = {
        let button = RadioButton(title: "Pro")
        button.setActive(true)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let conRadioButton: RadioButton = {
        let button = RadioButton(title: "Con")
        button.setActive(false)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)
        
        proRadioButton.addTarget(self, action: #selector(proPressed), for: .touchUpInside)
        conRadioButton.addTarget(self, action: #selector(conPressed), for: .touchUpInside)
        
        self.addSubview(proRadioButton)
        self.addSubview(conRadioButton)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        proRadioButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        proRadioButton.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -25).isActive = true
        proRadioButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        proRadioButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        conRadioButton.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 25).isActive = true
        conRadioButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        conRadioButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        conRadioButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func proPressed() {
        if self.isPro { return }
        self.isPro = true
        self.proRadioButton.setActive(true)
        self.conRadioButton.setActive(false)
    }
    
    @objc func conPressed() {
        if !self.isPro { return }
        self.isPro = false
        
        self.proRadioButton.setActive(false)
        self.conRadioButton.setActive(true)
    }
}
