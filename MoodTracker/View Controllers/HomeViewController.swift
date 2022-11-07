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
    
    var items: [MoodsItem] = []
    var grouped: [Date: [MoodsItem]]?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moods-item", for: indexPath) as! HomeItemCell
        
        if let grouped = grouped {
            let keys = Array(grouped.keys)
            
           
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let grouped = grouped {
            let keys = Array(grouped.keys)
            
            if let itemsByDate = grouped.first(where: { $0.key == keys[section] }) {
                
                let calendar = Calendar(identifier: .gregorian)
                
                if calendar.isDate(itemsByDate.key, inSameDayAs: Date.now) {
                    return "Today"
                }
                
                let df = DateFormatter()
                df.timeZone = calendar.timeZone
                df.dateFormat = "EEEE, MMM d, yyyy"

                return df.string(from: itemsByDate.key)
            }
        }
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor(named: "lighter")
            headerView.backgroundView?.backgroundColor = .black
            headerView.textLabel?.textColor = .white
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let grouped = grouped {
            return grouped.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let grouped = grouped {
            let keys = Array(grouped.keys)
            
            if let numItemsByDate = grouped.first(where: { $0.key == keys[section] })?.value.count {
                print(numItemsByDate)
                return numItemsByDate
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getItems()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPressed))
        
        view.backgroundColor = UIColor(r: 50, g: 66, b: 92)
        
        tableView.register(HomeItemCell.self, forCellReuseIdentifier: "moods-item")
    }
    
    func getItems(){
        if let navVC = navigationController as? NavVC {

            self.items = []
            
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("items").whereField("user", isEqualTo: user.uid).order(by: "timestamp", descending: true).getDocuments() { snapshot, error in
                    if let error = error {
                        print(error)
                    } else if let snapshot = snapshot {
                        print(snapshot.count)
                        
                        
                        
                        for document in snapshot.documents {
                            let data = document.data()
                            
                            if let moodsDict = data["moods"] as? [[String: String]] {
                                
                                var itemMoods: [Mood] = []
                                
                                for moodDict in moodsDict {
                                    if let name = moodDict["name"], let section = moodDict["section"] {
                                        itemMoods.append(Mood(name: name, section: section))
                                    }
                                }
                                
                                if let details = data["details"] as? String, let timestamp = data["timestamp"] as? Timestamp {
                                   let date = timestamp.dateValue()
                                    let item = MoodsItem(moods: itemMoods, details: details, timestamp: date)
                                    self.items.append(item)
                                } else {
                                    print("error with deets or dates")
                                }
                            }
                        
                        }
                        
                        let calendar = Calendar(identifier: .gregorian)
                        
                        let grouped = Dictionary(grouping: self.items.sorted(by: { ($0.timestamp ?? Date.distantPast) < ( $1.timestamp ?? Date.distantPast ) }), by: { calendar.startOfDay(for: $0.timestamp ?? Date.distantPast) })
                        self.grouped = grouped
                        
                        self.tableView.reloadData()
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

