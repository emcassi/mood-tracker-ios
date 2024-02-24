//
//  Scoreboard.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation
import UIKit

struct ScoreboardItem {
    let name: String
    let score: Int
}

class Scoreboard : UIView {
    
    var items: (ScoreboardItem, ScoreboardItem)
    
    let leftSide: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor(named: "info")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let leftScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .regular)
        label.textColor = UIColor(named: "info")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "info")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rightSide: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor(named: "info")
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .regular)
        label.textColor = UIColor(named: "info")
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        self.items = (ScoreboardItem(name: "", score: 0), ScoreboardItem(name: "", score: 0))
        super.init(frame: .zero)
    }
    
    init(items: (ScoreboardItem, ScoreboardItem)) {
        self.items = items
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "panel-color")
        
        self.leftLabel.text = items.0.name
        self.rightLabel.text = items.1.name
        
        self.leftScoreLabel.text = "\(items.0.score)"
        self.rightScoreLabel.text = "\(items.1.score)"
        
        self.addSubview(leftSide)
        self.addSubview(divider)
        self.addSubview(rightSide)
        
        leftSide.addSubview(leftLabel)
        leftSide.addSubview(leftScoreLabel)
        rightSide.addSubview(rightLabel)
        rightSide.addSubview(rightScoreLabel)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        leftSide.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        leftSide.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -15).isActive = true
        leftSide.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        leftSide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        leftLabel.topAnchor.constraint(equalTo: leftSide.topAnchor).isActive = true
        leftLabel.leftAnchor.constraint(equalTo: leftSide.leftAnchor).isActive = true
        leftLabel.rightAnchor.constraint(equalTo: leftSide.rightAnchor).isActive = true
        leftLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        leftScoreLabel.topAnchor.constraint(equalTo: leftLabel.bottomAnchor, constant: 5).isActive = true
        leftScoreLabel.leftAnchor.constraint(equalTo: leftLabel.leftAnchor).isActive = true
        leftScoreLabel.rightAnchor.constraint(equalTo: leftLabel.rightAnchor).isActive = true
        leftScoreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        divider.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        divider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 3).isActive = true
        divider.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        
        rightSide.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 25).isActive = true
        rightSide.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        rightSide.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        rightSide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        rightLabel.topAnchor.constraint(equalTo: rightSide.topAnchor).isActive = true
        rightLabel.leftAnchor.constraint(equalTo: rightSide.leftAnchor).isActive = true
        rightLabel.rightAnchor.constraint(equalTo: rightSide.rightAnchor).isActive = true
        rightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        rightScoreLabel.topAnchor.constraint(equalTo: rightLabel.bottomAnchor, constant: 5).isActive = true
        rightScoreLabel.leftAnchor.constraint(equalTo: rightLabel.leftAnchor).isActive = true
        rightScoreLabel.rightAnchor.constraint(equalTo: rightLabel.rightAnchor).isActive = true
        rightScoreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dealWithWinner() {
        if self.items.0.score > self.items.1.score {
            self.leftScoreLabel.font = .systemFont(ofSize: 42, weight: .black)
            self.rightScoreLabel.font = .systemFont(ofSize: 36, weight: .regular)
            self.leftScoreLabel.textColor = UIColor(named: "label")
            self.rightScoreLabel.textColor = UIColor(named: "info")
            self.leftLabel.font = .systemFont(ofSize: 28, weight: .bold)
            self.rightLabel.font = .systemFont(ofSize: 24, weight: .semibold)
            self.leftLabel.textColor = UIColor(named: "label")
            self.rightLabel.textColor = UIColor(named: "info")
        } else if self.items.0.score < self.items.1.score {
            self.rightScoreLabel.font = .systemFont(ofSize: 42, weight: .black)
            self.leftScoreLabel.font = .systemFont(ofSize: 36, weight: .regular)
            self.rightScoreLabel.textColor = UIColor(named: "label")
            self.leftScoreLabel.textColor = UIColor(named: "info")
            self.rightLabel.font = .systemFont(ofSize: 28, weight: .bold)
            self.leftLabel.font = .systemFont(ofSize: 24, weight: .semibold)
            self.rightLabel.textColor = UIColor(named: "label")
            self.leftLabel.textColor = UIColor(named: "info")
        } else {
            self.leftScoreLabel.font = .systemFont(ofSize: 36, weight: .regular)
            self.rightScoreLabel.font = .systemFont(ofSize: 36, weight: .regular)
            self.leftScoreLabel.textColor = UIColor(named: "info")
            self.rightScoreLabel.textColor = UIColor(named: "info")
            self.leftLabel.font = .systemFont(ofSize: 24, weight: .semibold)
            self.rightLabel.font = .systemFont(ofSize: 24, weight: .semibold)
            self.leftLabel.textColor = UIColor(named: "info")
            self.rightLabel.textColor = UIColor(named: "info")
        }
        self.leftScoreLabel.text = "\(items.0.score)"
        self.rightScoreLabel.text = "\(items.1.score)"
    }
}
