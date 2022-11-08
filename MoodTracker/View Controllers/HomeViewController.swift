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
    
    var grouped: [Date: [MoodsItem]]?
    var groupedKeys: [Date]?
    let df = DateFormatter()
    let calendar = Calendar(identifier: .gregorian)
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't logged any moods yet? Add now?"
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emptyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 15
        button.isHidden = true
        button.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        getItems()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsPressed))
        navigationItem.title = "Mood Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPressed))

        df.timeZone = calendar.timeZone
        
        view.backgroundColor = UIColor(r: 50, g: 66, b: 92)
        
        view.addSubview(emptyLabel)
        view.addSubview(emptyButton)
        setupSubviews()
        
        tableView.register(HomeItemCell.self, forCellReuseIdentifier: "moods-item")
    }
    
    func setupSubviews(){
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        emptyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        emptyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyButton.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 10).isActive = true
        emptyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        emptyButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func getItems(){
        if let navVC = navigationController as? NavVC {

            var items: [MoodsItem] = []
            
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("users").document(user.uid).collection("items").whereField("user", isEqualTo: user.uid).order(by: "timestamp", descending: true).getDocuments() { snapshot, error in
                    if let error = error {
                        print(error)
                    } else if let snapshot = snapshot {
                        
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
                                    items.append(item)
                                } else {
                                    print("error with deets or dates")
                                }
                            }
                            
                        }
                        
                        let calendar = Calendar(identifier: .gregorian)
                        
                        var grouped = Dictionary(grouping: items.sorted(by: { ($0.timestamp ) < ( $1.timestamp ) }), by: { calendar.startOfDay(for: $0.timestamp ) })
                        
                        self.grouped = grouped
                        
                        self.emptyLabel.isHidden = grouped.count > 0
                        self.emptyButton.isHidden = grouped.count > 0
                        
                        let i = 0
                        
                        let items: [Any]
                        
                        
                        self.groupedKeys = Array(grouped.keys).sorted(by: { $0 > $1 })
                          
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
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc func addPressed(){
        navigationController?.pushViewController(SelectMoodsViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moods-item", for: indexPath) as! HomeItemCell
        
        if let grouped = grouped, let groupedKeys = groupedKeys {
            
            if let itemsForDay = grouped.first(where: { $0.key == groupedKeys[indexPath.section] }) {
                let itemForCell = itemsForDay.value[indexPath.row]
                let moodsString = MoodsManager().makeMoodsString(moods: itemForCell.moods )
                
                df.dateFormat = "hh:mm"
                let itemTime = df.string(from: itemForCell.timestamp)
                
                cell.updateCellWith(row: itemForCell.moods)
                
                cell.timeLabel.text = itemTime
                cell.detailsLabel.text = itemForCell.details
            } else {
                print("error in cell")
            }
        } else {
            print("error gropued")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let grouped = grouped, let groupedKeys = groupedKeys {
            if let itemsByDate = grouped.first(where: { $0.key == groupedKeys[section] }) {
                
                
                if calendar.isDate(itemsByDate.key, inSameDayAs: Date.now) {
                    return "Today"
                }
                
                df.dateFormat = "EEEE, MMM d, yyyy"
                
                return df.string(from: itemsByDate.key)
            }
        }
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor(named: "bg-color")
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
        
        if let grouped = grouped, let groupedKeys = groupedKeys {
                        
            if let numItemsByDate = grouped.first(where: { $0.key == groupedKeys[section] })?.value.count {
                return numItemsByDate
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

