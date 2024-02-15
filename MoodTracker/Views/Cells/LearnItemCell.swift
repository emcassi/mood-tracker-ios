//
//  LearnItemCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/15/24.
//

import Foundation
import UIKit

class LearnItemCell: UITableViewCell {
    var item: LearnItem?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "info")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(named: "panel-color")
        self.layer.cornerRadius = 15
        self.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
