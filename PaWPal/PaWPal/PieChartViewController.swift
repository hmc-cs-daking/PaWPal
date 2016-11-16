//
//  PieChartViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 11/3/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit
import Charts

class PieChartViewController: UIViewController {
    
//    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var activityPieChartView: PieChartView!
    @IBOutlet weak var locationPieChartView: PieChartView!
    @IBOutlet weak var timeSegment: UISegmentedControl!
    
    
    let activities: [String] = ["Partyyy", "Homework", "Class", "Eating", "More Partayy", "Drugs"]
    let location: [String] = ["Room", "Platt", "Shan", "Hoch", "Linde", "Space"]
    let dayHours: [Double] = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    let weekHours: [Double] = [20.0, 50.0, 90.0, 12.0, 60.0, 40.0]
    
    func updateHours(timeData: [Double]){
        activityPieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        locationPieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        setChart(activities, values: timeData, pieChartView: activityPieChartView)
        setChart(location, values: timeData, pieChartView: locationPieChartView)
    }
    
    @IBAction func updateTimeSegment(sender: UISegmentedControl){
        if (sender.selectedSegmentIndex == 0){
            updateHours(dayHours)
        }
        else if (sender.selectedSegmentIndex == 1){
            updateHours(weekHours)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateHours(dayHours)
    }
    
    func setChart(dataPoints: [String], values: [Double], pieChartView: PieChartView) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Hours Spent")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Int(arc4random_uniform(256))
            let green = Int(arc4random_uniform(256))
            let blue = Int(arc4random_uniform(256))
            
            let color = UIColor(red: red, green: green, blue: blue)
            colors.append(color)
        }
        pieChartDataSet.colors = colors
    }
}
