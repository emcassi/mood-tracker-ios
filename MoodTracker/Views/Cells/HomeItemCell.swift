//
//  HomeItemCell.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/7/22.
//

import Foundation
import UIKit

class HomeItemCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
                cell.backgroundColor = UIColor(named: "mood-sad")
            case "Fearful":
                cell.backgroundColor = UIColor(named: "mood-fearful")
            case "Disgusted":
                cell.backgroundColor = UIColor(named: "mood-disgusted")
            case "Angry":
                cell.backgroundColor = UIColor(named: "mood-angry")
            case "Happy":
                cell.backgroundColor = UIColor(named: "mood-happy")
            case "Surprised":
                cell.backgroundColor = UIColor(named: "mood-surprised")
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
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor(named: "info")
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
        label.textColor = UIColor(named: "label")
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
        moodsView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        moodsView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        moodsView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        detailsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: moodsView.bottomAnchor, constant: 10).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "panel-color")
        layer.borderColor = UIColor(named: "panel-color")?.cgColor
        layer.borderWidth = 0.0
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

