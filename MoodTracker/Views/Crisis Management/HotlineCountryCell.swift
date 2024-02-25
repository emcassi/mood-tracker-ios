//
//  HotlineCountryCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/24/24.
//

import Foundation
import UIKit

class HotlineCountryCell: UITableViewCell {
    
    var country: HotlineCountry?
    
    let emojiView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(named: "label")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(emojiView)
        self.addSubview(countryLabel)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        emojiView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        emojiView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        emojiView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        countryLabel.leftAnchor.constraint(equalTo: emojiView.rightAnchor, constant: 15).isActive = true
        countryLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        countryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setupCountryInfo() {
        if let country = country {
            countryLabel.text = country.name
            emojiView.text = country.emoji
        }
    }
}
