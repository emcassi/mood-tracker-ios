//
//  JournalHeaderView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/24/24.
//

import Foundation
import UIKit

class JournalHeaderView: UIView {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "journal")
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "panel-color")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Journal"
        label.textColor = UIColor(named: "info")
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(separator)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 128).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 3).isActive = true

    }
}
