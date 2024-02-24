//
//  ProsConsOverviewCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/22/24.
//

import Foundation
import UIKit

class ProsConsOverviewCell: UITableViewCell {
    
    var date: Date?
    var parent: UITableViewController?
    var item: ProsCons?
    
    let button: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(named: "panel-color")
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor(named: "label")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(named: "info")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(button)
        
        button.addSubview(titleLabel)
        button.addSubview(dateLabel)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(buttonPressed))
        self.addGestureRecognizer(tapGR)

        setupSubviews()
    }
        
    func setupSubviews() {
        button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -15).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
    }
    
    func setDate(date: Date) {
        self.date = date
        let df = DateFormatter()
        
        df.dateFormat = "EEEE, MMMM d - h:mm a"
        self.dateLabel.text = df.string(from: date)
    }
    
    @objc func buttonPressed() {
        guard let user = AuthManager.user else {
            AuthManager().logout()
            return
        }
        guard let item = user.prosCons.first(where: { $0.id == item!.id })  else { return }
        let vc = ProsConsViewController(item: item)
        parent?.present(vc, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
