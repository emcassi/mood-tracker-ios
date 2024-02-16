//
//  TextField.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/14/24.
//

import Foundation
import UIKit

class TextField: UIView, UITextFieldDelegate {
    
    let placeholder: String!
    let isSecure: Bool!
    
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
    
    lazy var obscureButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = UIColor(named: "info")
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(placeholder: String = "Enter text here", isSecure: Bool = false) {
        self.placeholder = placeholder
        self.isSecure = isSecure
        super.init(frame: CGRect.zero)
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor(named: "panel-color")
        textField.delegate = self
        clearButton.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        obscureButton.addTarget(self, action: #selector(obscurePressed), for: .touchUpInside)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "info") ?? UIColor.gray])
        textField.isSecureTextEntry = isSecure
        obscureButton.isHidden = !isSecure
        
        self.addSubview(textField)
        self.addSubview(clearButton)
        self.addSubview(obscureButton)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        if (isSecure) {
            obscureButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
            obscureButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            obscureButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
            obscureButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
            clearButton.rightAnchor.constraint(equalTo: obscureButton.leftAnchor, constant: -5).isActive = true
        } else {
            clearButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        }
        
        clearButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        clearButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        textField.rightAnchor.constraint(equalTo: clearButton.leftAnchor, constant: -40).isActive = true
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
    
    @objc func obscurePressed() {
        if textField.isSecureTextEntry {
            textField.isSecureTextEntry = false
            obscureButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            textField.isSecureTextEntry = true
            obscureButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        clearButton.isHidden = true
    }
}
