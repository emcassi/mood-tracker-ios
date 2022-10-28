//
//  CreateAccountViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/6/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView: UIScrollView = {
      let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = .systemFont(ofSize: 48)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTF: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Name"
        tf.textContentType = .name
        tf.layer.cornerRadius = 15
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailTF: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Email"
        tf.textContentType = .emailAddress
        tf.layer.cornerRadius = 15
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTF: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Password"
        tf.textContentType = .password
        tf.isSecureTextEntry = true
        tf.layer.cornerRadius = 15
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor.tintColor
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(createAccountPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(scrollView)
    
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(nameTF)
        scrollView.addSubview(emailTF)
        scrollView.addSubview(passwordTF)
        scrollView.addSubview(button)
        
        setupViews()
        
        nameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    // Text field delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            createAccount()
        }
        return true
    }
    
    // View Setup
    
    func setupViews(){
        setupScrollView()
       setupTitleLabel()
        setupNameTF()
        setupEmailTF()
        setupPasswordTF()
        setupButton()
    }
    
    func setupScrollView(){
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func setupTitleLabel(){
        titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 75).isActive = true
    }
    
    func setupNameTF(){
        nameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        nameTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 75).isActive = true
        nameTF.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupEmailTF(){
        emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        emailTF.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 10).isActive = true
        emailTF.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    
    func setupPasswordTF(){
        passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTF.widthAnchor.constraint(equalTo: emailTF.widthAnchor).isActive = true
        passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 10).isActive = true
        passwordTF.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupButton(){
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 75).isActive = true
        button.widthAnchor.constraint(equalTo: passwordTF.widthAnchor, multiplier: 0.8).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    // Sign in button functionality
    
    @objc func createAccountPressed(){
        createAccount()
    }
    
    func createAccount(){
        if let name = nameTF.text, let email = emailTF.text, let password = passwordTF.text {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print(error)
                    return
                }
                Firestore.firestore().collection("users").document(result!.user.uid).setData([ "name": name ]) { error in
                    if let error = error {
                        print(error)
                    }
                    self.dismiss(animated: true)
                }
            }
        } else {
            print("Fields not filled")
        }
    }
    
    // Keyboard notifications
    
    @objc func keyboardWillShow(notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
    }
}
