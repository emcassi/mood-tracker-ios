//
//  DayHeader.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/17/22.
//

import Foundation
import UIKit

class DayHeader: UIView {
    
    let navController: UINavigationController!
    let items: [MoodsItem]
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let overviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Overview", for: .normal)
        button.setTitleColor(UIColor(named: "lighter"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(nc: UINavigationController, items: [MoodsItem]){
        self.navController = nc
        self.items = items
        super.init(frame: .zero)
        
        addSubview(dateLabel)
        addSubview(overviewButton)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews(){
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        overviewButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        overviewButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        overviewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        overviewButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func buttonTapped(){
        self.navController.present(DayOverviewViewController(items: items), animated: true)
    }
}
