//
//  AuthManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/6/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    
    private var currentUser: User?
    
    func setListener(navVC: NavVC){
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                navVC.popToRootViewController(animated: false)
            } else {
                navVC.pushViewController(WelcomeViewController(), animated: true)
            }
        }
    }
    
    func createUser(vc: UIViewController, email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error)
                return
            }

            vc.dismiss(animated: true)
        }
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    func deleteAccount() {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).delete() { error in
                if let error = error {
                    print(error)
                }
                
            }
            
            user.delete() { error in
                if let error = error {
                    print(error)
                } else {
                    print("Success")
                }
            }
        }
    }
    
}
