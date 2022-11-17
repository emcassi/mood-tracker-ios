//
//  OverviewMoodCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/17/22.
//

import Foundation
import UIKit

class OverviewMoodCell: UICollectionViewCell {
        
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let percentView: UIProgressView = {
        let pv = UIProgressView()
        pv.backgroundColor = UIColor(named: "darker")
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(label)
        addSubview(percentView)
        setupSubviews()
    }
    
    func setupSubviews(){
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
