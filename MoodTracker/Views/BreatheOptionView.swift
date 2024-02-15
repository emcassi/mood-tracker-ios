//
//  BreatheOptionView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/14/24.
//

import Foundation
import UIKit

class BreatheOptionView: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "info")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let input: TextField = {
        let input = TextField()
        input.textField.keyboardType = .numberPad
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        
        addSubview(label)
        addSubview(input)
        setupSubviews()
    }
    
    func setupSubviews() {
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        input.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        input.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        input.widthAnchor.constraint(equalToConstant: 100).isActive = true
        input.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
