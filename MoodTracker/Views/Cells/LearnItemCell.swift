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
    
    let content: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "panel-color")
        view.layer.cornerRadius = 15
        view.layer.borderColor = (UIColor(named: "AccentColor") ?? UIColor.gray).cgColor
        view.layer.borderWidth = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        self.backgroundColor = .clear
        
        self.addSubview(content)
        content.addSubview(nameLabel)
        
        content.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        content.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true

        
        nameLabel.topAnchor.constraint(equalTo: content.topAnchor, constant: 5).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 15).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -15).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
