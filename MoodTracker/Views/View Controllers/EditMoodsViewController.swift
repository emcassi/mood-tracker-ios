//
//  EditMoodsViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 1/24/23.
//


import Foundation
import UIKit

class EditMoodsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var parentVC: EditItemViewController! 
    var selectedMoods: [Mood] = []
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "How are you feeling?"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "purple")
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
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
        
        let mood = Moods[indexPath.item]
        cell.nameLabel.text = mood.name
        cell.checkmark.isHidden = !selectedMoods.contains(where: { $0.name == mood.name })
        
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Moods.count

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mood = Moods[indexPath.item]
        if (collectionView.cellForItem(at: indexPath) as! MoodCollectionCell).check() {
            selectedMoods.append(mood)
        } else {
            selectedMoods.removeAll(where: { $0.name == mood.name})
        }
            
        nextButton.isHidden = selectedMoods.count < 1
        
    }
    
    // viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "How do you feel?"
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
            
            parentVC.moods = selectedMoods
            
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    // Function to get the correct background color for the mood cells based on the section theyre in
    
    func getColorForMood(section: String) -> UIColor {
        switch section {
        case "Sad":
            return UIColor(named: "mood-blue")!
        case "Peaceful":
            return UIColor(named: "mood-aqua")!
        case "Powerful":
            return UIColor(named: "mood-yellow")!
        case "Joyful":
            return UIColor(named: "mood-orange")!
        case "Scared":
            return UIColor(named: "mood-purple")!
        case "Mad":
            return UIColor(named: "mood-red")!
        default:
            return UIColor(gray: 117)
        }
    }
}


