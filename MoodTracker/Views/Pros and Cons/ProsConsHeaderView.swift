//
//  ProsConsHeaderView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation
import UIKit

class ProsConsHeaderView : UIView {
    
    let parent: ProsConsViewController
    let item: ProsCons!
    
    let pullbar: ModalPullBar = {
        let pullbar = ModalPullBar()
        pullbar.translatesAutoresizingMaskIntoConstraints = false
        return pullbar
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = UIColor(named: "label")
        button.backgroundColor = UIColor(named: "panel-color")
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 0
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = UIColor(named: "light")
        button.backgroundColor = UIColor(named: "dangerous")
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 0
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor(named: "label")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var scoreboard: Scoreboard = Scoreboard()
    
    init(parent: ProsConsViewController, item: ProsCons, width: CGFloat) {
        self.parent = parent
        self.item = item
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: 275)))
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.titleLabel.text = item.title
        
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        
        self.scoreboard = {
            let sb = Scoreboard(items: (ScoreboardItem(name: "Pros", score: item.pros.count), ScoreboardItem(name: "Cons", score: item.cons.count)))
            sb.layer.cornerRadius = 15
            sb.clipsToBounds = true
            sb.translatesAutoresizingMaskIntoConstraints = false
            return sb
        }()
        
        self.addSubview(pullbar)
        self.addSubview(editButton)
        self.addSubview(deleteButton)
        self.addSubview(titleLabel)
        self.addSubview(scoreboard)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        pullbar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pullbar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        pullbar.widthAnchor.constraint(equalToConstant: 64).isActive = true
        pullbar.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        editButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        editButton.topAnchor.constraint(equalTo: pullbar.topAnchor, constant: 15).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        deleteButton.topAnchor.constraint(equalTo: pullbar.topAnchor, constant: 15).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 15).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scoreboard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        scoreboard.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scoreboard.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        scoreboard.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editPressed() {
        parent.present(EditProsConsViewController(parent: parent, item: item), animated: true)
    }
    
    @objc func deletePressed() {
        
    }
}
