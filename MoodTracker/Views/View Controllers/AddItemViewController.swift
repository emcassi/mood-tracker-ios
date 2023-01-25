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

class AddItemViewController : UIViewController, UITextViewDelegate {
    
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
        tv.layer.borderColor = UIColor.white.cgColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    let moodsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "purple")
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
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
        
        moodsLabel.text = MoodsManager().makeMoodsString(moods: moods)
        
        view.addSubview(scrollView)
        scrollView.addSubview(detailsTF)
        scrollView.addSubview(moodsLabel)
        view.addSubview(addButton)
        setupSubviews()
    }
    
    func setupSubviews(){
        setupScrollView()
        setupDetailsTF()
        setupMoodsLabel()
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
    
    func setupMoodsLabel(){
        moodsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moodsLabel.topAnchor.constraint(equalTo: detailsTF.bottomAnchor, constant: 25).isActive = true
        moodsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func setupAddButton(){
        addButton.topAnchor.constraint(equalTo: moodsLabel.bottomAnchor, constant: 25).isActive = true
        addButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
