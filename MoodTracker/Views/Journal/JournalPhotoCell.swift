//
//  JournalPhotoCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/24/24.
//

import Foundation
import UIKit

class JournalPhotoCell: UICollectionViewCell {
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = UIColor(named: "light")
        button.backgroundColor = UIColor(named: "dangerous")
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.addSubview(deleteButton)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
