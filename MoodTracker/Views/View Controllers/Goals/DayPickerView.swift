//
//  DayPickerView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/18/24.
//

import Foundation
import UIKit

enum Day: Int {
    case Monday = 0
    case Tuesday = 1
    case Wednesday = 2
    case Thursday = 3
    case Friday = 4
    case Saturday = 5
    case Sunday = 6
    case Daily = 7
    case Weekdays = 8
    case Weekends = 9
}
    
let everyday: Set<Day> = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
let everydayOption: Set<Day> = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday, .Daily, .Weekdays, .Weekends]
let weekdays: Set<Day> = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Weekdays]
let weekends: Set<Day> = [.Saturday, .Sunday]

class DayPickerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var daysPicked: Set<Day> = []
    let onSelect: () -> Void
    
    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Frequency"
        label.textColor = UIColor(named: "label")
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = CenterAlignedCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 125, height: 40)
        flowLayout.minimumLineSpacing = 15.0
        flowLayout.minimumInteritemSpacing = 15
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor(named: "panel-color")
        view.layer.cornerRadius = 15
        view.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(onSelect: @escaping () -> Void) {
        self.onSelect = onSelect
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "panel-color")
        self.layer.cornerRadius = 15
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DayPickerCell.self, forCellWithReuseIdentifier: "day-picker-cell")
        
        self.addSubview(frequencyLabel)
        self.addSubview(collectionView)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        frequencyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        frequencyLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        frequencyLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: 15).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "day-picker-cell", for: indexPath) as? DayPickerCell {
            if let day = Day(rawValue: indexPath.row) {
                cell.setDay(day)
                cell.picked = daysPicked.contains(day)
                cell.pickLogic()
            }
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.shadowOpacity = 0.3

            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let day = Day(rawValue: indexPath.row) {
            
            if daysPicked.contains(day) {
                switch day {
                case .Daily:
                    daysPicked = []
                    break
                case .Weekdays:
                    for tempDay in weekdays {
                        daysPicked.remove(tempDay)
                    }
                    break
                case .Weekends:
                    for tempDay in weekends {
                        daysPicked.remove(tempDay)
                    }
                    break
                default:
                    daysPicked.remove(day)
                    break
                }
            } else {
                switch day {
                case .Daily:
                    daysPicked = everydayOption
                    break
                case .Weekdays:
                    for tempDay in weekdays {
                        daysPicked.insert(tempDay)
                    }
                    break
                case .Weekends:
                    for tempDay in weekends {
                        daysPicked.insert(tempDay)
                    }
                    break
                default:
                    daysPicked.insert(day)
                    break
                }
            }
            
            if includesEveryDay(days: daysPicked) {
                daysPicked.insert(.Daily)
                daysPicked.insert(.Weekdays)
                daysPicked.insert(.Weekends)
            } else {
                daysPicked.remove(.Daily)
                if includesEveryWeekday(days: daysPicked) {
                    daysPicked.insert(.Weekdays)
                } else {
                    daysPicked.remove(.Weekdays)
                }
                
                if includesEveryWeekend(days: daysPicked) {
                    daysPicked.insert(.Weekends)
                } else {
                    daysPicked.remove(.Weekends)
                }
            }
            
            onSelect()
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return everydayOption.count
    }
    
    func includesEveryDay(days: Set<Day>) -> Bool {
        for day in everyday {
            if !days.contains(day) {
                return false
            }
        }
        return true
    }
    
    func includesEveryWeekday(days: Set<Day>) -> Bool {
        for day in weekdays {
            if !days.contains(day) {
                return false
            }
        }
        return true
    }
    
    func includesEveryWeekend(days: Set<Day>) -> Bool {
        for day in weekends {
            if !days.contains(day) {
                return false
            }
        }
        return true
    }
    
}
