//
//  LoginViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/5/22.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices

class LoginViewController: UIViewController, UITextFieldDelegate, ASAuthorizationControllerPresentationContextProviding {

    
    let scrollView = UIScrollView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in"
        label.font = UIFont(name: "FredokaOne-Regular", size: 48)
        label.textColor = .black
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
    
    let orLabel: UILabel = {
       let label = UILabel()
        label.text = "OR"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let appleButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "apple"), for: .normal)
        button.backgroundColor = UIColor(gray: 240)
        button.layer.cornerRadius = 32
        button.addTarget(self, action: #selector(handleApple), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let googleButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "google"), for: .normal)
        button.backgroundColor = UIColor(gray: 240)
        button.layer.cornerRadius = 32
        button.addTarget(self, action: #selector(handleGoogle), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let facebookButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "facebook"), for: .normal)
        button.imageView?.frame = CGRectMake(0, 0, 32, 32)
        button.backgroundColor = UIColor(gray: 240)
        button.layer.cornerRadius = 32
        button.addTarget(self, action: #selector(handleFacebook), for: .touchUpInside)
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
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let presAnchor = ASPresentationAnchor(frame: .zero)
        return presAnchor
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
        scrollView.addSubview(orLabel)
        scrollView.addSubview(appleButton)
        scrollView.addSubview(googleButton)
        scrollView.addSubview(facebookButton)
        setupViews()
        
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    // Text field delegate methods
    
    @objc func tappedScreen(){
        scrollView.endEditing(true)
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
        setupOrLabel()
        setupAppleButton()
        setupGoogleButton()
        setupFacebookButton()
    }
    
    func setupScrollView(){
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setupTitleLabel(){
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 75).isActive = true
    }
    
    func setupEmailTF(){
        emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        emailTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
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
    
    func setupOrLabel(){
        orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        orLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 25).isActive = true
    }
    
    func setupAppleButton(){
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width / 4).isActive = true
        appleButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 25).isActive = true
        appleButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    func setupGoogleButton(){
        googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 25).isActive = true
        googleButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    func setupFacebookButton(){
        facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width / 4).isActive = true
        facebookButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 25).isActive = true
        facebookButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
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
    
    
    fileprivate var currentNonce: String?

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = AuthManager().randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = AuthManager().sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    @objc func handleApple(){
        startSignInWithAppleFlow()
    }
    
    @objc func handleGoogle(){
        
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            
            
            if let error = error {
                print(error)
                return
            }
            
            guard let accessToken = result?.user.accessToken, let idToken = result?.user.idToken else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { res, err in
                if let err = err {
                    print(err)
                }
                
                self.dismiss(animated: true)
            }
        }
        
    }
    
    @objc func handleFacebook(){
        let fbManager = LoginManager()
        fbManager.logIn(permissions: ["email"], from: self) { result, error in
            if error == nil {
                
                if result!.isCancelled {
                    return
                }
                
                if result!.grantedPermissions.contains("email") {
                    if let token = AccessToken.current {
                        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                        
                        Auth.auth().signIn(with: credential) { res, err in
                            if let err = err {
                                print(err)
                            }
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
}



@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
          if error != nil {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
              print(error!.localizedDescription)
              return
            }
        // User is signed in to Firebase with Apple.
        // ...
          
          self.dismiss(animated: true)
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
