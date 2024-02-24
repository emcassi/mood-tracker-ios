//
//  AddJournalPhotosView.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/24/24.
//

import Foundation
import UIKit

class AddJournalPhotosView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: UINavigationController
    var delegate: (UINavigationControllerDelegate & UIImagePickerControllerDelegate)
    var photos: [UIImage]
    
    let emptyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photos"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(named: "info")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emptyImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
        view.tintColor = UIColor(named: "info")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(parent: UINavigationController, delegate: (UINavigationControllerDelegate & UIImagePickerControllerDelegate)) {
        self.parent = parent
        self.delegate = delegate
        photos = []
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "panel-color")
        
        emptyButton.addTarget(self, action: #selector(presentPicker), for: .touchUpInside)
        self.addSubview(emptyButton)
        emptyButton.addSubview(emptyLabel)
        emptyButton.addSubview(emptyImage)
        
        setupSubviews()
    }
    
    init(parent: UINavigationController, delegate: (UINavigationControllerDelegate & UIImagePickerControllerDelegate), photos: [UIImage]) {
        self.parent = parent
        self.delegate = delegate
        self.photos = photos
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "panel-color")
        
        emptyButton.addTarget(self, action: #selector(presentPicker), for: .touchUpInside)
        
        self.addSubview(emptyButton)
        emptyButton.addSubview(emptyLabel)
        emptyButton.addSubview(emptyImage)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        emptyButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        emptyButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        emptyButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        emptyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        emptyImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emptyImage.bottomAnchor.constraint(equalTo: emptyButton.centerYAnchor, constant: -5).isActive = true
        
        emptyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emptyLabel.topAnchor.constraint(equalTo: emptyButton.centerYAnchor, constant: 5).isActive = true
        emptyLabel.bottomAnchor.constraint(equalTo: emptyButton.bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            // Handle the case where the source type is not available (e.g., camera on a simulator)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        parent.present(picker, animated: true, completion: nil)
    }
    
    // Delegate method to handle the image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Set your imageView to display the selected image
            //                imageView.image = pickedImage
            self.photos.append(pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Optional: Handle cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func presentPicker() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.presentPhotoPicker(sourceType: .camera)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            PhotoManager().presentPhotoPicker(parent: self.parent, delegate: self.delegate, sourceType: .photoLibrary)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        parent.present(alertController, animated: true, completion: nil)
    }
}
