//
//  ProConCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation
import UIKit

class ProConCell: UITableViewCell {
    
    var parent: ProsConsViewController?
    
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "panel-color")
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "label")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(cellPressed))
        
        self.addSubview(view)
        self.addSubview(title)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        
        title.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        title.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        title.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cellPressed() {
//        parent.present(EditProConViewController)
    }
}
