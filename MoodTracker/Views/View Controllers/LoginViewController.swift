//
//  LoginViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/5/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAnalytics
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices

class LoginViewController: UIViewController, UITextFieldDelegate, ASAuthorizationControllerPresentationContextProviding {
	
	
	let scrollView = UIScrollView()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Sign in"
		label.font = .systemFont(ofSize: 42)
		label.textColor = UIColor(named: "label")
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let emailTF: TextField = {
		let tf = TextField(placeholder: "Email address")
		tf.textField.textContentType = .emailAddress
		tf.textField.autocapitalizationType = .none
		tf.textField.returnKeyType = .next
		tf.translatesAutoresizingMaskIntoConstraints = false
		return tf
	}()
	
	let passwordTF: TextField = {
		let tf = TextField(placeholder: "Password", isSecure: true)
		tf.textField.textContentType = .password
		tf.textField.returnKeyType = .go
		tf.textField.isSecureTextEntry = true
		tf.translatesAutoresizingMaskIntoConstraints = false
		return tf
	}()
	
	let errorLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.textColor = UIColor(named: "dangerous")
		label.font = .systemFont(ofSize: 10, weight: .bold)
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let signInButton: UIButton = {
		let button = UIButton()
		button.setTitle("Sign in", for: .normal)
		button.layer.cornerRadius = 15
		button.backgroundColor = UIColor(named: "purple")
		button.setTitleColor(.white, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	let orLabel: UILabel = {
		let label = UILabel()
		label.text = "OR"
		label.textColor = UIColor(named: "info")
		label.font = .systemFont(ofSize: 18, weight: .bold)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let appleButton: UIButton = {
		let button = UIButton()
		let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .large)
		button.setImage(UIImage(systemName: "apple.logo", withConfiguration: imageConfig), for: .normal)
		button.tintColor = UIColor(named: "label")
		button.backgroundColor = UIColor(named: "panel-color")
		button.layer.cornerRadius = 32
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	let googleButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "google"), for: .normal)
		button.backgroundColor = UIColor(named: "panel-color")
		button.layer.cornerRadius = 32
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	let facebookButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "facebook"), for: .normal)
		button.imageView?.frame = CGRectMake(0, 0, 32, 32)
		button.backgroundColor = UIColor(named: "panel-color")
		button.layer.cornerRadius = 32
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
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		print("SDFPOIJ")
		if textField == emailTF.textField {
			self.passwordTF.textField.becomeFirstResponder()
		} else if textField == passwordTF.textField {
			signIn()
		}
		return true
	}
	
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		let presAnchor = ASPresentationAnchor(frame: .zero)
		return presAnchor
	}
	
	
	override func viewDidLoad(){
		super.viewDidLoad()
		view.backgroundColor = UIColor(named: "bg-color")
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		
		let tg = UITapGestureRecognizer(target: self, action: #selector(tappedScreen))
		scrollView.addGestureRecognizer(tg)
		
		emailTF.textField.delegate = self
		passwordTF.textField.delegate = self
		
		signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
		appleButton.addTarget(self, action: #selector(handleApple), for: .touchUpInside)
		googleButton.addTarget(self, action: #selector(handleGoogle), for: .touchUpInside)
		facebookButton.addTarget(self, action: #selector(handleFacebook), for: .touchUpInside)
		
		view.addSubview(scrollView)
		scrollView.addSubview(titleLabel)
		scrollView.addSubview(emailTF)
		scrollView.addSubview(passwordTF)
		scrollView.addSubview(errorLabel )
		scrollView.addSubview(signInButton)
		scrollView.addSubview(orLabel)
		scrollView.addSubview(appleButton)
		scrollView.addSubview(googleButton)
		scrollView.addSubview(facebookButton)
		setupViews()
	}
	
	// Text field delegate methods
	
	@objc func tappedScreen(){
		scrollView.endEditing(true)
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
		emailTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
		emailTF.heightAnchor.constraint(equalToConstant: 50).isActive = true
	}
	
	
	func setupPasswordTF(){
		passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		passwordTF.widthAnchor.constraint(equalTo: emailTF.widthAnchor).isActive = true
		passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 10).isActive = true
		passwordTF.heightAnchor.constraint(equalToConstant: 50).isActive = true
	}
	
	func setupErrorLabel(){
		errorLabel.leftAnchor.constraint(equalTo: passwordTF.leftAnchor, constant: 15).isActive = true
		errorLabel.rightAnchor.constraint(equalTo: passwordTF.rightAnchor, constant: -15).isActive = true
		errorLabel.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 5).isActive = true
		errorLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
	}
	
	func setupButton(){
		signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		signInButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 35).isActive = true
		signInButton.widthAnchor.constraint(equalTo: passwordTF.widthAnchor, multiplier: 0.8).isActive = true
		signInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
	}
	
	func setupOrLabel(){
		orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		orLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 25).isActive = true
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
		if let email = emailTF.textField.text, let password = passwordTF.textField.text {
			Auth.auth().signIn(withEmail: email, password: password) { result, error in
				if let error = error {
					let message: String!
					if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
						message = "No accounts found for this email"
					} else if error.localizedDescription == "The password is invalid or the user does not have a password." {
						message = "Incorrect email or password"
					} else {
						message = error.localizedDescription
					}
					let alert = UIAlertController(title: "Unable to Sign In", message: message, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "Ok", style: .default))
					self.present(alert, animated: true)
				} else {
					Analytics.logEvent(AnalyticsEventLogin, parameters: [
						AnalyticsParameterMethod: "Email"
					])
					AuthManager.user = MudiUser(Auth.auth().currentUser!)
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
				Analytics.logEvent(AnalyticsEventLogin, parameters: [
					AnalyticsParameterMethod: "Google"
				])
				AuthManager.user = MudiUser(Auth.auth().currentUser!)
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
							Analytics.logEvent(AnalyticsEventLogin, parameters: [
								AnalyticsParameterMethod: "Facebook"
							])
							AuthManager.user = MudiUser(Auth.auth().currentUser!)
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
				Analytics.logEvent(AnalyticsEventLogin, parameters: [
					AnalyticsParameterMethod: "Apple"
				])
				AuthManager.user = MudiUser(Auth.auth().currentUser!)
				self.dismiss(animated: true)
			}
		}
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		// Handle error.
		print("Sign in with Apple errored: \(error)")
	}
	
}
