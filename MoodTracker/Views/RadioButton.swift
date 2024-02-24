//
//  RadioButton.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation
import UIKit

class RadioButton : UIButton {
    
    let title: String!
    
    let marker: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)))
        iv.backgroundColor = .clear
        iv.tintColor = UIColor(named: "done")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(named: "label")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        self.layer.borderWidth = 3
        self.setTitle(title, for: .normal)
        self.layer.borderColor = (UIColor(named: "AccentColor") ?? UIColor.gray).cgColor
        self.backgroundColor = UIColor(named: "panel-color")
        self.layer.cornerRadius = 15
        
        label.text = title
    }
    
    func setupSubviews() {
        marker.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        marker.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        marker.widthAnchor.constraint(equalToConstant: 24).isActive = true
        marker.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        label.leftAnchor.constraint(equalTo: marker.rightAnchor, constant: 15).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setActive(_ active: Bool) {
        if active{
            self.layer.borderWidth = 3
        } else {
            self.layer.borderWidth = 0
        }
    }
}
