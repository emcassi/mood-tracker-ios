//
//  SenseSkillCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/11/24.
//


import Foundation
import UIKit

class SenseSkillCell: UITableViewCell {
    
    let skillLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor(named: "info")
		label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupSubviews(){
        skillLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        skillLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        skillLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = UIColor(named: "panel-color")
        contentView.addSubview(skillLabel)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   }

