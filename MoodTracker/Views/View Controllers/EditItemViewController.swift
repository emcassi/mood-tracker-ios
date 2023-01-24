//
//  EditItemViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 1/23/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var item: MoodsItem? = nil
    var moods: [Mood] = []
    var bEditing = false
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor(named: "bg-color")
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    
    let timeLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(gray: 180)
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    
    let moodsView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 110, height: 30)
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.minimumInteritemSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let detailsTF: UITextView = {
        let tv = UITextView()
        tv.isEditable = true
        tv.textColor = .white
        tv.font = .systemFont(ofSize: 14)
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 15
        tv.layer.borderColor = UIColor.white.cgColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let topButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(topPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bottomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "purple")
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(bottomPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(screenPressed))
        scrollView.addGestureRecognizer(tapGR)
        
        if let item = item {
            dateLabel.text = item.timestamp.formatted(date: .abbreviated, time: .omitted)
            timeLabel.text = item.timestamp.formatted(date: .omitted, time: .shortened)
            detailsTF.text = item.details
        }
        
        moods = item!.moods
        
        moodsView.register(HomeMoodCell.self, forCellWithReuseIdentifier: "nonedit-mood")

        moodsView.register(EditMoodCell.self, forCellWithReuseIdentifier: "edit-mood")
        
        moodsView.dataSource = self
        moodsView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(moodsView)
        scrollView.addSubview(detailsTF)
        scrollView.addSubview(topButton)
        scrollView.addSubview(bottomButton)
        
        setupSubviews()
    }
    
    // Add spaces at the beginning and the end of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = layout.minimumInteritemSpacing
        
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let item = item {
            print(moods.count)
            return moods.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(bEditing){
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "edit-mood", for: indexPath) as? EditMoodCell {
                
                switch moods[indexPath.item].section {
                case "Sad":
                    cell.backgroundColor = UIColor(named: "mood-blue")
                case "Peaceful":
                    cell.backgroundColor = UIColor(named: "mood-aqua")
                case "Powerful":
                    cell.backgroundColor = UIColor(named: "mood-yellow")
                case "Joyful":
                    cell.backgroundColor = UIColor(named: "mood-orange")
                case "Mad":
                    cell.backgroundColor = UIColor(named: "mood-red")
                case "Scared":
                    cell.backgroundColor = UIColor(named: "mood-purple")
                default:
                    cell.backgroundColor = .gray
                }
                
                cell.parent = self
                cell.mood = self.moods[indexPath.item]
                cell.moodLabel.text = cell.mood.name
                
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nonedit-mood", for: indexPath) as? HomeMoodCell {
                
                switch moods[indexPath.item].section {
                case "Sad":
                    cell.backgroundColor = UIColor(named: "mood-blue")
                case "Peaceful":
                    cell.backgroundColor = UIColor(named: "mood-aqua")
                case "Powerful":
                    cell.backgroundColor = UIColor(named: "mood-yellow")
                case "Joyful":
                    cell.backgroundColor = UIColor(named: "mood-orange")
                case "Mad":
                    cell.backgroundColor = UIColor(named: "mood-red")
                case "Scared":
                    cell.backgroundColor = UIColor(named: "mood-purple")
                default:
                    cell.backgroundColor = .gray
                }
                
                cell.moodLabel.text = self.moods[indexPath.item].name
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
    func setupSubviews(){
        
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        dateLabel.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 15).isActive = true
        dateLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 15).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 15).isActive = true
        
        moodsView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
        moodsView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor).isActive = true
        moodsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        moodsView.heightAnchor.constraint(equalToConstant: 105).isActive = true
        
        detailsTF.topAnchor.constraint(equalTo: moodsView.bottomAnchor, constant: 15).isActive = true
        detailsTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailsTF.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
        detailsTF.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        topButton.topAnchor.constraint(equalTo: detailsTF.bottomAnchor, constant: 50).isActive = true
        topButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.6).isActive = true
        topButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        topButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bottomButton.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: 15).isActive = true
        bottomButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.6).isActive = true
        bottomButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        bottomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
    
    func deleteMood(mood: Mood){
        var updatedMoods = moods
        let deleteIndex = updatedMoods.firstIndex(where: {$0.name == mood.name })
        updatedMoods.remove(at: deleteIndex! as Int)
        moods = updatedMoods
        moodsView.reloadData()
    }
    
    func isSame() -> Bool {
        if let item = item{
            
            if detailsTF.text! != item.details {
                return false
            }
            
            if moods.count != item.moods.count {
                return false
            }
            
            for i in 0..<item.moods.count {
                if item.moods[i].name != moods[i].name {
                    return false
                }
            }
        }
        
        return true
    }
    
    func startEditing() {
        bEditing = true
        topButton.setTitle("Cancel", for: .normal)
        topButton.setTitleColor(.red, for: .normal)
        
        bottomButton.setTitle("Save", for: .normal)
        
        moodsView.reloadData()
        
        detailsTF.isEditable = true
    }
    
    func stopEditing() {
        bEditing = false
        
        topButton.setTitle("Edit", for: .normal)
        topButton.setTitleColor(.white, for: .normal)
        
        bottomButton.setTitle("Done", for: .normal)
        
        if let item = item {
            detailsTF.text = item.details
            moods = item.moods
        }
        
        detailsTF.isEditable = false
        
        moodsView.reloadData()
    }
    
    func save(){
        
        if let user = Auth.auth().currentUser, let item = item {
            
            let preparedMoods = MoodsManager().prepareMoodsForFirebase(moods: moods)
            
            Firestore.firestore().collection("users").document(user.uid).collection("items").document(item.id).updateData([
            
                "moods": preparedMoods,
                "details": detailsTF.text!
            
            ], completion: { error in
                
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func cancel(){
        
        if !isSame() {
            let alert = UIAlertController(title: "Cancel?", message: "Are you sure you want to cancel editing?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                alert.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                alert.dismiss(animated: true)
                self.stopEditing()
            }))
            
            self.present(alert, animated: true)
        } else {
            self.stopEditing()
        }
    }
    
    @objc func screenPressed(){
        scrollView.endEditing(true)
    }
    
    @objc func topPressed(){
        if(bEditing){
            cancel()
        } else {
            startEditing()
        }
    }
    
    @objc func bottomPressed(){
        if(bEditing){
            save()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    init(item: MoodsItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
