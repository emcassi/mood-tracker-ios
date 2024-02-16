//
//  SenseViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/11/24.
//

import Foundation
import UIKit

class SenseViewController : UIViewController {
    
    var items: [Sense:SenseItem] = [:]
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "You have not set up this skill yet."
        label.textColor = UIColor(named: "info")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emptyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Set up now", for: .normal)
        button.backgroundColor = UIColor(named: "info")
        button.setTitleColor(UIColor(named: "bg-color"), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 15
        button.addTarget(self, action: #selector(emptyPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Begin", for: .normal)
        button.setTitleColor(UIColor(named: "info"), for: .normal)
        button.addTarget(self, action: #selector(startPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sensesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sightView: SenseView = {
        let view = SenseView(sense: Sense.Sight)
        view.image.image = UIImage(systemName: "eye")
        view.prompt.text = "See"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let soundView: SenseView = {
        let view = SenseView(sense: Sense.Sound)
        view.image.image = UIImage(systemName: "ear")
        view.prompt.text = "Hear"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let touchView: SenseView = {
        let view = SenseView(sense: Sense.Touch)
        view.image.image = UIImage(systemName: "hand.point.up.left")
        view.prompt.text = "Touch"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let smellView: SenseView = {
        let view = SenseView(sense: Sense.Smell)
        view.image.image = UIImage(systemName: "nose")
        view.prompt.text = "Smell"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tasteView: SenseView = {
        let view = SenseView(sense: Sense.Taste)
        view.image.image = UIImage(systemName: "mouth")
        view.prompt.text = "Taste"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(settingsPressed))
        
//        view.addSubview(emptyLabel)
//        view.addSubview(emptyButton)
        view.addSubview(startButton)
        
        view.addSubview(sensesView)
        
        sensesView.addSubview(sightView)
        sensesView.addSubview(soundView)
        sensesView.addSubview(touchView)
        sensesView.addSubview(smellView)
        sensesView.addSubview(tasteView)
        
        setupSubviews()
    }
    
    func setupSubviews() {
//        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        emptyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
//        emptyLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
//        
//        emptyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        emptyButton.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 15).isActive = true
//        emptyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
//        emptyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        sensesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        sensesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        sensesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        sensesView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -15).isActive = true
        
        sightView.topAnchor.constraint(equalTo: sensesView.topAnchor, constant: 10).isActive = true
        sightView.leftAnchor.constraint(equalTo: sensesView.leftAnchor, constant: 15).isActive = true
        sightView.rightAnchor.constraint(equalTo: sensesView.rightAnchor, constant: -15).isActive = true
        sightView.heightAnchor.constraint(equalTo: sensesView.heightAnchor, multiplier: 0.17).isActive = true
        
        soundView.topAnchor.constraint(equalTo: sightView.bottomAnchor, constant: 10).isActive = true
        soundView.leftAnchor.constraint(equalTo: sensesView.leftAnchor, constant: 15).isActive = true
        soundView.rightAnchor.constraint(equalTo: sensesView.rightAnchor, constant: -15).isActive = true
        soundView.heightAnchor.constraint(equalTo: sightView.heightAnchor).isActive = true
        
        touchView.topAnchor.constraint(equalTo: soundView.bottomAnchor, constant: 10).isActive = true
        touchView.leftAnchor.constraint(equalTo: sensesView.leftAnchor, constant: 15).isActive = true
        touchView.rightAnchor.constraint(equalTo: sensesView.rightAnchor, constant: -15).isActive = true
        touchView.heightAnchor.constraint(equalTo: sightView.heightAnchor).isActive = true
        
        smellView.topAnchor.constraint(equalTo: touchView.bottomAnchor, constant: 10).isActive = true
        smellView.leftAnchor.constraint(equalTo: sensesView.leftAnchor, constant: 15).isActive = true
        smellView.rightAnchor.constraint(equalTo: sensesView.rightAnchor, constant: -15).isActive = true
        smellView.heightAnchor.constraint(equalTo: sightView.heightAnchor).isActive = true

        tasteView.topAnchor.constraint(equalTo: smellView.bottomAnchor, constant: 10).isActive = true
        tasteView.leftAnchor.constraint(equalTo: sensesView.leftAnchor, constant: 15).isActive = true
        tasteView.rightAnchor.constraint(equalTo: sensesView.rightAnchor, constant: -15).isActive = true
        tasteView.heightAnchor.constraint(equalTo: sightView.heightAnchor).isActive = true
    }
    
    @objc func emptyPressed() {
        navigationController?.pushViewController(SenseOptionsViewController(), animated: true)
    }
    
    @objc func settingsPressed() {
        navigationController?.pushViewController(SenseOptionsViewController(), animated: true)
    }
    
    @objc func startPressed() {
        print("getting items")
        SenseManager.getSetOfSenseItems { set in
            if set.isEmpty { return }
            self.items = set
            
            self.sightView.item.text = self.items[Sense.Sight]?.item
            self.soundView.item.text = self.items[Sense.Sound]?.item
            self.touchView.item.text = self.items[Sense.Touch]?.item
            self.smellView.item.text = self.items[Sense.Smell]?.item
            self.tasteView.item.text = self.items[Sense.Taste]?.item
        }
    }
    
}
