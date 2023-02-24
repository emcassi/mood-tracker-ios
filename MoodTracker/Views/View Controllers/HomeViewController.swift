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
import StoreKit

class HomeViewController: UITableViewController {
    
    var hasAskedForReview = false
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
        navigationController?.navigationBar.tintColor = UIColor(named: "lighter")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPressed))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPressed)), UIBarButtonItem(image: UIImage(systemName: "a.circle"), style: .plain, target: self, action: #selector(affirmationPressed))]
        df.timeZone = calendar.timeZone
        
        view.backgroundColor = UIColor(named: "bg-color")
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
    
    func getItems() {

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
                                let item = MoodsItem(id: document.documentID, moods: itemMoods, details: details, timestamp: date)
                                items.append(item)
                            } else {
                                print("error with deets or dates")
                            }
                        }
                        
                    }
                    
                    let calendar = Calendar(identifier: .gregorian)
                    
                    var grouped = Dictionary(grouping: items.sorted(by: { ($0.timestamp ) < ( $1.timestamp ) }), by: { calendar.startOfDay(for: $0.timestamp ) })
                    print(grouped)
                    self.grouped = grouped
                    
                    self.emptyLabel.isHidden = grouped.count > 0
                    self.emptyButton.isHidden = grouped.count > 0
                    
                    self.groupedKeys = Array(grouped.keys).sorted(by: { $0 > $1 })
                    
                    self.tableView.reloadData()
                    
                    if items.count > 5 && !self.hasAskedForReview {
                        self.hasAskedForReview = true
                        if let windowScene = self.view.window?.windowScene {
                                     SKStoreReviewController.requestReview(in: windowScene)
                                }
                    }
                }
            }
        } else {
            print("No user signed in")
        }
    }
    
    @objc func settingsPressed(){
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc func affirmationPressed(){
        navigationController?.pushViewController(AffirmationsViewController(), animated: true)
    }
    
    @objc func addPressed(){
        navigationController?.pushViewController(SelectMoodsViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moods-item", for: indexPath) as! HomeItemCell
        
        if let grouped = grouped, let groupedKeys = groupedKeys {
            
            if let itemsForDay = grouped.first(where: { $0.key == groupedKeys[indexPath.section] }) {
                                
                let itemForCell = itemsForDay.value.sorted(by: {$0.timestamp > $1.timestamp } )[indexPath.row]
                let moodsString = MoodsManager().makeMoodsString(moods: itemForCell.moods )
                
                df.dateFormat = "h:mm a"
                df.amSymbol = "AM"
                df.pmSymbol = "PM"
                let itemTime = df.string(from: itemForCell.timestamp)
                
                cell.updateCellWith(item: itemForCell)
                
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
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let grouped = grouped, let groupedKeys = groupedKeys {
//            if let itemsByDate = grouped.first(where: { $0.key == groupedKeys[section] }) {
//
//
//                if calendar.isDate(itemsByDate.key, inSameDayAs: Date.now) {
//                    return "Today"
//                }
//
//                df.dateFormat = "EEEE, MMM d, yyyy"
//
//                return df.string(from: itemsByDate.key)
//            }
//        }
//
//        return ""
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let grouped = grouped, let groupedKeys = groupedKeys {
            var date = ""
            if let itemsByDate = grouped.first(where: { $0.key == groupedKeys[section] }) {
                
                
                if calendar.isDate(itemsByDate.key, inSameDayAs: Date.now) {
                    date = "Today"
                } else {
                    
                    df.dateFormat = "EEEE, MMM d, yyyy"
                    
                    date = df.string(from: itemsByDate.key)
                }
                
                if let navigationController = navigationController {
                    let view = DayHeader(nc: navigationController, items: itemsByDate.value)
                    view.dateLabel.text = date
                    return view
                }
                
            }
        }
        
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
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

