//
//  HomeItemCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/7/22.
//

import Foundation
import UIKit

class HomeItemCell: UITableViewCell {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor(gray: 200)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let moodsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupSubviews(){
        timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        moodsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        moodsLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
        moodsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        moodsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        detailsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: moodsLabel.bottomAnchor, constant: 10).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(gray: 100)
        
        addSubview(timeLabel)
        addSubview(moodsLabel)
        addSubview(detailsLabel)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   }

