//
//  MoodDetailsViewController.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/10/24.
//

import Foundation
import UIKit
import Charts

class MoodDetailsViewController : UIViewController {
    
    let values: [Double]
    
    var chartView: PieChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        customizeChart(dataPoints: MoodsManager.categories, values: values)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg-color")
        chartView = PieChartView(frame: CGRect(x: 0, y: 0 ,width: 400,height: 400))
        chartView.drawEntryLabelsEnabled = true
        
        view.addSubview(chartView)
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
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: dataPoints[0])
        pieChartDataSet.colors = ChartManager.colorsOfCharts(numbersOfColor: dataPoints.count)
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
    
    init(values: [Double]) {
        self.values = values
        super.init();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
