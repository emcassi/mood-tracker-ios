//
//  ProsConsViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/23/24.
//

import Foundation
import UIKit

class ProsConsViewController: UITableViewController {
    
    var header: ProsConsHeaderView?
    var item: ProsCons
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.tintColor = UIColor(named: "light")
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 48
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        
        header = ProsConsHeaderView(parent: self, item: item, width: view.frame.width)
        
        addButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        
        view.addSubview(addButton)
        
        tableView.tableHeaderView = header
        tableView.register(ProConCell.self, forCellReuseIdentifier: "pro-con-cell")
        
        setupSubviews()
    }
    
    func setupSubviews() {
        addButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 96).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 96).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        header?.scoreboard.dealWithWinner()
    }
    
    init(item: ProsCons) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pros"
        case 1:
            return "Cons"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pro-con-cell", for: indexPath) as! ProConCell
        guard let user = AuthManager.user else {
            return cell
        }
        guard let situation = user.prosCons.first(where: { $0.id == item.id}) else {
            return cell
        }
        switch indexPath.section {
        case 0:
            cell.title.text = situation.pros[indexPath.row].title
            break
        case 1:
            cell.title.text = situation.cons[indexPath.row].title
            break
        default:
            return cell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = AuthManager.user else {
            return 0
        }
        guard let situation = user.prosCons.first(where: { $0.id == item.id}) else {
            return 0
        }
        switch section {
        case 0:
            return situation.pros.count
        case 1:
            return situation.cons.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc func addPressed() {
        present(NewProConViewController(item: item, parent: self), animated: true)
    }
    
    func updateScoreboard() {
        guard let user = AuthManager.user else {
            AuthManager().logout()
            return
        }
        guard let situation = user.prosCons.first(where: { $0.id == item.id }) else {
            return
        }
        header!.scoreboard.items = (ScoreboardItem(name: "Pros", score: situation.pros.count), ScoreboardItem(name: "Cons", score: situation.cons.count))
        print("Pros: \(situation.pros.count), Cons: ")
        header!.scoreboard.dealWithWinner()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
