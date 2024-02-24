//
//  DayPickerCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/18/24.
//

import Foundation
import UIKit

class DayPickerCell: UICollectionViewCell {
    var picked: Bool = false
    var day: Day?
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(named: "dark")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pickedImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "smallcircle.filled.circle.fill")
        view.tintColor = UIColor(named: "AccentColor")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: "grey")
        self.layer.borderColor = (UIColor(named: "AccentColor") ?? UIColor.blue).cgColor
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 20

        pickLogic()
        
        self.addSubview(dayLabel)
        self.addSubview(pickedImage)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        pickedImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        pickedImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pickedImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        pickedImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        dayLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dayLabel.rightAnchor.constraint(equalTo: pickedImage.leftAnchor, constant: -5).isActive = true
    }
    
    func togglePicked() {
        picked = !picked
        pickLogic()
    }
    
    func pickLogic() {
        if picked {
            self.layer.borderWidth = 3
            pickedImage.isHidden = false
        } else {
            self.layer.borderWidth = 0
            pickedImage.isHidden = true
        }
    }
    
    func setDay(_ day: Day) {
        self.day = day
        dayLabel.text = getDayNameFromDay(day)
    }
    
    func getDayNameFromDay(_ day: Day) -> String {
        switch day {
        case .Daily:
            return "Daily"
        case .Weekdays:
            return "Weekdays"
        case .Weekends:
            return "Weekends"
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        case .Saturday:
            return "Saturday"
        case .Sunday:
            return "Sunday"
        }
    }
}
