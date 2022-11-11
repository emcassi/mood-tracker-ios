//
//  HomeMoodCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/8/22.
//

import Foundation
import UIKit

class HomeMoodCell : UICollectionViewCell {
    
    let moodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        addSubview(moodLabel)
        
        setupSubviews()
    }
    
    func setupSubviews(){
        moodLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        moodLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
