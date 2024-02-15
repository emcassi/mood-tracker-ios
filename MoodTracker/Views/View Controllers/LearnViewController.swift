//
//  LearnViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/15/24.
//

import Foundation
import UIKit

class LearnViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        tableView.register(LearnItemCell.self, forCellReuseIdentifier: "learn-cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "learn-cell", for: indexPath) as! LearnItemCell
        let item = LearnManager.items[indexPath.row]
        cell.item = item
        cell.nameLabel.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LearnManager.items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = LearnManager.items[indexPath.row]
        let learn = LearnBaseViewController(learnItem: item)
        learn.isModalInPresentation = true
        navigationController?.present(learn, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
