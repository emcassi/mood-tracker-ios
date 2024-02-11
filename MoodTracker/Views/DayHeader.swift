//
//  DayHeader.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/17/22.
//

import Foundation
import UIKit
import Charts

class DayHeader: UIView {
    
    let navController: UINavigationController!
    let items: [MoodsItem]
        
    let categories = ["Sad", "Fearful", "Disgusted", "Angry", "Happy", "Surprised"]
    var moodCounters: [Double] = []

    var chartView: PieChartView!
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "label")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let overviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Overview", for: .normal)
        button.setTitleColor(UIColor(named: "lighter"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init(nc: UINavigationController, items: [MoodsItem]){
        self.navController = nc
        self.items = items
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "bg-color")
        initMoodCounters()
        getAllMoods()
        chartView = PieChartView(frame: CGRect(x:navController.view.frame.width - 72,y:-16,width: 64 ,height:64))
        chartView.drawEntryLabelsEnabled = false
        customizeChart(dataPoints: categories, values: moodCounters)
        
        addSubview(dateLabel)
        addSubview(chartView)

//        addSubview(overviewButton)
//
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews(){
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    @objc func buttonTapped(){
        self.navController.present(DayOverviewViewController(items: items), animated: true)
    }
    
    func initMoodCounters(){
        for _ in 0...categories.count {
            moodCounters.append(0)
        }
    }
    
    func getAllMoods(){
        
        for item in items {
            for mood in item.moods {
                switch mood.section {
                case categories[0]:
                    moodCounters[0] += 1
                case categories[1]:
                    moodCounters[1] += 1
                case categories[2]:
                    moodCounters[2] += 1
                case categories[3]:
                    moodCounters[3] += 1
                case categories[4]:
                    moodCounters[4] += 1
                case categories[5]:
                    moodCounters[5] += 1
                default:
                    break
                }
            }
        }
        
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        chartView.legend.enabled = false
        chartView.isUserInteractionEnabled = false
        chartView.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .easeOutCirc)
        chartView.drawHoleEnabled = false
        // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry)
      }
      // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
      pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        pieChartDataSet.drawValuesEnabled = false
      // 3. Set ChartData
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      let format = NumberFormatter()
        format.numberStyle = .decimal
        format.maximumFractionDigits = 0
      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      // 4. Assign it to the chart’s data
      chartView.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        
        var colors: [UIColor] = []
        for category in categories {
            
            switch category {
            case "Sad":
                colors.append(UIColor(named: "mood-sad")!)
            case "Fearful":
                colors.append(UIColor(named: "mood-fearful")!)
            case "Disgusted":
                colors.append(UIColor(named: "mood-disgusted")!)
            case "Angry":
                colors.append(UIColor(named: "mood-angry")!)
            case "Happy":
                colors.append(UIColor(named: "mood-happy")!)
            case "Surprised":
                colors.append(UIColor(named: "mood-surprised")!)
            default:
                break
            }
        }
     
      return colors
    }
}
