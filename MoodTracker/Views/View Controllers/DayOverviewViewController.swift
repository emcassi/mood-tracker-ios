//
//  DayOverviewViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/17/22.
//

import Foundation
import UIKit
import Charts

class DayOverviewViewController: UIViewController {
    
    
    let items: [MoodsItem]
    
    let categories = ["Sad", "Mad", "Joyful", "Powerful", "Scared", "Peaceful"]
    var moodCounters: [Double] = []
    
    let scrollView = UIScrollView()
//    let tableView = co
    
    var chartView: PieChartView!
    
    init(items: [MoodsItem]){
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg-color")
        chartView = PieChartView(frame: CGRect(x:0,y:0,width: view.frame.width ,height:400))
        initMoodCounters()
        getAllMoods()

        view.addSubview(scrollView)
        scrollView.addSubview(chartView)
        customizeChart(dataPoints: categories, values: moodCounters)
        setupSubviews()
    }
    
    func setupSubviews(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
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
                colors.append(UIColor(named: "mood-blue")!)
            case "Peaceful":
                colors.append(UIColor(named: "mood-aqua")!)
            case "Powerful":
                colors.append(UIColor(named: "mood-yellow")!)
            case "Joyful":
                colors.append(UIColor(named: "mood-orange")!)
            case "Mad":
                colors.append(UIColor(named: "mood-red")!)
            case "Scared":
                colors.append(UIColor(named: "mood-purple")!)
            default:
                break
            }
        }
     
      return colors
    }
}
