//
//  HomeViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/6/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UITableViewController {
    
    var moods: [Mood] = []
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mood-cell", for: indexPath) as! HomeItemCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moods.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Mood History"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMoods()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPressed))
        
        view.backgroundColor = UIColor(r: 50, g: 66, b: 92)
    }
    
    func getMoods(){
        if let navVC = navigationController as? NavVC {
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("items").whereField("user", isEqualTo: user.uid).getDocuments() { snapshot, error in
                    if let error = error {
                        print(error)
                    } else if let snapshot = snapshot {
                        print(snapshot.count)
                        
                        self.moods = []
                        
                        for document in snapshot.documents {
                            let data = document.data()
                            
                            if let moodsDict = data["moods"] as? [[String: String]] {
                                for moodDict in moodsDict {
                                    if let name = moodDict["name"], let section = moodDict["section"] {
                                        self.moods.append(Mood(name: name, section: section))
                                    }
                                }
                            }
                        
                        }
                        
                        print(self.moods)
                    }
                }
            } else {
                print("No user signed in")
            }
        } else {
            print("cant cast to navvc")
        }
    }
    
    @objc func settingsPressed(){
        
    }
    
    @objc func addPressed(){
        navigationController?.pushViewController(SelectMoodsViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
}

class HomeItemCell: UITableViewCell {
    
}
