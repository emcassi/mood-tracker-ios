//
//  SenseOptionsViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/11/24.
//

import Foundation
import UIKit
import FirebaseFirestore

class SenseOptionsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
	var currentSense = Sense.Touch
	
	var items: [Sense: [SenseItem]] = [:]
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = items[currentSense]?.count ?? 0
        emptyLabel.isHidden = count != 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sense-skill-cell", for: indexPath) as! SenseSkillCell
		cell.skillLabel.text = items[currentSense]?[indexPath.item].item ?? ""
        return cell
    }
    
    let senseImage: UIImageView = {
        let view = UIImageView()
        view.tintColor = UIColor(named: "info")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let senseLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "info")
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = UIColor(named: "panel-color")
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "To add an item, tap the + below"
        label.textColor = UIColor(named: "info")
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let senseSwitcher: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let senseVision: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "panel-color")
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = UIColor(named: "info")
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(visionPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let senseHearing: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "panel-color")
        button.setImage(UIImage(systemName: "ear"), for: .normal)
        button.tintColor = UIColor(named: "info")
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(hearingPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let senseTouch: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "panel-color")
        button.setImage(UIImage(systemName: "hand.point.up.left"), for: .normal)
        button.tintColor = UIColor(named: "info")
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(touchPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let senseTaste: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "panel-color")
        button.setImage(UIImage(systemName: "mouth"), for: .normal)
        button.tintColor = UIColor(named: "info")
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(tastePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let senseSmell: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "panel-color")
        button.setImage(UIImage(systemName: "nose"), for: .normal)
        button.tintColor = UIColor(named: "info")
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(smellPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(named: "info"), for: .normal)
        button.backgroundColor = UIColor(named: "panel-color")
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SenseSkillCell.self, forCellReuseIdentifier: "sense-skill-cell")
        
        getItems()
        
        view.addSubview(senseImage)
        view.addSubview(senseLabel)
        view.addSubview(tableView)
        tableView.addSubview(emptyLabel)
        view.addSubview(senseSwitcher)
        
        senseSwitcher.addSubview(senseVision)
        senseSwitcher.addSubview(senseHearing)
        senseSwitcher.addSubview(senseTouch)
        senseSwitcher.addSubview(senseTaste)
        senseSwitcher.addSubview(senseSmell)
        
        view.addSubview(doneButton)
        
		changeSense(sense: currentSense)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        senseImage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        senseImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        senseImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        senseImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        senseLabel.leftAnchor.constraint(equalTo: senseImage.rightAnchor, constant: 15).isActive = true
        senseLabel.centerYAnchor.constraint(equalTo: senseImage.centerYAnchor).isActive = true
        senseLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        senseLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        tableView.topAnchor.constraint(equalTo: senseLabel.bottomAnchor, constant: 15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: senseSwitcher.topAnchor, constant: -15).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        emptyLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        doneButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
		doneButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant:  -30).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        senseSwitcher.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -15).isActive = true
        senseSwitcher.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        senseSwitcher.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        senseSwitcher.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        senseTouch.centerXAnchor.constraint(equalTo: senseSwitcher.centerXAnchor).isActive = true
        senseTouch.centerYAnchor.constraint(equalTo: senseSwitcher.centerYAnchor).isActive = true
        senseTouch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        senseTouch.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        senseHearing.rightAnchor.constraint(equalTo: senseTouch.leftAnchor, constant: -15).isActive = true
        senseHearing.centerYAnchor.constraint(equalTo: senseSwitcher.centerYAnchor).isActive = true
        senseHearing.widthAnchor.constraint(equalToConstant: 50).isActive = true
        senseHearing.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        senseVision.rightAnchor.constraint(equalTo: senseHearing.leftAnchor, constant: -15).isActive = true
        senseVision.centerYAnchor.constraint(equalTo: senseSwitcher.centerYAnchor).isActive = true
        senseVision.widthAnchor.constraint(equalToConstant: 50).isActive = true
        senseVision.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        senseSmell.leftAnchor.constraint(equalTo: senseTouch.rightAnchor, constant: 15).isActive = true
        senseSmell.centerYAnchor.constraint(equalTo: senseSwitcher.centerYAnchor).isActive = true
        senseSmell.widthAnchor.constraint(equalToConstant: 50).isActive = true
        senseSmell.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        senseTaste.leftAnchor.constraint(equalTo: senseSmell.rightAnchor, constant: 15).isActive = true
        senseTaste.centerYAnchor.constraint(equalTo: senseSwitcher.centerYAnchor).isActive = true
        senseTaste.widthAnchor.constraint(equalToConstant: 50).isActive = true
        senseTaste.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func changeSense(sense: Sense) {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.senseVision.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.senseHearing.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.senseTouch.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.senseTaste.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.senseSmell.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            self.senseVision.setImage(UIImage(systemName: "eye"), for: .normal)
            self.senseHearing.setImage(UIImage(systemName: "ear"), for: .normal)
            self.senseTouch.setImage(UIImage(systemName: "hand.point.up.left"), for: .normal)
            self.senseSmell.setImage(UIImage(systemName: "nose"), for: .normal)
            self.senseTaste.setImage(UIImage(systemName: "mouth"), for: .normal)
            
            switch sense {
			case Sense.Sight:
                self.senseVision.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.senseVision.setImage(UIImage(systemName: "plus"), for: .normal)
                self.senseImage.image = UIImage(systemName: "eye", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
                break
			case Sense.Sound:
                self.senseHearing.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.senseHearing.setImage(UIImage(systemName: "plus"), for: .normal)
                self.senseImage.image = UIImage(systemName: "ear", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
                break
			case Sense.Touch:
                self.senseTouch.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.senseTouch.setImage(UIImage(systemName: "plus"), for: .normal)
                self.senseImage.image = UIImage(systemName: "hand.point.up.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
                break
			case Sense.Smell:
                self.senseSmell.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.senseSmell.setImage(UIImage(systemName: "plus"), for: .normal)
                self.senseImage.image = UIImage(systemName: "nose", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
                break
			case Sense.Taste:
                self.senseTaste.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.senseTaste.setImage(UIImage(systemName: "plus"), for: .normal)
                self.senseImage.image = UIImage(systemName: "mouth", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
                break
            }
        })
        
		self.currentSense = sense
		self.senseLabel.text = SenseManager.getSenseWord(sense: sense)
        self.tableView.reloadData()
    }
    
    @objc func visionPressed() {
		let sense = Sense.Sight
        if self.currentSense == sense {
			showAddDialogue(senseWord: SenseManager.getSenseVerb(sense: sense))
        } else {
            changeSense(sense: sense)
        }
    }
    
    @objc func hearingPressed() {
		let sense = Sense.Sound
		if self.currentSense == sense {
			showAddDialogue(senseWord: SenseManager.getSenseVerb(sense: sense))
		} else {
			changeSense(sense: sense)
		}
    }
    
    @objc func touchPressed() {
		let sense = Sense.Touch
		if self.currentSense == sense {
			showAddDialogue(senseWord: SenseManager.getSenseVerb(sense: sense))
		} else {
			changeSense(sense: sense)
		}
    }
    
    @objc func tastePressed() {
		let sense = Sense.Taste
		if self.currentSense == sense {
			showAddDialogue(senseWord: SenseManager.getSenseVerb(sense: sense))
		} else {
			changeSense(sense: sense)
		}
    }
    
    @objc func smellPressed() {
		let sense = Sense.Smell
		if self.currentSense == sense {
			showAddDialogue(senseWord: SenseManager.getSenseVerb(sense: sense))
		} else {
			changeSense(sense: sense)
		}
    }
    
    @objc func cancelPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAddDialogue(senseWord: String) {
        
        let alertController = UIAlertController(title: "Name something you can \(senseWord)", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter text here"
            textField.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Handle cancel action if needed
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let text = alertController.textFields?.first?.text {
                
				AuthManager.addSenseItem(sense : self.currentSense, item: text) { item in
					self.items[self.currentSense]?.append(item)
					self.tableView.reloadData()
                }
            }
        }
        okAction.isEnabled = false // Initially disable OK action
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        // Enable OK action only if text field is not empty
        if let alertController = self.presentedViewController as? UIAlertController {
            let text = sender.text ?? ""
            alertController.actions.last?.isEnabled = !text.isEmpty
        }
    }
	
    func getItems() {
        SenseManager.getSenseItemsForUser() { senseItems in
            self.items = senseItems
            self.changeSense(sense: self.currentSense)
        }
    }
}
