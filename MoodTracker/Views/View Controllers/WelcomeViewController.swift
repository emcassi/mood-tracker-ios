//
//  ViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 10/27/22.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Mood Tracker"
        label.font = UIFont(name: "FredokaOne-Regular", size: 42)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "love")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .yellow
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "purple")
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let createAcctButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(UIColor(named: "purple"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "purple")!.cgColor
        button.addTarget(self, action: #selector(createAcctPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        setupViews()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        print("Appeared")
        if Auth.auth().currentUser != nil {
            dismiss(animated: true)
        }
    }

    // setup views
    
    func setupViews(){
       setupTitleLabel()
        setupImageView()
        setupCreateAccountButton()
        setupSignInButton()
    }
    
    func setupTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 125).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func setupImageView(){
        view.addSubview(imgView)
        imgView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
    }
    
    func setupCreateAccountButton(){
        view.addSubview(createAcctButton)
        createAcctButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAcctButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        createAcctButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        createAcctButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupSignInButton(){
        view.addSubview(signInButton)
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: createAcctButton.topAnchor, constant: -10).isActive = true
        signInButton.widthAnchor.constraint(equalTo: createAcctButton.widthAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalTo: createAcctButton.heightAnchor).isActive = true
    }
    
    // button functions
    
    @objc func signInPressed(){
        present(LoginViewController(), animated: true)
    }
    
    @objc func createAcctPressed(){
        present(CreateAccountViewController(), animated: true)
    }
}

