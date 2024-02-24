//
//  CopingSkillView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/17/24.
//

import Foundation
import UIKit

class CopingSkillView: UIButton {
    
    let iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(named: "info")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(named: "label")
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String, icon: String) {
        super.init(frame: CGRect.zero)
        
        label.text = title
        iconView.image = UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large))
        
        self.backgroundColor = UIColor(named: "panel-color")
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 15
        
        addSubview(iconView)
        addSubview(label)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        iconView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
    }
}
