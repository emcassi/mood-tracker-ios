//
//  BreatheViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/10/24.
//

import Foundation
import UIKit

class BreatheViewController : UIViewController {
    let durationOfGrowth: TimeInterval = 12
    let durationOfShrink: TimeInterval = 7
    let waitDuration: TimeInterval = 3
    let repeatCount = 5
    var currentRepeat = 0
    var isGoing = false
    var currentAnimation: UIViewPropertyAnimator?
    var screenShowing = false
    
    let generator = UIImpactFeedbackGenerator(style: .medium)

    let heartOutline: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart")
        view.tintColor = UIColor(named: "panel-color")
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        return view
    }()
    
    let heartImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill")
        view.tintColor = UIColor(named: "info")
        view.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return view
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Begin", for: .normal)
        button.setTitleColor(UIColor(named: "info"), for: .normal)
        button.addTarget(self, action: #selector(startPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "info")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenShowing = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        screenShowing = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        view.addSubview(heartOutline)
        view.addSubview(heartImage)
        view.addSubview(startButton)
        view.addSubview(label)
        self.heartImage.center = self.view.center
        self.heartOutline.center = self.view.center
        
        UIView.animate(withDuration: 1, delay: 0.25, options: [.repeat, .autoreverse], animations: {
            self.label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsPressed))
        
        startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func breathe() {
        if !screenShowing || !isGoing { return }
        let smallSize = 25
        let bigSize = 400
        self.generator.impactOccurred()
        label.text = "Inhale"
        UIView.animate(withDuration: durationOfGrowth, animations: {
            // Grow the view
            self.heartImage.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: bigSize, height: bigSize))
            self.heartImage.center = self.view.center
        }) { (_) in
            if !self.screenShowing || !self.isGoing { return }
            self.generator.impactOccurred()
            self.label.text = "Exhale"
            UIView.animate(withDuration: self.durationOfShrink, animations: {
                // Shrink the view
                self.heartImage.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: smallSize, height: smallSize))
                self.heartImage.center = self.view.center
                
            }) { (_) in
                if !self.screenShowing || !self.isGoing { return }
                self.generator.impactOccurred()
                self.label.text = "Hold"
                // Wait for a few seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + self.waitDuration) {
                    // Check if we need to repeat the animation
                    self.currentRepeat += 1
                    if self.currentRepeat < self.repeatCount {
                        // Repeat animation
                        self.breathe()
                    } else {
                        self.isGoing = false
                        self.startButton.setTitle("Begin", for: .normal)
                        self.label.text = ""
                    }
                }
            }
        }
    }
    
    @objc func startPressed() {
        if !isGoing {
            isGoing = true
            breathe()
            startButton.setTitle("Stop", for: .normal)
        } else {
            isGoing = false
            self.startButton.setTitle("Begin", for: .normal)
            heartImage.stopAnimating()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func settingsPressed() {
        //navigationController?.pushViewController(BreatheSettingsViewController(), animated: true)
    }
}
