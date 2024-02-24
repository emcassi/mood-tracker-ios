//
//  ProsConsOverviewViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/22/24.
//

import Foundation
import UIKit

class ProsConsOverviewViewController: UITableViewController {

    var header: ProsConsOverviewHeaderView?
    
    let addButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "light")
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 48
        button.layer.zPosition = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        
        tableView.layer.zPosition = 2
        tableView.register(ProsConsOverviewCell.self, forCellReuseIdentifier:  "pros-cons-overview-cell" )
        
        header = ProsConsOverviewHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        tableView.tableHeaderView = header!
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        view.addSubview(addButton)
        addButton.layer.zPosition = 100
        setupSubviews()
    }
    
    func setupSubviews() {
        addButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 96).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 96).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pros-cons-overview-cell", for: indexPath) as! ProsConsOverviewCell
        guard let user = AuthManager.user else { return cell }
        let item = user.prosCons[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.item = item
        cell.parent = self
        cell.setDate(date: item.updatedAt)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = AuthManager.user else { return 0 }
        
        return user.prosCons.count
    }
    
    @objc func addButtonPressed() {
        let addVC = NewProsConsViewController()
        addVC.parentVC = self
        present(addVC, animated: true)
    }
}
