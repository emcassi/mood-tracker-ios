//
//  PhotoManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/24/24.
//

import Foundation
import UIKit

class PhotoManager {
    func presentPhotoPicker(parent: UINavigationController, delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate), sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            // Handle the case where the source type is not available (e.g., camera on a simulator)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = delegate
        picker.sourceType = sourceType
        parent.present(picker, animated: true, completion: nil)
    }
    
    // Delegate method to handle the image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Set your imageView to display the selected image
            //                imageView.image = pickedImage
            picker.dismiss(animated: true, completion: nil)
            return pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        return nil
    }
    
    // Optional: Handle cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
