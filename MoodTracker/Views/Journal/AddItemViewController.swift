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
import FirebaseAnalytics
import StoreKit

class AddItemViewController : UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isAdding: Bool = false
    
    var moods: [Mood]
    var moodsString: String = ""
    
    let detailsPlaceholder = "Enter any details"
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var detailsView: AddJournalSection = {
        let view = AddJournalSection(title: "Details", view: UIView(), canAdd:  false) {}
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var moodsSection: AddJournalSection = {
        let view = AddJournalSection(title: "Moods", view: UIView(), canAdd:  false) {}
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    let detailsTF: UITextView = {
        let tv = UITextView()
        tv.isEditable = true
        tv.textColor = UIColor(named: "info")
        tv.font = .systemFont(ofSize: 14)
        tv.backgroundColor = UIColor(named: "panel-color")
        tv.layer.borderWidth = 0
        tv.layer.cornerRadius = 15
        tv.layer.shadowColor = UIColor.black.cgColor
        tv.layer.shadowOffset = CGSize(width: 2, height: 2)
        tv.layer.shadowOpacity = 0.3
        tv.layer.shadowRadius = 15
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
    
    lazy var photosSection: AddJournalSection = {
        let view = AddJournalSection(title: "Photos", view: UIView(), canAdd: true) {}
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var photosView: AddJournalPhotosView?
    
    let addButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: "checkmark", withConfiguration: largeConfig), for: .normal)
        button.imageView?.tintColor = .white
        button.layer.cornerRadius = 48
        button.backgroundColor = UIColor(named: "AccentColor")
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
        
        addButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        detailsView = AddJournalSection(title: "Details", view: detailsTF, canAdd:  false) {}
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        
        moodsSection = AddJournalSection(title: "Moods", view: moodsView, canAdd:  true) {
            let editVC = EditMoodsViewController(collectionViewLayout: UICollectionViewFlowLayout())
            editVC.parentVC = self
            editVC.selectedMoods = self.moods
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        moodsSection.translatesAutoresizingMaskIntoConstraints = false
        
        
        photosView = AddJournalPhotosView(parent: self.navigationController!, delegate: self)
        photosView!.translatesAutoresizingMaskIntoConstraints = false
        photosSection = AddJournalSection(title: "Photos", view: photosView!, canAdd:  true) {
            self.presentPicker()
        }
        photosSection.translatesAutoresizingMaskIntoConstraints = false

        detailsTF.delegate = self
        detailsTF.text = detailsPlaceholder
        
        moodsView.register(HomeMoodCell.self, forCellWithReuseIdentifier: "confirm-mood")
        
        moodsView.dataSource = self
        moodsView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(detailsView)
        scrollView.addSubview(moodsSection)
        scrollView.addSubview(photosSection)
        view.addSubview(addButton)
        setupSubviews()
    }
    
    func setupSubviews(){
        setupScrollView()
        setupDetailsTF()
        setupMoodsView()
        setupPhotosSection()
        setupAddButton()
    }
    
    func setupScrollView(){
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupDetailsTF() {
        detailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 25).isActive = true
        detailsView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        detailsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func setupMoodsView(){
        moodsSection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moodsSection.topAnchor.constraint(equalTo: detailsTF.bottomAnchor, constant: 15).isActive = true
        moodsSection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        moodsSection.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupPhotosSection(){
        photosSection.topAnchor.constraint(equalTo: moodsView.bottomAnchor, constant: 15).isActive = true
        photosSection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photosSection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        photosSection.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupAddButton(){
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 96).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 96).isActive = true
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
                cell.backgroundColor = UIColor(named: "mood-sad")
            case "Fearful":
                cell.backgroundColor = UIColor(named: "mood-fearful")
            case "Disgusted":
                cell.backgroundColor = UIColor(named: "mood-disgusted")
            case "Angry":
                cell.backgroundColor = UIColor(named: "mood-angry")
            case "Happy":
                cell.backgroundColor = UIColor(named: "mood-happy")
            case "Surprised":
                cell.backgroundColor = UIColor(named: "mood-surprised")
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
        if textView.text == detailsPlaceholder {
            textView.text = nil
            textView.textColor = UIColor(named: "label")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = detailsPlaceholder
            textView.textColor = UIColor(named: "info")
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
                let timestamp = Date.now
                Firestore.firestore().collection("users").document(user.uid).collection("items").addDocument(data: [
                    "user": user.uid,
                    "moods": preparedMoods,
                    "details": details,
                    "timestamp": timestamp
                ]) { error in
                    if let error = error {
                        print(error)
                        self.isAdding = false
                    } else {
                        Firestore.firestore().collection("users").document(user.uid).updateData([
                            "numPosts": FieldValue.increment(Int64(1)),
                            "lastPostTimestamp": timestamp
                        ])
                    }
                    let numAdded = UserDefaults.standard.integer(forKey: "moodsAdded") + 1
                    UserDefaults.standard.set(numAdded, forKey: "moodsAdded")
                    if numAdded > 0 && numAdded % 10 == 0 {
                        if let windowScene = self.view.window?.windowScene {
                            SKStoreReviewController.requestReview(in: windowScene)
                        }
                    }
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func tryForReview() {
        
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
    
    @objc func presentPicker() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                PhotoManager().presentPhotoPicker(parent: self.navigationController!, delegate: self, sourceType: .camera)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            PhotoManager().presentPhotoPicker(parent: self.navigationController!, delegate: self, sourceType: .photoLibrary)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
