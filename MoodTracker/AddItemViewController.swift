//
//  AddItemViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/6/22.
//

import Foundation
import UIKit

class AddItemViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selectedMoods: [String] = []
    
    // Collection View delegate methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width * 0.27
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mood-cell", for: indexPath) as! MoodCollectionCell
        cell.contentView.backgroundColor = getColorForMood(section: Moods[indexPath.item]["section"] ?? "")
        if let mood = Moods[indexPath.item]["name"] {
            cell.nameLabel.text = mood
            cell.checkmark.isHidden = !selectedMoods.contains(where: { $0 == mood })
        }
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Moods.count

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let mood = Moods[indexPath.item]["name"]{
            if (collectionView.cellForItem(at: indexPath) as! MoodCollectionCell).check() {
                selectedMoods.append(mood)
            } else {
                selectedMoods.removeAll(where: { $0 == mood})
            }
        }
        print(selectedMoods)
    }
    
    // viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(r: 50, g: 66, b: 92)
        collectionView.register(MoodCollectionCell.self, forCellWithReuseIdentifier: "mood-cell")
    }
    
    // Function to get the correct background color for the mood cells based on the section theyre in
    
    func getColorForMood(section: String) -> UIColor {
        switch section {
        case "Sad":
            return UIColor(r: 41, g: 90, b: 163)
        case "Peaceful":
            return UIColor(r: 36, g: 174, b: 199)
        case "Powerful":
            return UIColor(r: 199, g: 112, b: 36)
        case "Joyful":
            return UIColor(r: 199, g: 209, b: 52)
        case "Scared":
            return UIColor(r: 139, g: 52, b: 209)
        case "Mad":
            return UIColor(r: 173, g: 21, b: 21)
        default:
            return UIColor(gray: 117)
        }
    }
}


// Mood cell class

class MoodCollectionCell: UICollectionViewCell {
        
    // is the cell currently checked
    var checked = false
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(gray: 120)
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.clear.cgColor
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkmark: UIImageView = {
       let iv = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        iv.tintColor = .green
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 8
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.black.cgColor
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.clipsToBounds = true
        
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkmark)
//        checkmark.isHidden = checked
        setupSubviews()
    }
    
    func setupSubviews(){
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3).isActive = true
        
        checkmark.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        checkmark.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 16).isActive = true
        checkmark.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    
    
    // called when the cell is selected
    // switches bool and updates checkmark
    
    func check() -> Bool{
        checked = !checked
        checkmark.isHidden = !checked
        return checked
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been initialized")
    }
    
    
}
