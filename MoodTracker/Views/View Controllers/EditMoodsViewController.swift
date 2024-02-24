//
//  EditMoodsViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 1/24/23.
//


import Foundation
import UIKit

class EditMoodsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var parentVC: UIViewController!
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
        button.tintColor = UIColor(named: "bg-color")
        button.setImage(UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.backgroundColor = UIColor(named: "info")
        button.layer.cornerRadius = 40
        button.layer.zPosition = 100
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 3
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "edit-moods-cell", for: indexPath) as! MoodCollectionCell
        cell.contentView.backgroundColor = getColorForMood(section: Moods[indexPath.item].section)
        
        let mood = Moods[indexPath.item]
        cell.nameLabel.text = mood.name
        cell.checkmark.isHidden = !selectedMoods.contains(where: { $0.name == mood.name })
        cell.contentView.layer.borderColor = selectedMoods.contains(where: { $0.name == mood.name }) ? UIColor.white.cgColor : UIColor.clear.cgColor
        cell.contentView.layer.borderWidth = selectedMoods.contains(where: { $0.name == mood.name }) ? 2 : 0
        
        cell.checked = !cell.checkmark.isHidden
        
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
        collectionView.backgroundColor = UIColor(named: "bg-color")
        collectionView.register(MoodCollectionCell.self, forCellWithReuseIdentifier: "edit-moods-cell")
        
        collectionView.contentInset.bottom = 100
        collectionView.addSubview(nextButton)
        setupNextButton()
    }
    
    // Next button
    
    func setupNextButton(){
        nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    @objc func nextPressed(){
        if selectedMoods.count > 0 {
            if let editVC = parentVC as? EditItemViewController {
                editVC.moods = selectedMoods
            } else if let addVC = parentVC as? AddItemViewController {
                addVC.moods = selectedMoods
                addVC.moodsView.reloadData()
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    // Function to get the correct background color for the mood cells based on the section theyre in
    
    func getColorForMood(section: String) -> UIColor {
        switch section {
        case "Sad":
            return UIColor(named: "mood-sad")!
        case "Fearful":
            return UIColor(named: "mood-fearful")!
        case "Disgusted":
            return UIColor(named: "mood-disgusted")!
        case "Angry":
            return UIColor(named: "mood-angry")!
        case "Happy":
            return UIColor(named: "mood-happy")!
        case "Surprised":
            return UIColor(named: "mood-surprised")!
        default:
            return UIColor(gray: 117)
        }
    }
}


