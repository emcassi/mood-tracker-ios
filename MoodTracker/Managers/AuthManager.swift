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
import CryptoKit
import AuthenticationServices

class AuthManager  {
    
    func setListener(navVC: NavVC){
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                navVC.popToRootViewController(animated: false)
            } else {
                navVC.pushViewController(WelcomeViewController(), animated: true)
            }
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
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func reAuthApple(idToken: String, rawNonce: String){
        // Initialize a fresh Apple credential with Firebase.
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idToken,
            rawNonce: rawNonce
        )
        // Reauthenticate current Apple user with fresh Apple credential.
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        user.reauthenticate(with: credential) { (authResult, error) in
            guard error != nil else { return }
            // Apple user successfully re-authenticated.
            // ...
        }
    }
    
    static func addSenseItem(sense: Sense, item: String, completion: @escaping (_ newItem: SenseItem) -> Void)  {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let collectionName: String!
        switch sense {
        case Sense.Sight:
            collectionName = "sight"
            break
        case Sense.Sound:
            collectionName = "sound"
            break
        case Sense.Touch:
            collectionName = "touch"
            break
        case Sense.Smell:
            collectionName = "smell"
            break
        case Sense.Taste:
            collectionName = "taste"
            break
        }
        Firestore.firestore().collection("users").document(user.uid).collection("\(collectionName)-items").document().setData([
            "item": item,
            "added": Timestamp(date: .now),
            "key": Double.random(in: 0..<1)
        ]) { err in
            if err != nil {
                print("Error adding sense item: \(err)")
            } else {
                Firestore.firestore().collection("users").document(user.uid).setData(["\(collectionName)-count": FieldValue.increment(Int64(1))], merge: true) { err in
                    completion(SenseItem(item: item, timestamp: .now))
                }
            }
        }
    }
    
}
