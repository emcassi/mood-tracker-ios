//
//  SenseManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SenseManager {
    
    static func getSenseWord(sense: Sense) -> String {
        switch sense {
        case Sense.Sight:
            return "Seeing"
        case Sense.Sound:
            return "Hearing"
        case Sense.Touch:
            return "Feeling"
        case Sense.Smell:
            return "Smelling"
        case Sense.Taste:
            return "Tasting"
            
        }
    }
    
    static func getSenseVerb(sense: Sense) -> String {
        switch sense {
        case Sense.Sight:
            return "see"
        case Sense.Sound:
            return "hear"
        case Sense.Touch:
            return "feel"
        case Sense.Smell:
            return "smell"
        case Sense.Taste:
            return "taste"
            
        }
    }
    
    static func getSenseFromWord(word: String) -> (success: Bool, sense: Sense?) {
        switch word {
        case "Seeing":
            return (true, Sense.Sight)
        case "Hearing":
            return (true, Sense.Sound)
        case "Feeling":
            return (true, Sense.Touch)
        case "Smelling":
            return (true, Sense.Smell)
        case "Tasting":
            return (true, Sense.Taste)
        default:
            return (false, nil)
        }
    }
    
    static func getSenseItemsForUser(completion: @escaping (_: [Sense:[SenseItem]]) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        var items: [Sense:[SenseItem]] = [
            Sense.Sight: [],
            Sense.Sound: [],
            Sense.Touch: [],
            Sense.Smell: [],
            Sense.Taste: [],
        ]
        
        let userDoc = Firestore.firestore().collection("users").document(user.uid)
        
        userDoc.collection("sight-items").getDocuments() { snapshot, err in
            if err != nil {
                return
            }
            
            for doc in snapshot!.documents {
                
                guard let itemText = doc.data()["item"] else {
                    continue
                }
                
                guard let timestamp = doc.data()["added"] else {
                    continue
                }
                
                let date = (timestamp as! Timestamp).dateValue()
                let newItem = SenseItem(item: itemText as! String, timestamp: date)
                items[Sense.Sight]!.append(newItem)
            }
            
            userDoc.collection("sound-items").getDocuments() { snapshot, err in
                if err != nil {
                    return
                }
                
                for doc in snapshot!.documents {
                    
                    guard let itemText = doc.data()["item"] else {
                        continue
                    }
                    
                    guard let timestamp = doc.data()["added"] else {
                        continue
                    }
                    
                    let date = (timestamp as! Timestamp).dateValue()
                    let newItem = SenseItem(item: itemText as! String, timestamp: date)
                    items[Sense.Sound]!.append(newItem)
                }
                userDoc.collection("touch-items").getDocuments() { snapshot, err in
                    if err != nil {
                        return
                    }
                    
                    for doc in snapshot!.documents {
                        
                        guard let itemText = doc.data()["item"] else {
                            continue
                        }
                        
                        guard let timestamp = doc.data()["added"] else {
                            continue
                        }
                        
                        let date = (timestamp as! Timestamp).dateValue()
                        let newItem = SenseItem(item: itemText as! String, timestamp: date)
                        items[Sense.Touch]!.append(newItem)
                    }
                    
                    userDoc.collection("smell-items").getDocuments() { snapshot, err in
                        if err != nil {
                            return
                        }
                        
                        for doc in snapshot!.documents {
                            
                            guard let itemText = doc.data()["item"] else {
                                continue
                            }
                            
                            guard let timestamp = doc.data()["added"] else {
                                continue
                            }
                            
                            let date = (timestamp as! Timestamp).dateValue()
                            let newItem = SenseItem(item: itemText as! String, timestamp: date)
                            items[Sense.Smell]!.append(newItem)
                        }
                        
                        userDoc.collection("taste-items").getDocuments() { snapshot, err in
                            if err != nil {
                                return
                            }
                            
                            for doc in snapshot!.documents {
                                
                                guard let itemText = doc.data()["item"] else {
                                    continue
                                }
                                
                                guard let timestamp = doc.data()["added"] else {
                                    continue
                                }
                                
                                let date = (timestamp as! Timestamp).dateValue()
                                let newItem = SenseItem(item: itemText as! String, timestamp: date)
                                items[Sense.Taste]!.append(newItem)
                            }
                            completion(items)
                        }
                    }
                }
            }
            
        }
    }
    
    static func getSetOfSenseItems(completion: @escaping (_: [Sense: SenseItem]) -> Void) {
            guard let user = Auth.auth().currentUser else {
                print("User not logged in")
                return
            }
            
            var items: [Sense: SenseItem] = [:]
            let userDoc = Firestore.firestore().collection("users").document(user.uid)
            
            let senses: [Sense: String] = [
                .Sight: "sight-items",
                .Sound: "sound-items",
                .Touch: "touch-items",
                .Smell: "smell-items",
                .Taste: "taste-items"
            ]
            
            let group = DispatchGroup()
            
            for (sense, collectionName) in senses {
                group.enter()
                // Attempt to fetch based on a random key first
                let randomValue = Double.random(in: 0..<1)
                attemptFetchSet(userDoc: userDoc, collectionName: collectionName, sense: sense, randomValue: randomValue) { success, item in
                    if success, let item = item {
                        items[sense] = item
                    } else {
                        // Fallback: Fetch the most recently added item if random fetch fails
                        fallbackFetchSet(userDoc: userDoc, collectionName: collectionName, sense: sense) { fallbackItem in
                            if let fallbackItem = fallbackItem {
                                items[sense] = fallbackItem
                            }
                            group.leave()
                        }
                        return
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(items)
            }
        }
        
        private static func attemptFetchSet(userDoc: DocumentReference, collectionName: String, sense: Sense, randomValue: Double, completion: @escaping (_ success: Bool, _ item: SenseItem?) -> Void) {
            userDoc.collection(collectionName)
                .whereField("key", isGreaterThanOrEqualTo: randomValue)
                .order(by: "key")
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let document = querySnapshot?.documents.first,
                       let itemValue = document.data()["item"] as? String,
                       let timestampValue = document.data()["added"] as? Timestamp {
                        let item = SenseItem(item: itemValue, timestamp: timestampValue.dateValue())
                        completion(true, item)
                    } else {
                        completion(false, nil)
                    }
                }
        }
        
        private static func fallbackFetchSet(userDoc: DocumentReference, collectionName: String, sense: Sense, completion: @escaping (_ item: SenseItem?) -> Void) {
            userDoc.collection(collectionName)
                .order(by: "added", descending: true) // Fetch the most recently added item
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let document = querySnapshot?.documents.first,
                       let itemValue = document.data()["item"] as? String,
                       let timestampValue = document.data()["added"] as? Timestamp {
                        let item = SenseItem(item: itemValue, timestamp: timestampValue.dateValue())
                        completion(item)
                    } else {
                        completion(nil)
                    }
                }
        }

}
