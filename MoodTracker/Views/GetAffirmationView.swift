//
//  GetAffirmationView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/10/22.
//

import Foundation
import UIKit
import FirebaseFirestore

class AffirmationsViewController: UIViewController {
    
    var lastAff = ""
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.text = "Get an Affirmation"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "Tap below the button to get an affirmation to help you feel better"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let affirmationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Affirmation", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "purple")
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(getButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let undoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go back", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(undoPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(affirmationLabel)
        view.addSubview(getButton)
        view.addSubview(undoButton)
        setupSubviews()
    }
    
    func setupSubviews(){
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        affirmationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        affirmationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        affirmationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        affirmationLabel.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        getButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getButton.bottomAnchor.constraint(equalTo: undoButton.topAnchor, constant: -15).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        getButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        undoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        undoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    @objc func getButtonPressed(){
        getAffirmation()
    }
    
    @objc func undoPressed(){
        if lastAff != "" {
            affirmationLabel.text = lastAff
        }
        undoButton.isHidden = true
    }
    
    func getAffirmation() {
        if let url = URL(string: "https://www.affirmations.dev") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                if let data = data {
                    self.parseJSON(data)
                }
            }
            task.resume()
            Firestore.firestore().collection("analytics").document("affirmations").setData(["sent": FieldValue.increment(1.0)])
        }
    }
    
    func parseJSON(_ data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Affirmation.self, from: data)
            DispatchQueue.main.async {
                if let aff = self.affirmationLabel.text {
                    self.lastAff = self.affirmationLabel.text!
                }
                self.affirmationLabel.text = decodedData.affirmation
                if self.lastAff != "" {
                    self.undoButton.isHidden = false
                }
            }
        } catch {
            print(error)
        }
    }
       
}
