//
//  LoginViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/5/22.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView = UIScrollView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in"
        label.font = .systemFont(ofSize: 48)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTF: UITextField = {
       let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(gray: 200)])
        tf.textContentType = .emailAddress
        tf.layer.cornerRadius = 15
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.textColor = .black
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTF: UITextField = {
       let tf = UITextField()
        tf.textContentType = .password
        tf.isSecureTextEntry = true
        tf.layer.cornerRadius = 15
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(gray: 200)])
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(named: "purple")
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func keyboardWillShow(notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let tg = UITapGestureRecognizer(target: self, action: #selector(tappedScreen))
        scrollView.addGestureRecognizer(tg)


        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(emailTF)
        scrollView.addSubview(passwordTF)
        scrollView.addSubview(errorLabel )
        scrollView.addSubview(button)
        setupViews()
        
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    // Text field delegate methods
    
    @objc func tappedScreen(){
        resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            signIn()
        }
        return true
    }
    
    // View Setup
    
    func setupViews(){
        setupScrollView()
       setupTitleLabel()
        setupEmailTF()
        setupPasswordTF()
        setupErrorLabel()
        setupButton()
    }
    
    func setupScrollView(){
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setupTitleLabel(){
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 75).isActive = true
    }
    
    func setupEmailTF(){
        emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        emailTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 75).isActive = true
        emailTF.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    
    func setupPasswordTF(){
        passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTF.widthAnchor.constraint(equalTo: emailTF.widthAnchor).isActive = true
        passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 10).isActive = true
        passwordTF.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupErrorLabel(){
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.widthAnchor.constraint(equalTo: passwordTF.widthAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 5).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupButton(){
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 35).isActive = true
        button.widthAnchor.constraint(equalTo: passwordTF.widthAnchor, multiplier: 0.8).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    // Sign in button functionality
    
    @objc func signInPressed(){
        signIn()
    }
    
    func signIn(){
        if let email = emailTF.text, let password = passwordTF.text {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        self.errorLabel.text = "No accounts found for this email"
                    } else if error.localizedDescription == "The password is invalid or the user does not have a password." {
                        self.errorLabel.text = "Incorrect email or password"
                    } else {
                        self.errorLabel.text = error.localizedDescription
                        print(error.localizedDescription)
                    }
                } else {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
