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
    
    @IBOutlet weak var activityPieChartView: PieChartView!
    @IBOutlet weak var locationPieChartView: PieChartView!
    @IBOutlet weak var timeSegment: UISegmentedControl!
    
    var activities: [String] = []
    var location: [String] = []
    var activityHourData: [Double] = []
    var locationHourData: [Double] = []
    var orange: [Int] = [120, 29, 0]
    //var orange: [Int] = [20, 20, 0]
    var blue: [Int] = [0, 29, 120]
    
    func updateHours(timeType: Int){
        let actDict = AppState.sharedInstance.activityDict
        let locDict = AppState.sharedInstance.locationDict
        
        // update slices and their values
        activities = DataProcessor.generateSliceTypes(actDict, timeType: timeType)
        location = DataProcessor.generateSliceTypes(locDict, timeType: timeType)
        activityHourData = DataProcessor.generateSliceValues(actDict, slices: activities, timeType: timeType)
        locationHourData = DataProcessor.generateSliceValues(locDict, slices: location, timeType: timeType)
        
        // animate and set up the charts
        activityPieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        locationPieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        setChart(activities, values: activityHourData, pieChartView: activityPieChartView, baseColor: blue)
        setChart(location, values: locationHourData, pieChartView: locationPieChartView, baseColor: orange)
    }
    
    @IBAction func updateTimeSegment(sender: UISegmentedControl){
        updateHours(sender.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(AppState.sharedInstance.activityDict)
        self.activityPieChartView.noDataText = "No recent data"
        self.locationPieChartView.noDataText = "No recent data"
        // Do any additional setup after loading the view.
        updateHours(0)
    }
    
    func setChart(dataPoints: [String], values: [Double], pieChartView: PieChartView, baseColor: [Int]) {
        // creating an array of data entries
        let dataEntries = dataPoints.indices.map { ChartDataEntry(value: values[$0], xIndex: $0) }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Hours Spent")
        var colors: [UIColor] = []
        var rgb = baseColor
        
        let increment = (dataPoints.isEmpty) ? 0 : 255/dataPoints.count
        
        for _ in dataPoints.indices {
            let color = UIColor(red: rgb[0], green: rgb[1], blue: rgb[2])
            colors.append(color)
            pieChartDataSet.colors = colors
            
            // lighten color for next slide
            for i in rgb.indices {
                if (rgb[i] + increment <= 255 && rgb[i] != 0){
                    rgb[i] += increment
                }
            }
        }
        pieChartView.drawSliceTextEnabled = false
        pieChartView.holeTransparent = true
        pieChartView.holeColor = nil
        // set data here
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
    }
}
