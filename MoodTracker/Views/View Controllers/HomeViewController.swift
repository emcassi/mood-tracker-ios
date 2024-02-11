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
        label.text = "You haven't logged anything yet? Start now?"
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emptyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
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
    
    let addButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "bg-color")
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.backgroundColor = UIColor(named: "info")
        button.layer.cornerRadius = 40
        button.layer.zPosition = 100
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 3
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
        navigationItem.title = "Mudi"
        navigationController?.navigationBar.tintColor = UIColor(named: "lighter")
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPressed))]
        df.timeZone = calendar.timeZone
        
        view.backgroundColor = UIColor(named: "bg-color")
        view.addSubview(emptyLabel)
        view.addSubview(emptyButton)
        view.addSubview(addButton)
        setupSubviews()
        
        tableView.contentInset.bottom = 100
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
        
        addButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
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
                    self.grouped = grouped
                    
                    self.emptyLabel.isHidden = grouped.count > 0
                    self.emptyButton.isHidden = grouped.count > 0
                    
                    self.groupedKeys = Array(grouped.keys).sorted(by: { $0 > $1 })
                    
                    self.tableView.reloadData()
                    
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
            headerView.textLabel?.textColor = UIColor(named: "label")
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let grouped = grouped, let groupedKeys = groupedKeys {
            
            if let itemsForDay = grouped.first(where: { $0.key == groupedKeys[indexPath.section] }) {
                
                let itemForCell = itemsForDay.value.sorted(by: {$0.timestamp > $1.timestamp } )[indexPath.row]
                
                let deleteAction = UISwipeActionsConfiguration(actions: [ UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, completionHandler in
                    if let user = Auth.auth().currentUser {
                        
                        let confirmAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
                        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .destructive) { action in
                            Firestore.firestore().collection("users").document(user.uid).collection("items").document(itemForCell.id).delete { error in
                                if let error = error {
                                    print(error)
                                    
                                    let errAlert = UIAlertController(title: "An error occurred", message: "Please try again later", preferredStyle: .alert)
                                    errAlert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                                        errAlert.dismiss(animated: true)
                                    })
                                    
                                    self.present(errAlert, animated: true)
                                } else {
                                    self.getItems()
                                    confirmAlert.dismiss(animated: true)

                                }
                            }
                        })
                        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                            confirmAlert.dismiss(animated: true)
                        })

                        self.present(confirmAlert, animated: true)
                    }
                })])
                
                return deleteAction
                
            }
            
        }
        
        return nil
    }
}

