//
//  AddJournalSection.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/24/24.
//

import Foundation
import UIKit

class AddJournalSection: UIView {
    
    let title: String
    let subview: UIView
    let onAdd: () -> Void
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(named: "label")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = UIColor(named: "info")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "panel-color")
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(title: String, view: UIView, canAdd: Bool = false, onAdd: @escaping () -> Void) {
        self.title = title
        self.subview = view
        self.onAdd = onAdd
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "bg-color")
        
        titleLabel.text = title
        if canAdd {
            addButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        } else {
            addButton.isHidden = true
        }
        self.addSubview(titleLabel)
        self.addSubview(addButton)
        self.addSubview(sectionView)
        sectionView.addSubview(subview)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        addButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        titleLabel.rightAnchor.constraint(equalTo: addButton.leftAnchor).isActive = true
        
        sectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        sectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        subview.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 5).isActive = true
        subview.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -5).isActive = true
        subview.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 5).isActive = true
        subview.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addPressed() {
        self.onAdd()
    }
}
