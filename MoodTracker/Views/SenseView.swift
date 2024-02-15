//
//  SenseView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/13/24.
//

import Foundation
import UIKit

class SenseView: UIView {
    
    let sense: Sense!
    
    let image:  UIImageView = {
        let view = UIImageView()
        view.tintColor = UIColor(named: "info")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let prompt: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = UIColor(named: "info")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let item: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(named: "label")
        label.backgroundColor = UIColor(named: "panel-color")
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(sense: Sense) {
        self.sense = sense
        super.init(frame: CGRect.zero)
        
        self.addSubview(image)
        self.addSubview(prompt)
        self.addSubview(item)
        
        setupSubviews()
    }

    func setupSubviews() {
        image.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 48).isActive = true
        image.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        prompt.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 15).isActive = true
        prompt.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        prompt.heightAnchor.constraint(equalTo: image.heightAnchor).isActive = true
        
        item.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        item.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        item.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        item.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
