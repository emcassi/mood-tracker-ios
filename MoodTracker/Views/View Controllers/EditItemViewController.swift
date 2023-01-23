//
//  EditItemViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 1/23/23.
//

import Foundation
import UIKit

class EditItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var item: MoodsItem? = nil
    
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
        tv.textColor = .lightGray
        tv.font = .systemFont(ofSize: 14)
        tv.backgroundColor = .clear
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.white.cgColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        scrollView.addGestureRecognizer(tapGR)
        
        if let item = item {
            dateLabel.text = item.timestamp.formatted(date: .abbreviated, time: .omitted)
            timeLabel.text = item.timestamp.formatted(date: .omitted, time: .shortened)
            detailsTF.text = item.details
        }
        
        moodsView.register(EditMoodCell.self, forCellWithReuseIdentifier: "edit-mood")
        
        moodsView.dataSource = self
        moodsView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(moodsView)
        scrollView.addSubview(detailsTF)
        
        setupSubviews()
    }
    
    // Add spaces at the beginning and the end of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let item = item {
            print(item.moods.count)
            return item.moods.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "edit-mood", for: indexPath) as? EditMoodCell {
            
            switch self.item!.moods[indexPath.item].section {
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
            cell.mood = self.item!.moods[indexPath.item]
            cell.moodLabel.text = cell.mood.name
        
            return cell
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
        
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 15).isActive = true
        
        moodsView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
        moodsView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor).isActive = true
        moodsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        moodsView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        detailsTF.topAnchor.constraint(equalTo: moodsView.bottomAnchor, constant: 5).isActive = true
        detailsTF.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 10).isActive = true
        detailsTF.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor, constant: -10).isActive = true
        detailsTF.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func deleteMood(mood: Mood){
        var updatedMoods = item!.moods
        let deleteIndex = updatedMoods.firstIndex(where: {$0.name == mood.name })
        updatedMoods.remove(at: deleteIndex! as Int)
        item!.moods = updatedMoods
    }
    
    @objc func screenTapped(){
        
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
