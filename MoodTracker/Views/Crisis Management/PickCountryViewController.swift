//
//  HotlinesByCountryViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/24/24.
//

import Foundation
import UIKit

class PickCountryViewController: UITableViewController {
    
    var allCountries: [HotlineCountry] = []
    var countries: [HotlineCountry] = []
    
    let searchBar = TextField(placeholder: "Search")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        tableView.register(HotlineCountryCell.self, forCellReuseIdentifier: "hotline-country-cell")
        searchBar.textField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
        allCountries = HotlineManager.getCountries()
        countries = allCountries
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotline-country-cell", for: indexPath) as! HotlineCountryCell
        cell.country = countries[indexPath.row]
        cell.setupCountryInfo()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func searchChanged() {
        if let term = searchBar.textField.text {
            if term.isEmpty {
                countries = allCountries
            } else {
                countries = HotlineManager.searchCountries(term: searchBar.textField.text!)
            }
        } else {
            countries = allCountries
        }
        
        tableView.reloadData()
    }
}
