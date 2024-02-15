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

class MudiUser {
    var user: User
    var breathOptions: BreathOptions
    
    init(_ user: User) {
        self.user = user
        self.breathOptions = BreathOptions(inhaleLength: Defaults.breathInhaleLength, exhaleLength: Defaults.breathExhaleLength, holdLength: Defaults.breathHoldLength)
        AuthManager.getUserInfo()
    }
}

class AuthManager  {
    
    static var user: MudiUser?
    
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
            AuthManager.user = nil
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
                    AuthManager.user = nil
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
            AuthManager.user = MudiUser(user)
        }
    }
    
    static func addSenseItem(sense: Sense, item: String, completion: @escaping (_ newItem: SenseItem) -> Void)  {
        guard let user = Auth.auth().currentUser else {
            return
        }
        var collectionName = ""
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
    
    static func getUserInfo() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        Firestore.firestore().collection("users").document(user.uid).getDocument() { snapshot, err in
            if err != nil {
                print("Error retrieving user data")
                return
            }
            
            AuthManager.user?.breathOptions.inhaleLength = snapshot!.data()!["inhale-length"] as? Int ?? Defaults.breathInhaleLength
            AuthManager.user?.breathOptions.exhaleLength = snapshot!.data()!["exhale-length"] as? Int ?? Defaults.breathExhaleLength
            AuthManager.user?.breathOptions.holdLength = snapshot!.data()!["hold-length"] as? Int ?? Defaults.breathHoldLength
        }
    }
}
