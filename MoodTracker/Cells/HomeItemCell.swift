//
//  HomeItemCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/7/22.
//

import Foundation
import UIKit

class HomeItemCell: UITableViewCell {

    let moodsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupSubviews(){
        moodsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        moodsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        moodsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        detailsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: moodsLabel.bottomAnchor, constant: 10).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
    }
    
       override func awakeFromNib() {
           super.awakeFromNib()

           addSubview(moodsLabel)
           addSubview(detailsLabel)
           
           setupSubviews()
       }

   }

