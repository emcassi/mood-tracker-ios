//
//  MoodCollectionCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/7/22.
//

import Foundation
import UIKit

class MoodCollectionCell: UICollectionViewCell {
        
    // is the cell currently checked
    var checked = false
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkmark: UIImageView = {
       let iv = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        iv.tintColor = .green
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 8
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.black.cgColor
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.clipsToBounds = true
        
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkmark)
//        checkmark.isHidden = checked
        setupSubviews()
    }
    
    func setupSubviews(){
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3).isActive = true
        
        checkmark.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        checkmark.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 16).isActive = true
        checkmark.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    
    
    // called when the cell is selected
    // switches bool and updates checkmark
    
    func check() -> Bool{
        checked = !checked
        checkmark.isHidden = !checked
        contentView.layer.borderColor = checked ? UIColor.white.cgColor : UIColor.clear.cgColor
        contentView.layer.borderWidth = checked ? 2 : 0
        return checked
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been initialized")
    }
    
    
}
