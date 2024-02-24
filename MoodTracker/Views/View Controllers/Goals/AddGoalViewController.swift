//
//  AddGoalViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/17/24.
//

import Foundation
import UIKit

class AddGoalViewController: UIViewController {
    
    var canAdd: Bool = false
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor(named: "bg-color")
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Set a New Goal"
        label.textColor = UIColor(named: "label")
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: TextField = {
        let tf = TextField(placeholder: "What is your goal?")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let tipsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "label"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitle("Tips for Setting Good Goals", for: .normal)
        button.layer.borderWidth = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var daysView: DayPickerView = DayPickerView() {}
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.backgroundColor = UIColor(named: "AccentColor")
        button.setTitleColor(UIColor(named: "label"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        
        daysView = DayPickerView(onSelect: checkIfCanAdd)
        daysView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        addButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        tipsButton.addTarget(self, action: #selector(tipsPressed), for: .touchUpInside)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(textField)
        scrollView.addSubview(tipsButton)
        scrollView.addSubview(daysView)
        scrollView.addSubview(addButton)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tipsButton.topAnchor.constraint(equalTo: textField.bottomAnchor,  constant: 15).isActive = true
        tipsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 45).isActive = true
        tipsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -45).isActive = true
        tipsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        daysView.topAnchor.constraint(equalTo: tipsButton.bottomAnchor, constant: 15).isActive = true
        daysView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        daysView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        daysView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        addButton.topAnchor.constraint(equalTo: daysView.bottomAnchor,  constant: 15).isActive = true
        addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 45).isActive = true
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -45).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func checkIfCanAdd() {
        if (textField.textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || daysView.daysPicked.isEmpty {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
    @objc func textChanged() {
        checkIfCanAdd()
    }
    
    @objc func addPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func tipsPressed() {
    present(LearnBaseViewController(learnItem: LearnItem(id: 1, name: "Setting Good Goals", image: nil, filename: "Setting Good Goals")), animated: true)
    }
}
