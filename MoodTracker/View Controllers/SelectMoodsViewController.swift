//
//  AddItemViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/6/22.
//

import Foundation
import UIKit

class SelectMoodsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selectedMoods: [String] = []
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "purple")
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.isHidden = true
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        cell.contentView.backgroundColor = getColorForMood(section: Moods[indexPath.item].section)
        
        let mood = Moods[indexPath.item].name
        cell.nameLabel.text = mood
        cell.checkmark.isHidden = !selectedMoods.contains(where: { $0 == mood })
        
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Moods.count

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mood = Moods[indexPath.item].name
        if (collectionView.cellForItem(at: indexPath) as! MoodCollectionCell).check() {
            selectedMoods.append(mood)
        } else {
            selectedMoods.removeAll(where: { $0 == mood})
        }
            
        nextButton.isHidden = selectedMoods.count < 1
        
    }
    
    // viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(r: 50, g: 66, b: 92)
        collectionView.register(MoodCollectionCell.self, forCellWithReuseIdentifier: "mood-cell")
        
        collectionView.addSubview(nextButton)
        setupNextButton()
    }
    
    // Next button
    
    func setupNextButton(){
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
    }
    
    @objc func nextPressed(){
        if selectedMoods.count > 0 {
            
            var moods: [Mood] = []
            
            for mood in Moods {
                if selectedMoods.contains(where: { $0 == mood.name }) {
                    moods.append(mood)
                }
            }
            
            navigationController?.pushViewController(AddItemViewController(moods: moods), animated: true)
        }
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


