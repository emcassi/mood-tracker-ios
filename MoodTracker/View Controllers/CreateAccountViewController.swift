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
    
    // Subviews
    
    let scrollView: UIScrollView = {
      let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = .systemFont(ofSize: 48)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTF: UITextField = {
       let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        tf.textContentType = .emailAddress
        tf.layer.cornerRadius = 15
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.textColor = .black
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let passwordTF: UITextField = {
       let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        tf.textContentType = .password
        tf.isSecureTextEntry = true
        tf.layer.cornerRadius = 15
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.textColor = .black
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordErrorLabel: UILabel = {
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
        button.setTitle("Create Account", for: .normal)
        button.layer.cornerRadius = 15
        button.isEnabled = false
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // viewDidLoad
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tg = UITapGestureRecognizer(target: self, action: #selector(tappedScreen))
        view.addGestureRecognizer(tg)
        
        view.addSubview(scrollView)
    
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(emailTF)
        scrollView.addSubview(emailErrorLabel)
        scrollView.addSubview(passwordTF)
        scrollView.addSubview(passwordErrorLabel)
        scrollView.addSubview(button)
        
        setupSubviews()
        
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    @objc func tappedScreen(){
        resignFirstResponder()
    }
    
    // Text field delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            createAccount()
        }
        return true
    }
    
    // Subviews Setup
    
    func setupSubviews(){
        setupScrollView()
       setupTitleLabel()
        setupEmailTF()
        setupEmailErrorLabel()
        setupPasswordTF()
        setupPasswordErrorLabel()
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
    
    func setupEmailTF(){
        emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 75).isActive = true
        emailTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        emailTF.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupEmailErrorLabel(){
        emailErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailErrorLabel.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 5).isActive = true
        emailErrorLabel.widthAnchor.constraint(equalTo: emailTF.widthAnchor).isActive = true
        emailErrorLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupPasswordTF(){
        passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTF.widthAnchor.constraint(equalTo: emailTF.widthAnchor).isActive = true
        passwordTF.topAnchor.constraint(equalTo: emailErrorLabel.bottomAnchor).isActive = true
        passwordTF.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupPasswordErrorLabel(){
        passwordErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordErrorLabel.widthAnchor.constraint(equalTo: passwordTF.widthAnchor).isActive = true
        passwordErrorLabel.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 5).isActive = true
        passwordErrorLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupButton(){
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: passwordErrorLabel.bottomAnchor, constant: 35).isActive = true
        button.widthAnchor.constraint(equalTo: passwordTF.widthAnchor, multiplier: 0.8).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    // Sign in button functionality
    
    @objc func createAccount(){
        if let email = emailTF.text, let password = passwordTF.text {
            if isValidEmail(email) && isValidPassword(password) {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        self.passwordErrorLabel.text = error.localizedDescription 
                        print(error)
                        return
                    } else if let result = result {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return isValidFrom(regex: emailRegEx, string: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&? \"]).*$"
        return isValidFrom(regex: passwordRegEx, string: password)
    }
    
    func isValidFrom(regex: String, string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
    
    @objc func textFieldChanged(sender: UITextField){
        if let email = emailTF.text, let password = passwordTF.text {
            if email.count > 0{
                if isValidEmail(email) {
                    emailErrorLabel.text = ""
                    if password.count > 0 {
                        if isValidPassword(password){
                            emailErrorLabel.text = ""
                            passwordErrorLabel.text = ""
                            button.isEnabled = true
                        } else {
                            passwordErrorLabel.textColor = .red
                            passwordErrorLabel.text = "Your password must be at least 6 characters long and include a lowercase, uppercase, number, and special character"
                            button.isEnabled = false
                        }
                    } else {
                        passwordErrorLabel.textColor = .gray
                        passwordErrorLabel.text = "Your password must be at least 6 characters long and include a lowercase, uppercase, number, and special character"
                        button.isEnabled = false
                    }
                } else {
                    emailErrorLabel.text = "Please enter a valid email"
                    button.isEnabled = false
                }
            } else {
                emailErrorLabel.text = ""
                button.isEnabled = false
            }
        }
        
        button.backgroundColor = button.isEnabled ? UIColor(named: "purple") : .gray
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
