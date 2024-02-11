//
//  CopeMethodCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/10/24.
//


import Foundation
import UIKit

class ChartLegendCell: UICollectionViewCell {
        
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(named: "info")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(colorView)
        contentView.addSubview(nameLabel)
        
        setupSubviews()
    }
    
    func setupSubviews(){
        colorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -5).isActive = true
        colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: colorView.rightAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 50).isActive = true
    }
    
    
 
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been initialized")
    }
    
    
}
