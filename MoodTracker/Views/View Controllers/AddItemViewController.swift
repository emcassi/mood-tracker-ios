//
//  AddItemViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/6/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddItemViewController : UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var isAdding: Bool = false
    
    let moods: [Mood]
    var moodsString: String = ""
    
    let detailsPlaceholder = "Enter any details"
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let detailsTF: UITextView = {
        let tv = UITextView()
        tv.isEditable = true
        tv.textColor = .lightGray
        tv.font = .systemFont(ofSize: 14)
        tv.backgroundColor = .clear
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 15
        tv.layer.borderColor = UIColor.white.cgColor
        tv.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let moodsView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 110, height: 30)
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.minimumInteritemSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: "checkmark", withConfiguration: largeConfig), for: .normal)
        button.imageView?.tintColor = .white
        button.layer.cornerRadius = 32
        button.backgroundColor = UIColor(named: "done")
        button.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        
        scrollView.addGestureRecognizer(tapGR)
        
        detailsTF.delegate = self
        detailsTF.text = detailsPlaceholder
        
        moodsView.register(HomeMoodCell.self, forCellWithReuseIdentifier: "confirm-mood")
        
        moodsView.dataSource = self
        moodsView.delegate = self
                
        view.addSubview(scrollView)
        scrollView.addSubview(detailsTF)
        scrollView.addSubview(moodsView)
        view.addSubview(addButton)
        setupSubviews()
    }
    
    func setupSubviews(){
        setupScrollView()
        setupDetailsTF()
        setupMoodsView()
        setupAddButton()
    }
    
    func setupScrollView(){
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupDetailsTF() {
        detailsTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailsTF.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 25).isActive = true
        detailsTF.heightAnchor.constraint(equalToConstant: 300).isActive = true
        detailsTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func setupMoodsView(){
        moodsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moodsView.topAnchor.constraint(equalTo: detailsTF.bottomAnchor, constant: 15).isActive = true
        moodsView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        moodsView.heightAnchor.constraint(equalToConstant: 105).isActive = true
    }
    
    func setupAddButton(){
        addButton.topAnchor.constraint(equalTo: moodsView.bottomAnchor, constant: 25).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    // Collection view delegate methods
    
    // Add spaces at the beginning and the end of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = layout.minimumInteritemSpacing
        
        return UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moods.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "confirm-mood", for: indexPath) as? HomeMoodCell {
            
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
        return UICollectionViewCell()
    }
    
    // Text view delegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = detailsPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func screenTapped(){
        scrollView.endEditing(true)
    }
    
    // add button functionality
    
    @objc func addPressed(){
        if(!isAdding){
            isAdding = true
            
            if let user = Auth.auth().currentUser, var details = detailsTF.text {
                if details == detailsPlaceholder {
                    details = ""
                }
                
                let preparedMoods = MoodsManager().prepareMoodsForFirebase(moods: moods)
                
                Firestore.firestore().collection("users").document(user.uid).collection("items").addDocument(data: [
                    "user": user.uid,
                    "moods": preparedMoods,
                    "details": details,
                    "timestamp": Date.now
                ]) { error in
                    if let error = error {
                        print(error)
                        self.isAdding = false
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    
    
    @objc func keyboardWillShow(notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + keyboardSize.height / 2)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    // initializers
    
    init(moods: [Mood]) {
        self.moods = moods
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
