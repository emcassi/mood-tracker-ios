//
//  HomeItemCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/7/22.
//

import Foundation
import UIKit

class HomeItemCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var item: MoodsItem? = nil
        
    func updateCellWith(item: MoodsItem) {
        self.item = item
        self.moodsView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.item!.moods.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // Set the data for each cell (color and color name)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "home-mood", for: indexPath) as? HomeMoodCell {
            
            switch self.item!.moods[indexPath.item].section {
            case "Sad":
                cell.backgroundColor = UIColor(named: "mood-blue")
            case "Peaceful":
                cell.backgroundColor = UIColor(named: "mood-aqua")
            case "Powerful":
                cell.backgroundColor = UIColor(named: "mood-yellow")
            case "Joyful":
                cell.backgroundColor = UIColor(named: "mood-orange")
            case "Mad":
                cell.backgroundColor = UIColor(named: "mood-red")
            case "Scared":
                cell.backgroundColor = UIColor(named: "mood-purple")
            default:
                cell.backgroundColor = .gray
            }
            
            cell.moodLabel.text = self.item!.moods[indexPath.item].name
            return cell
        }
        return UICollectionViewCell()
    }
    
    // Add spaces at the beginning and the end of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor(gray: 200)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let moodsView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 90, height: 30)
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.minimumInteritemSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
      
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupSubviews(){
        timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        
//        moodsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        moodsLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
//        moodsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
//        moodsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        moodsView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10).isActive = true
        moodsView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        moodsView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        moodsView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        detailsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: moodsView.bottomAnchor, constant: 10).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(gray: 100)
        layer.borderColor = UIColor(gray: 200).cgColor
        layer.borderWidth = 0.5
        selectionStyle = .none
        self.moodsView.showsHorizontalScrollIndicator = false
        
        self.moodsView.dataSource = self
        self.moodsView.delegate = self
        
        self.moodsView.register(HomeMoodCell.self, forCellWithReuseIdentifier: "home-mood")
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewPressed))
        self.addGestureRecognizer(tapGR)
        
        contentView.addSubview(timeLabel)
//        addSubview(moodsLabel)
        contentView.addSubview(moodsView)
        contentView.addSubview(detailsLabel)
        
        setupSubviews()
    }
    
    @objc func viewPressed(){
        ((self.next?.next) as? UITableViewController)?.navigationController?.pushViewController(EditItemViewController(item: item!), animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   }

