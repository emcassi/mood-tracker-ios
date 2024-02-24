//
//  NewProsConsViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation
import UIKit

class NewProsConsViewController : UIViewController {
    var saveButtonBottomConstraint: NSLayoutConstraint?
    var parentVC: UITableViewController?

    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "New Scenario"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(named: "label")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleTF: TextField = {
        let tf = TextField(placeholder: "What are you contemplating?")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let radioView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "AccentColor")
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor(named: "label"), for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        view.addSubview(topLabel)
        view.addSubview(titleTF)
        view.addSubview(saveButton)
        
        setupSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleTF.textField.becomeFirstResponder()
    }
    
    
    
    func setupSubviews() {
        topLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        topLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        titleTF.leftAnchor.constraint(equalTo: topLabel.leftAnchor).isActive = true
        titleTF.rightAnchor.constraint(equalTo: topLabel.rightAnchor).isActive = true
        titleTF.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 50).isActive = true
        titleTF.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        saveButtonBottomConstraint?.isActive = true
        saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.saveButtonBottomConstraint?.constant = -keyboardHeight - 15 // Adjust the padding as needed
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.saveButtonBottomConstraint?.constant = -15 // Reset to original padding
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func savePressed() {
        guard let title = titleTF.textField.text else { return }
        if title.isEmpty { return }
        
        print("Save item: \(title)")
        
        let newItem = ProsCons(id: "1234", title: title, pros: [], cons: [], createdAt: .now, updatedAt: .now)
        ProsConsManager.new(item: newItem)
        parentVC?.tableView.reloadData()
        dismiss(animated: true)
    }
}
