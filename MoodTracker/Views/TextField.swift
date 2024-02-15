//
//  TextField.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/14/24.
//

import Foundation
import UIKit

class TextField: UIView, UITextFieldDelegate {
    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor(named: "label")
        tf.backgroundColor = UIColor(named: "panel-color")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = UIColor(named: "info")
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor(named: "panel-color")
        textField.delegate = self
        clearButton.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        
        self.addSubview(textField)
        self.addSubview(clearButton)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        clearButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        clearButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        clearButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    @objc func clearPressed() {
        self.textField.becomeFirstResponder()
        switch self.textField.keyboardType {
        case .numberPad, .numbersAndPunctuation, .asciiCapableNumberPad:
            self.textField.text = "0"
        default:
            self.textField.text = ""
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        clearButton.isHidden = true
    }
}
