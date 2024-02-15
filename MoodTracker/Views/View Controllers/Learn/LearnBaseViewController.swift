//
//  LearnControlCircleViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/15/24.
//

import Foundation
import UIKit
import MarkdownKit

class LearnBaseViewController: UIViewController {
    let item: LearnItem!
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor(named: "bg-color")
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let imagesView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentLabel: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.backgroundColor = UIColor(named: "bg-color")
        tv.textColor = UIColor(named: "label")
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(named: "label"), for: .normal)
        button.backgroundColor = UIColor(named: "panel-color")
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        
        view.addSubview(scrollView)
        
        if (item.image != nil) {
            scrollView.addSubview(imagesView)
        }
        scrollView.addSubview(contentLabel)
        scrollView.addSubview(doneButton)
        
        imagesView.image = item.image
        
        let markdownParser = MarkdownParser(font: .systemFont(ofSize: 16), color: UIColor(named: "label") ?? .gray)
        LearnManager.getContent(item: item) { content in
            contentLabel.attributedText = markdownParser.parse(content)
        }
        
        setupSubviews()
    }
    
    func setupSubviews() {
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        if item.image != nil {
            imagesView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 15).isActive = true
            imagesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
            imagesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
            imagesView.heightAnchor.constraint(equalToConstant: 256).isActive = true
            contentLabel.topAnchor.constraint(equalTo: imagesView.bottomAnchor, constant: 15).isActive = true
        } else {
            contentLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 15).isActive = true
        }
        
        contentLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -15).isActive = true
        doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        contentLabel.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -15).isActive = true
    }
    
    init(learnItem: LearnItem) {
        self.item = learnItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func donePressed() {
        self.dismiss(animated: true)
    }
}
