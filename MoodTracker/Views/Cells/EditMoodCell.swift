//
//  EditMoodCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 1/23/23.
//

import Foundation
import UIKit

class EditMoodCell : UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var mood: Mood!
    var parent: EditItemViewController!
    
    let moodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteButton: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "x.circle.fill"))
        iv.tintColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false;
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layer.cornerRadius = 15
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(deletePressed))
        tapGR.delegate = self
        deleteButton.addGestureRecognizer(tapGR)
        deleteButton.isUserInteractionEnabled = true
        
        addSubview(moodLabel)
        addSubview(deleteButton)
        
        setupSubviews()
    }
    
    func setupSubviews(){
        moodLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        moodLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
         
    }
    
    @objc func deletePressed(){
        parent.deleteMood(mood: self.mood)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

