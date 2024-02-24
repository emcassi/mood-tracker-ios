//
//  NewProConView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation
import UIKit

class NewProConViewController: UIViewController {
    var saveButtonBottomConstraint: NSLayoutConstraint?
    var parentVC: ProsConsViewController
    
    let item: ProsCons

    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "New Case"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(named: "label")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleTF: TextField = {
        let tf = TextField(placeholder: "Make a case")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let radioView: ProsConsRadioView = {
        let view = ProsConsRadioView()
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
    
    init(item: ProsCons, parent: ProsConsViewController) {
        self.item = item
        self.parentVC = parent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        view.addSubview(topLabel)
        view.addSubview(titleTF)
        view.addSubview(radioView)
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
        
        radioView.topAnchor.constraint(equalTo: titleTF.bottomAnchor, constant: 15).isActive = true
        radioView.leftAnchor.constraint(equalTo: topLabel.leftAnchor).isActive = true
        radioView.rightAnchor.constraint(equalTo: topLabel.rightAnchor).isActive = true
        radioView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        
        guard let user = AuthManager.user else {
            AuthManager().logout()
            return
        }
        
        let newItem = ProsConsItem(id: UUID().uuidString, title: title, date: .now)
        guard var index = user.prosCons.firstIndex(where: { $0.id == self.item.id }) else {
            print("Couldnt find item with id: \(self.item.id)")
            return
        }
        
        var currentSituation = user.prosCons[index]
    
        if radioView.isPro {
            currentSituation.pros.append(newItem)
        } else {
            currentSituation.cons.append(newItem)
        }
        
        AuthManager.user!.prosCons[index].pros = currentSituation.pros
        AuthManager.user!.prosCons[index].cons = currentSituation.cons
        parentVC.tableView.reloadData()
        parentVC.updateScoreboard()
        dismiss(animated: true)
    }
}
