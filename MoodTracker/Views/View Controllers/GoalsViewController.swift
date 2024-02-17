//
//  GoalsViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/16/24.
//

import Foundation
import UIKit

class GoalsViewController : UIViewController {
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor(named: "bg-color")
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let timeImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(named: "label")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(named: "info")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let todaysGoalsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Your goals for today:"
        label.textColor = UIColor(named: "info")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let goalsView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(named: "bg-color")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(named: "light")
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 48
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "panel-color")
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "You do not have any goals set for today"
        label.textColor = UIColor(named: "label")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emptyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Goal", for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.setTitleColor(UIColor(named: "light"), for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timeImage.image = UIImage(named: "dusk")
        timeLabel.text = "9:28 PM"
        dateLabel.text = "Friday, February 16"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        
        view.addSubview(scrollView)
        scrollView.addSubview(timeImage)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(todaysGoalsLabel)
        scrollView.addSubview(goalsView)
        scrollView.addSubview(emptyView)
        
        emptyView.addSubview(emptyLabel)
        emptyView.addSubview(emptyButton)
        
        view.addSubview(addButton)

        setupSubviews()
    }
    
    func setupSubviews() {
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        timeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeImage.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 15).isActive = true
        timeImage.widthAnchor.constraint(equalToConstant: 128).isActive = true
        timeImage.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: timeImage.bottomAnchor, constant: 5).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 256).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 256).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        todaysGoalsLabel.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 15).isActive = true
        todaysGoalsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15).isActive = true
        todaysGoalsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        goalsView.topAnchor.constraint(equalTo: todaysGoalsLabel.bottomAnchor, constant: 5).isActive = true
        goalsView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor).isActive = true
        goalsView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor).isActive = true
        goalsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        
        emptyView.topAnchor.constraint(equalTo: todaysGoalsLabel.bottomAnchor, constant: 45).isActive = true
        emptyView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        emptyView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        emptyView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        emptyLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 30).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        emptyButton.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -15).isActive = true
        emptyButton.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 30).isActive = true
        emptyButton.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -30).isActive = true
        emptyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 96).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 96).isActive = true

    }
}
